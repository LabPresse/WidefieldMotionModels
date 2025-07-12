**WideFieldMotionModels**

The software presented here accompanies our scientific article [How Easy Is It to Learn Motion Models in Widefield Fluorescence Microscopy](https://arxiv.org/abs/2507.05599). The data used in our article, is available for download at [Zenodo](https://zenodo.org/records/15845741).

**I: Data Generation**

*a: Trajectories*

    New trajectories of both anomalous and normal diffusion can be simulated using our codes in the directory "WidefieldMotionModels/Simulation/":
        "simulateATTM.m" (Anomalous Diffusion)
        "simulateCTRW.m" (Anomalous Diffusion)
        "simulateBM.m"   (Normal    Diffusion)
        "simulateDBM.m"  (Normal    Diffusion)
        "simulateFBM.m"  (Anomalous Diffusion)
        "simulateLW.m"   (Anomalous Diffusion)
        "simulateSBM.m"  (Anomalous Diffusion)
        
    For reproduction of the data in our article, trajectories of anomalous diffusion can be re-simulated from our code "AnDi.py" that calls upon the [AnDi Challenge repository](https://github.com/AnDiChallenge/andi_datasets). This code has a fixed pseudorandom number generator to produce the same trajectories featured in our [article](https://arxiv.org/abs/2507.05599). Pre-prepared files include: {"BM.m","DBM", "ATTM(0.5)","ATTM(1)", "CTRW(0.5)","CTRW(1)", "FBM(0.5)","FBM(1)","FBM(1.5)", "LW(1.5),LW(2)", "SBM(0.5)","SBM(1)","SBM(1.5)","SBM(2)"}.

  *b: Photoelectron Loads and EMCCD Measurements*
  
        "simulateEmission.m"
          Takes as input either 
            (i) the output of "simulate{⋅}", where {⋅} denotes one of the motion models featured in our article (i.e., BM, DBM, ATTM, CTRW, FBM, LW, SBM), or
            (ii) one of the pre-prepared files.

  *c: Data Preparation:*
  
        "Prepare.m" takes the output of simulate{⋅} or the data loaded from one of the pre-prepared files; this function saves its output as "Prepared{⋅}.m".

**II: Track Diffusing Particles**

    To perform Bayesian inference of SPT data, run the function below as Infer{"⋅"}, where ⋅ denotes one of the motion models featured in our [article](https://arxiv.org/abs/2507.05599).
    "Infer.m"
      Takes as primary input the name of a motion model "{⋅}" saved as "Data/Prepared{⋅}.m".

**III: Learn Motion Models**

    Until we obtain permission to upload working versions of the motion model classifiers [CONDOR](https://github.com/sam-labUCL/CONDOR/tree/main) and [AnomDiffDB](https://github.com/AnomDiffDB/DB), we provide details on how to operate them.

    (1) First, use "generateInput.m" to produce the desired data files in their appropriate directories.
    (2) Use the original third-party codes as described:
      *a: AnomDiffDB*
        First, modify "util.py" as follows:
          Modify line [12] FROM "from stochastic import diffusion" TO "from stochastic.processes import diffusion"

        Second, modify "classification_net_testing.py" as follows:
          Uncomment-out line [43] and comment out the line below [44] to use the pre-trained network.
          Insert the line "!pip install mat73;    import mat73" above line [40], which reads "def classification_on_file(file):".
          Modify the line [##] FROM "f = scipy.io.loadmat(file)" TO 
          At the bottom of the script, add the following lines to correct the outdated Keras syntax.
            "import h5py, json, numpy as np"
            "from pathlib import Path"
            "h5_path = Path(__file__).parent / "Models" / "classification_model_100_steps.h5""
            "with h5py.File(h5_path, "r+") as f:"
            "# Fix JSON stored in the file-level attribute:"
            "    if "training_config" in f.attrs:"
            "        raw = f.attrs["training_config"]"
            "        tc_json = raw.decode("utf-8") if isinstance(raw, (bytes, bytearray)) else raw"
            "        tc      = json.loads(tc_json)"
            ""
            "        opt_cfg = tc.get("optimizer_config", {}).get("config", {})"
            "        if "lr" in opt_cfg:"
            "            opt_cfg["learning_rate"] = opt_cfg.pop("lr")"
            "        opt_cfg.pop("decay", None) # removed in Keras 3"
            ""
            "        f.attrs.modify("training_config",np.string_(json.dumps(tc).encode("utf-8")))"
            ""
            "# Fix the lightweight copy inside /optimizer_weights:"
            "    ow = f.get("optimizer_weights")"
            "    if ow is not None and "lr" in ow.attrs:"
            "        ow.attrs["learning_rate"] = ow.attrs["lr"]"
            "        del ow.attrs["lr"]"

        Finally, execute our "useAnomDiffDB.py" for the desired file(s).

      *b: CONDOR*
        Nota bene: We verified that CONDOR works on MATLAB 2024a and MATLAB 2025a but not MATLAB 2024b.

        First, run "CONDOR.m", and then open the command window, where you will follow
          Respond "3" (or "2" if preferred) to the prompt, "What is the dimension (1,2,3)?" 
          Respond "n" to the prompt, "Would you like to train CONDOR networks for classification (y/n)?"
          Respond "n" to the prompt, "Would you like to train CONDOR networks for inference (y/n)?"
          Respond "y" to the prompt, "Would you like to predict the anomalous diffusion coefficient with CONDOR (y/n)?"




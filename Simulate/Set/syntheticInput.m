function Out = syntheticInput(varargin)  %  sIn ≡ syntheticInput.
%% Input   the random number generator's pseudorandom state
 %       & the tracer count, diffusivity, frames, or the FoV in Image Plane.
  if~nargin;         Seed   = 1 ;    
  else
    for                any  = 1 : nargin;          Any = varargin{any};
      if     isnumeric(Any)  ;        Iny   = inputname(any)          ;
          if           Iny  == "Seed"       ;      Seed     = Any     ;         
          elseif       Iny  == "Count"      ;      Count    = Any     ;
... Measurement Parameters:
          elseif       Iny  == "tFrame"     ;      tFrame   = Any     ;
          elseif       Iny  == "Frames"     ;      Frames   = Any     ;
          elseif       Iny  == "FoV"        ;      FoV      = Any     ;
          elseif       Iny  == "F"          ;      F        = Any     ;
          elseif       Iny  == "G"         ...
              ||       Iny  == "Gain"       ;      G        = Any     ;
          elseif       Iny  == "h"         ...
              ||       Iny  == "H"          ;      H        = Any     ;
%          end
... Motion      Parameters:
          elseif       Iny  == "D"         ...
              ||       Iny  == "Diffusivity";      D        = 5/100; % μm2/s
          end
      end
    end
  end

if~exist("Seed",'var')  ;  Seed     =  1;  end ;  Out.pseudoRandom.Seed = Seed ;    rng(Seed);
if~exist("Count",'var') ;  Out.M    =  1;  else;  Out.M = Count ;  end % Number of Emitters.
if~exist("Frames",'var');  Out.N    = 50;  else;  Out.N = Frames;  end % Number of Frames  .


%% Define Space      :
if~exist("FoV",'var');  Out.FoV = [32,32];  else;  Out.FoV = FoV;  end % Image Plane Field of View's [Width(x),Length(y)]
%% Define Time               :
if~exist("tFrame",'var')     ;    Out.Time.Frame = 33/1000;
else                         ;    Out.Time.Frame = tFrame ;
end
  Out.Time.Dead     = Out.Time.Frame / 11;    % 3/1000;
  Out.Time.Exposure = Out.Time.Frame - Out.Time.Dead;
%% Define Optical System  :
  Out.Optic = setOptic    ;
%% Spatiotemporal Bounds         :
  Out.Bounds = setBoundaries(Out);
%% Emission Parameters            :
  Out = setEmissionParameters(Out);
%% Spatiotemporal discretization         :
  Out = spatiotemporalDiscretization(Out);
%% Hyperparameters                   :
  Out.Prior = setHyperparameters(Out);
%% Motion Parameters            :
  Out = setMotionParameters(Out);
%% Ancillary Assignments             :
  Out.Units.Time   = '\mathrm{s}'    ;
  Out.Units.Length = '\mathrm{\mu m}';
  Out.Units.Image  = '\mathrm{ADU}'  ;
  Out.Help         = setHelp         ;
%% Save:
 % Folder = "Simulate/Input/";    fileType = ".mat";    saveFile = Folder + "sIn" + fileType;    save(saveFile,"sIn");
end
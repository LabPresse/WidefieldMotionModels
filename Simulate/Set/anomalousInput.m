function Out = anomalousInput(varargin)
%% Initialize no known motion model.
  if~nargin;         Seed  = 1;    
  else
    for               any  = 1 : nargin;                Any = varargin{any};
      if     isnumeric(Any)  ;        Iny   = inputname(any);
          if           Iny  == "Seed"    ;      Seed     = Any;           
          elseif       Iny  == "Count"   ;      Count    = Any; % ADD SUPPORT from syntheticInput
... Measurement Parameters:
          elseif       Iny  == "tFrame"  ;      tFrame   = Any; % ADD SUPPORT from syntheticInput
          elseif       Iny  == "Frames"  ;      Frames   = Any;
          elseif       Iny  == "FoV"     ;      FoV      = Any;
          elseif       Iny  == "F"       ;      F        = Any; % ADD SUPPORT from syntheticInput
          elseif       Iny  == "G"      ...
              ||       Iny  == "Gain"    ;      G        = Any; % ADD SUPPORT from syntheticInput
          elseif       Iny  == "h"      ...
              ||       Iny  == "H"       ;      H        = Any; % ADD SUPPORT from syntheticInput
... Motion      Parameters:
          elseif       Iny  == "Exponent"                   ...
              ||       Iny  == "alpha"   ;      Exponent = Any;
          end
      end
%{
      elseif  isstring(Any) || ischar(Any) || iscellstr(Any)
        if             Any  == "ATTM"       ;    ATTM        = true;
        elseif         Any  == "CTRW"       ;    CTRW        = true;
        elseif         Any  == "Fractal"    ;    Fractal     = true; % <--- Treated as subdiffusive   fBm.
        elseif         Any  == "Scaled"     ;    Scaled      = true; % <--- Treated as subdiffusive   sBm.
        elseif         Any  == "Fractional" ;    Fractional  = true; % <--- Treated as superdiffusive fBm.
        elseif         Any  == "Lévy"      ...
            ||         Any  == "Levy"       ;    Levy        = true;
        elseif         Any  == "superScaled";    superScaled = true; % <--- Treated as superdiffusive sBm.
        elseif         Any  == "Ballistic"  ;      Ballistic = true;
        end
%}
    end
  end

%% Fix & store the random number generator's pseudorandom state.
   if~exist("Seed",'var');    Seed = 1;    end      % <--- remove for randomized simulations.
   Out.pseudoRandom.Seed   =  Seed    ;    rng(Seed);

%  if          CTRW || Levy;   tID  = "Irregular";    end
if~exist("Exponent",'var')
%{
  if          Levy || superScaled || Fractional ;    Out.Exponent = 3/2     ;
  elseif Ballistic                              ;    Out.Exponent = 2       ;
  else;                                              Out.Exponent = 1/2     ;
  end
%}
  Out.Exponent = 1/2; % Assumes subdiffusion.
else;                                                Out.Exponent = Exponent;
end

if~exist("Seed",'var')  ;  Seed     =  1;  end ;  Out.pseudoRandom.Seed = Seed ;    rng(Seed);
if~exist("Count",'var') ;  Out.M    =  1;  else;  Out.M = Count ;  end % Number of Emitters.
if~exist("Frames",'var');  Out.N    = 50;  else;  Out.N = Frames;  end % Number of Frames  .
%% Define Space      :
if~exist("FoV",'var');  Out.FoV = [30,30];  else;  Out.FoV = FoV;  end % Image Plane Field of View's [Width(x),Length(y)]
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
%% Emission Parameters           :
  if exist("F",'var');    Out.F = F;    end
  if exist("G",'var');    Out.G = G;    end
  if exist("H",'var');    Out.h = H;    end
  Out = setEmissionParameters(Out) ;
%% Spatiotemporal discretization         :
  Out = spatiotemporalDiscretization(Out);
%% Hyperparameters                   :
  Out.Prior = setHyperparameters(Out);
%% Motion Parameters            :
% if ATTM;    Out.D = 1/4;    end 
  Out = setMotionParameters(Out);
%% Ancillary Assignments             :
  Out.Units.Time   = '\mathrm{s}'    ;
  Out.Units.Length = '\mathrm{\mu m}';
  Out.Units.Image  = '\mathrm{ADU}'  ;
  Out.Help         = setHelp         ;
%% Save:
 % Folder = "Simulate/Input/";    fileType = ".mat";    saveFile = Folder + "sIn" + fileType;    save(saveFile,"Out");
end
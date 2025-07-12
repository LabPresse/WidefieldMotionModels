function                                                                                                             ...
Activate(varargin)
     nArgIn  = 0;
  if nargin == 0;    varargin = {"Path"; "Graphics"};   nArgIn = length(varargin);    end
% if nargin == 0;    varargin = "Path"              ;   nArgIn = length(varargin);    end
                                 NARGIN = nargin + nArgIn;
  for                any   = 1 : NARGIN
     if     varargin{any} == "Parallel" || varargin{any} == "Cores";       Get Workers;
     elseif varargin{any} == "Night"  ;  set(groot,"DefaultFigureColor",'k');  graphicalMode Black;
     elseif varargin{any} == "Bright" ;  set(groot,"DefaultFigureColor",'w');       colordef white;
     elseif varargin{any} == "Graphics"
        Font.Size = 14;    Font.Small = Font.Size - 2;    Font.Large = Font.Size + 2;    Font.Ratio = (Font.Large) / Font.Size ;
        set(groot, "DefaultFigureVisible",'on', "defaultAxesFontName",'Times',                                       ...
                   "defaultAxesTickLabelInterpreter",'LaTeX', "defaultAxesTitleFontSizeMultiplier",Font.Ratio)          ;
        set(groot, "DefaultFigureColor",'black', "DefaultFigureInvertHardCopy",'off');    graphicalMode Black               ;
     elseif varargin{any} == "Directory"                          ...
         || varargin{any} == "Path"    ||  varargin{any}   == "Paths"     
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%{
                     Path  = defaultPath; 
                     Paths = string(fieldnames(Path));     nPaths = length(Paths);
                  for each = 2 : length(Paths);         eachPath  = Path.(Paths(each));    addpath(eachPath);    end
%           if ~isfile(pwd + "Path.mat");      save(pwd + "Path.mat", 'Path');                                   end
%}
if isfile("BayesDiffusion.mlx");    addpath(genpath(string(pwd)));    end
%----------------------------------------------------------------------------------------------------------------------%
     end
  end
end
%{
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~|
%                  Internal  Functions                  |
%% Define default Path for directory activation.        |
function                                              ...
  Path               = defaultPath                      %
  Path.Root          = string(pwd)                      ;
                     % fileparts(which("Activate.m"))   ;
%% Data:
  Path.Data          = Path.Root      + "/Data"         ;
% Single Molecule Data
  Path.SPTFolder     = Path.Data      + "/SPT"          ;
  Path.Inferred      = Path.SPTFolder + "/Inferred"     ;
  Path.SPTGT         = Path.SPTFolder + "/GroundTruth"  ;
  Path.SPTProccessed = Path.SPTFolder + "/Processed"    ;
% Robustness Tests:
  Path.RobFolder     = Path.Data      + "/Robustness"   ;
  Path.Rob           = Path.Data      + "/Robustness"   ;
  Path.RobGT         = Path.RobFolder + "/GroundTruth"  ;
%% Tools:
% Path.Analysis      = Path.Root      + "/Analysis"     ;
  Path.Processing    = Path.Root      + "/Processing"   ;
  Path.Prob          = Path.Root      + "/Probability"  ;
  Path.Distribution  = Path.Prob      + "/Distributions";
  Path.Model         = Path.Prob      + "/Model"        ;
  Path.Simulate      = Path.Root      + "/Simulate"     ;
  Path.Set           = Path.Simulate  + "/Set"          ;
  Path.Input         = Path.Simulate  + "/Input"        ;
  Path.Motion        = Path.Simulate  + "/Motion"       ;
  Path.Hold          = Path.Simulate  + "/Hold"         ;
  Path.Emission      = Path.Simulate  + "/Emission"     ;
  Path.Infer         = Path.Root      + "/Infer"        ;
  Path.AUX           = Path.Infer     + "/Auxiliary"    ;
  Path.Chain         = Path.Infer     + "/Chain"        ;
  Path.Sampler       = Path.Infer     + "/Sampling"     ;
  Path.See           = Path.Root      + "/See"          ;
% Helper Functions:
  Path.Auxiliary     = Path.Root      + "/Auxiliary"    ;
  Path.Arrays        = Path.Auxiliary + "/Arrays"       ;
  Path.Logic         = Path.Auxiliary + "/Logic"        ;
  Path.Get           = Path.Auxiliary + "/Get"          ;
  Path.Graphing      = Path.Auxiliary + "/Graphing"     ;
% For Development:
  Path.dBug          = Path.Auxiliary + "/Debug"        ;
end
%}
%------------------------------------------------------------------------------------------------------------------------|
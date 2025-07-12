function  Raw = Prepare(        In)
In.Parameters = storeParameters(In);
          Raw = convertRaw(     In);
end

function Parameters = storeParameters(Input)
%%
%% Units
 %   load Units;    Parameters.Units = Units;
%% Sizes
    Bounds.Px = size(Input.w, 1);    
    Bounds.Py = size(Input.w, 2);    
    Bounds.P  = Bounds.Px * Bounds.Py;

% Counts.{B,K,N}, then for each = length(fieldnames())
    K = Input.K         ; % Interpolations per Frame
    M = Input.M         ; % Molecules
    N = size(Input.w, 3); % Frames
%% Measured Data:
    w = reshape(Input.w, Bounds.Px, Bounds.Py, N);
%% Image discretization
      ONE = ones(1, K - 2);
    tCoeff = [1/2  ONE  1/2] / (K - 1); % composite trapezoid
%% Time levels
    Time.Frame    = Input.Time.Frame          ; % [s] frame separation
    Time.Exposure = Input.Time.Exposure       ; % [s] exposure time
    Bounds.t      = Time.Frame * (0 : N)'     ; % [s] tn  <------------------- addSYMBOL
    Time.Index    = reshape(1 : N * K, K, N)' ;
    deltat        = Time.Frame - Time.Exposure;

    Time.Levels   = reshape(bsxfun( @plus, Bounds.t(1 : N), linspace(deltat/2, Time.Frame - deltat/2, K))', N * K, 1);
                  % getRuler(Bounds.t(end), N*K)'
%% Optical parameters
    Parameters.PSF = Input.Optic.PSF       ;
    f    = Input.f                         ; % excess noise factor

    logW = reshape(log(w / f), Bounds.P, N);
  Bounds = Input.Bounds;
  Prior  = Input.Prior ;

%% Assignment
% Assign parameters.
Parameters.K = K;    Parameters.M    =    M;    Parameters.N = N;
Parameters.w = w;    Parameters.logW = logW;
Parameters.f = f;
Parameters.tCoeff = tCoeff;    
Parameters.Prior = Prior;    Parameters.Time = Time;    Parameters.Bounds = Bounds;

%% Miscellaneous
 % Account for Ground Truth when present:
if isfield(Input, "GroundTruth");    Parameters.GroundTruth    = Input.GroundTruth;    end
if isfield(Input,     "ID"     );    Parameters.GroundTruth.ID = Input.ID;    end
end

function Raw = convertRaw(In)             
%==============================================|
%~~~~~     ~~~~~  Ground Truth  ~~~~~     ~~~~~|
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~|
  if isfield(In,"ID")
  GT.ID       = In.ID         ;
  end
  if isfield(In,"Exponent")
  GT.Exponent = In.Exponent   ;
  end
  GT.B        = In.M          ;
  GT.K        = In.K          ;
  GT.M        = In.M          ;
  GT.N        = In.N          ;
  GT.S        = In.S          ;
  GT.X        = In.X          ;
  GT.Y        = In.Y          ;
  GT.Z        = In.Z          ;
  GT.t        = In.Time.Levels; 
  GT.D        = In.D          ;
  GT.h        = In.h          ;
  GT.F        = In.F          ;
  GT.f        = In.f          ;
  GT.G        = In.G          ;
%==============================================|
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~|
  Parameters.GroundTruth = GT ;

  Raw.GroundTruth = Parameters.GroundTruth;
  Raw.Bounds      = In.Bounds             ;
  Raw.Time        = In.Time               ;
  Raw.Prior       = In.Prior              ;
  Raw.Optic       = In.Optic              ;
  Raw.w           = In.w                  ;
  Raw.Units       = In.Units              ;
  Raw.f           = In.f                  ;
end
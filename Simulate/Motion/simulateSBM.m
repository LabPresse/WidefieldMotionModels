%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~|
function Scaled = simulateSBM(In,varargin)                         %                    |
     if nargin == 0 ;  In = anomalousInput ;                     end                    %
         Scaled = In                       ;                       %                    |
                  if   ~isfield(In,"pseudoRandom")                 %                    |
                        Seed = 1                                   ;                    %
                  else; Seed = In.pseudoRandom.Seed                ;                    %
                  end;                                    rng(Seed);                    %
%% Assign shorthand variables           :                          |                    |
   K  = In.K;    M  = In.M              ;                          %                    |
   X0 = In.X;    Y0 = In.Y;    Z0 = In.Z;                          %                    |
   Bx = In.Bounds.X(end)                ;                          %                    |
   By = In.Bounds.Y(end)                ;                          %                    |
   Bz = 3/2                             ;          % <--- Suggested.                    |
%---------------------------------------|                          |                    |
  if isfield(In, "Exponent");    Exponent = In.Exponent;           %                    |
  else                                                 %           |                    |
    if      nargin <= 1;         Exponent = 1/2        ;           %                    |
    else;                        Exponent = varargin{1};           %                    |
    end                                                %           |                    |
  end                                                  %           |                    |
  if~exist("Exponent",'var');    Exponent = 2/3;     end           %                    |
  if isfield(In,"D");  s = In.D;    else;  s = 1;    end % Here, s=:noise generator's sD.
%===============================================================|                       |
% Simulate Scaled Brownian Motion                               :                       |
       MSD = (s^2) * (0 : K)' .^ Exponent                       ;                       %
     Delta = sqrt(MSD(2 : end) - MSD(1 : end - 1))              ;                       %
        dX = sqrt(2)*Delta .* erfcinv(2*(1 - rand(size(Delta))));                       %
        dY = sqrt(2)*Delta .* erfcinv(2*(1 - rand(size(Delta))));                       %
        dZ = sqrt(2)*Delta .* erfcinv(2*(1 - rand(size(Delta))));                       %
         X = cumsum(dX, 1)  ; % - dX(1,:)                       ;                       %
         Y = cumsum(dY, 1)  ; % - dY(1,:)                       ;                       %
         Z = cumsum(dZ, 1)  ; % - dZ(1,:)                       ;                       %
%===============================================================|                       |
%=======================================================================================|
%=======================================================================================|
%------------------------------------------------|                     |                |
%%                 Assign Output                 :                     |                |
   Scaled.X = X;    Scaled.Y = Y;    Scaled.Z = Z;                     %                %
   Scaled   = Normalize(Scaled)                  ;
   Scaled   = Translate(Scaled, "Focus")         ;
   Scaled.Exponent           = Exponent          ;                     %                %
   Scaled.ID                 = "Scaled"          ;                     %                %
if Scaled.Exponent == 2;    Scaled.ID = "Ballistic" + Scaled.ID;    end
% Scaled                    = getMSD(Scaled)    ;                     %                %
%------------------------------------------------|                     |                |
end                                                                    %                %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~|
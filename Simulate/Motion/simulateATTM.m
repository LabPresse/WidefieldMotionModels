%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~|
function ATTM  = simulateBmATTM(In)                           %
    if nargin == 0 ;    In = anomalousInput("ATTM");        end
               if   ~isfield(In,"pseudoRandom")               %
                     Seed = 3                                 ;
               else; Seed = In.pseudoRandom.Seed              ;
               end;                                  rng(Seed);
          ATTM = In                                           ;
      Exponent = ATTM.Exponent                                ;
%====================================|                        |
%% Draw Diffusivities & Holding Times:                        |
   ATTM = holdATTM(ATTM)             ;                        %
%====================================|                        |
%-------------------------------------------------------------|
%%                 Assign shorthand variables                 :
Bounds = ATTM.Bounds;   Time = ATTM.Time                      ;
    K  = ATTM.K     ;   dt   = Time.Increment;   tB = Bounds.t;
    tH = Time.Held  ;   D    = ATTM.D                         ;
    tB = tB(end)    ;   M    = ATTM.M                         ;
    X0 = ATTM.X     ;   Y0   = ATTM.Y        ;   Z0 = ATTM.Z  ;
%-------------------------------------------------------------|
%-------------------------------------------|                 |
%%   Initialization    |  Initial Position  |                 |
    Zero = zeros(K,M)  ;                    %                 |
       X = Zero        ;    X(1,:) = X0     ;                 %
       Y = Zero        ;    Y(1,:) = Y0     ;                 %
       Z = Zero        ;    Z(1,:) = Z0     ;                 %
%---------------------------------------------------------|   |
%=============================================|           |   |
%% Simulate Annealed Time Transient Model Bm  :           |   |
  RMSD = sqrt(2 * D * dt)                     ;               %
     X = cumsum([X0; RMSD .* randn(K - 1, M)]);               %
     Y = cumsum([Y0; RMSD .* randn(K - 1, M)]);               %
     Z = cumsum([Z0; RMSD .* randn(K - 1, M)]);               %
%=============================================|               |
%------------------------------------------|                  |
%%             Assign  Outputs             :                  |
   ATTM.X = X;    ATTM.Y = Y;    ATTM.Z = Z;                  %
   ATTM.Exponent         = Exponent        ;                  %
   ATTM.ID               = "ATTM"          ;                  %
%  ATTM                  = getMSD(ATTM)    ;                  %
%------------------------------------------|                  |
end                                                           %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~|
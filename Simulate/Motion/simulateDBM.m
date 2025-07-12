%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~|
function Out  = simulateBmDirected(In)                    %
   if nargin == 0 ;    In = syntheticInput;             end
         Out  = In;                                       %
%                if   ~isfield(In,"pseudoRandom")         %
                      Seed = 4                            ;
                      rng(Seed)
%                else; Seed = In.pseudoRandom.Seed        ;
%                end;                            rng(Seed);
%--------------------------------------|                  |
%%       Assign shorthand variables    :                  |
   K = In.K;    dt = In.Time.Increment ;                  %
   M = In.M;    D  = In.D              ;                  %
  X0 = In.X;    Y0 = In.Y;    Z0 = In.Z;                  %
%--------------------------------------|                  |
%======================================================|  |
%%              Draw directed velocities               :  |
    Vx = rand(1,M)                                     ;  %    % <--- relatively small velocity shouldn't change
    Vy = rand(1,M)                                     ;  %    %      the motion model's probability too much.
    Vz = 0; % rand(1,M)                                ;  %
%======================================================|  |
%======================================================|  |
%%            Simulate directed transport              :  |
  RMSD = sqrt(2 * D * dt)                              ;  %
     X = cumsum([X0; Vx * dt + RMSD * randn(K - 1, M)]);  %
     Y = cumsum([Y0; Vy * dt + RMSD * randn(K - 1, M)]);  %
     Z = cumsum([Z0; Vz * dt + RMSD * randn(K - 1, M)]);  %
%======================================================|  |
%-----------------------------------------|               |
%%             Assign Output              :               |
   Out.X = X;    Out.Y = Y;    Out.Z = Z  ;               %
   Out.ID              = "Directed"       ;               %
%  Out                 = getMSD(Out)      ;               %
%-----------------------------------------|               |
end                                                       %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~|
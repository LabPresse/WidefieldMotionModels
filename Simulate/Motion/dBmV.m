%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~|
function Out = dBmV(In,V)                                 %
         Out = In                                         ;
%{
%{
   if nargin == 0 ;    In = syntheticInput;             end
         Out  = In;                                       %
%                if   ~isfield(In,"pseudoRandom")         %
                      Seed = 4                            ;
                      rng(Seed)
%                else; Seed = In.pseudoRandom.Seed        ;
%                end;                            rng(Seed);
%--------------------------------------|                  |
%}
    if nargin == 1 ;    In = syntheticInput    ;    end
          Out  = In                                       ;
               if   ~isfield(In,"pseudoRandom")           %
                     Seed = 1                             ;
               else; Seed = In.pseudoRandom.Seed          ;
               end;                              rng(Seed);
%---------------------------------------------------------|
%}

%%       Assign shorthand variables    :                  |
   K = In.K;    dt = In.Time.Increment ;                  %
   M = In.M;    D  = In.D              ;                  %
  X0 = In.X;    Y0 = In.Y;    Z0 = In.Z;                  %
if size(V,1) == 1;    V(2) = V(1);   end
if size(V,1)  < 3;    V(3) =   0 ;   end % <--- not directed focally.
%--------------------------------------|                  |
%======================================================|  |
%%              Draw directed velocities               :  |
    Vx = V(1); % rand(1,M)                             ;  %    % <--- relatively small velocity shouldn't change
    Vy = V(2); % rand(1,M)                             ;  %    %      the motion model's probability too much.
    Vz = 0   ; % rand(1,M)                             ;  %
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
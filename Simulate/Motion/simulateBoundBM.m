%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~|
function Bound = simulateBmBound(In)                                      %
    if~nargin;   In = syntheticInput;    end
         Bound = In;                                           %          |
               if   ~isfield(In,"pseudoRandom")                %          |
                     Seed = 1                                  ;          %
               else; Seed = In.pseudoRandom.Seed               ;          %
               end;                                   rng(Seed);          %
%--------------------------------------------------------------|          %
%% Assign shorthand variables                                  :          %
     Time = In.Time;    K = In.K;    dt = Time.Increment       ;          %
        M = 3      ;    D = In.D;                                         %
        X = In.X   ;    Y = In.Y;    Z  = In.Z                 ;          %
%--------------------------------------------------------------|          %
%=========================================================================|
%% Simulate Bound Diffusion                                               :
   X(1,1) = X(1,1) - 1;    X(1,2) = Z(2) + 8/10;    X(1,3) = X(3) + 2/10  ;
                           Y(1,2) = Y(2) + 5/10                           ;
                                                    Z(1,3) = Z(3) + 2/10  ;
    RMSD = sqrt(2 * D * dt) * randn(1,M)                                  ;
       X = [X; randn(K - 1, M)]                                           ;
       Y = [Y; randn(K - 1, M)]                                           ;
       Z = [Z; randn(K - 1, M)]                                           ;
   for k = 2 : K                                                          %
       X(k,:) = X(k - 1, :) + X(k, :) .* RMSD                             ;
       Y(k,:) = Y(k - 1, :) + Y(k, :) .* RMSD                             ;
       Z(k,:) = Z(k - 1, :) + Z(k, :) .* RMSD                             ;
%=========================================================================|
   end                                                                    %
%-----------------------------------------------|                         %
%%                Assign  Output                :                         %
     Bound.X = X;    Bound.Y = Y;    Bound.Z = Z;                         %
     Bound.ID                = "Bound"          ;                         %
     Bound                   = getMSD(Bound)    ;                         %
%-----------------------------------------------|                         %
end                                                                       %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
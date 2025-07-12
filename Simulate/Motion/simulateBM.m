%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~|
function Free  = simulateBM(In,D)                         %
    if nargin == 0 ;    In = syntheticInput;            end
         Free  = In                                       ;
               if   ~isfield(In,"pseudoRandom")           %
                     Seed = 1                             ;
               else; Seed = In.pseudoRandom.Seed          ;
               end;                              rng(Seed);
%---------------------------------------------------------|
%% Assign shorthand variables                             :
   K = In.K;  dt = In.Time.Increment;   t = In.Time.Levels;
   M = In.M;   
if~exist("D",'var');    D = In.D;    end
  X0 = In.X;  Y0 = In.Y;               Z0 = In.Z          ;
%---------------------------------------------------------|
%============================================|            |
%% Simulate simple passive transport         :            |
  RMSD = sqrt(2 * D * dt)                    ;            %
     X = cumsum([X0; RMSD * randn(K - 1, M)]);            %
     Y = cumsum([Y0; RMSD * randn(K - 1, M)]);            %
     Z = cumsum([Z0; RMSD * randn(K - 1, M)]);            %
%============================================|            |
%------------------------------------------|              |
%% Assign Output                           :              |
   Free.X = X;    Free.Y = Y;    Free.Z = Z;              %
   Free.ID               = "Free"          ;              %
%  Free                  = getMSD(Free)    ;              %
%------------------------------------------|              |
end                                                       %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~|
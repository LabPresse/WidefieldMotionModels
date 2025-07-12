%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~|
function Out = dBmD(In,D)                                 %
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
   M = In.M;    V  = 1                 ;                  %
  X0 = In.X;    Y0 = In.Y;    Z0 = In.Z;                  %
%{
if size(D,1) == 1;    D(2) = D(1);   end % <--- Diffusion in (x,y) plane with coefficient D.
if size(D,1)  < 3;    D(3) =   0 ;   end % <--- no diffusion in focal plane for 2D data.
%}
%--------------------------------------|                  |
%======================================================|  |
%%              Draw ...                               :  |
%{
    Dx = D(1); % PDF(1,M)                              ;  %
    Dy = D(2); % PDF(1,M)                              ;  %
    Dz = D(3); % PDF(1,M)                              ;  %
%}
    Dx = D;    Dy = D;    Dz = D;
%======================================================|  |
%======================================================|  |
%%            Simulate directed transport              :  |
  RMSD = sqrt(2 * D * dt)                              ;  %
     X = cumsum([X0; Dx * dt + RMSD * randn(K - 1, M)]);  %
     Y = cumsum([Y0; Dy * dt + RMSD * randn(K - 1, M)]);  %
     Z = cumsum([Z0; Dz * dt + RMSD * randn(K - 1, M)]);  %
%======================================================|  |
%-----------------------------------------|               |
%%             Assign Output              :               |
   Out.X = X;    Out.Y = Y;    Out.Z = Z  ;               %
   Out.ID              = "Directed"       ;               %
%  Out                 = getMSD(Out)      ;               %
%-----------------------------------------|               |
end                                                       %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~|
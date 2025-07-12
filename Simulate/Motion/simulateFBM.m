%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~|
function  FBM  = simulateFBM(In,varargin)                 %
    if nargin == 0 ;    In = anomalousInput;            end
          FBM  = In;                                      %
               if   ~isfield(In,"pseudoRandom")           %
                     Seed = 1                             ;
               else; Seed = In.pseudoRandom.Seed          ;
               end;                              rng(Seed);
if isfield(In, "Exponent");    Exponent = In.Exponent     ;
else                                                      %
  if nargin < 1;               Exponent = 2 / 3           ;
  else;                        Exponent = varargin{1}     ;
  end                                                     %
end                                                       %
%---------------------------------------------------------|
%% Assign shorthand variables                             :
   K  = In.K            ;    M  = In.M;    D = In.D       ;
   Bx = In.Bounds.X(end);    By = In.Bounds.Y(end)        ;
%---------------------------------------------------------|
        Hurst = Exponent / 2                              ;
   for     m  = 1 : size(In.X,2)                          %
      X0(  m) = In.X(1,m)                                 ;
      Y0(  m) = In.Y(1,m)                                 ;
      Z0(  m) = In.Z(1,m)                                 ;
      Wx(:,m) = wfbm(Hurst, K - 1, 2)                     ;
      Wy(:,m) = wfbm(Hurst, K - 1, 2)                     ;
      Wz(:,m) = wfbm(Hurst, K - 1, 2)                     ;
   end
%% Store positions     :
   X = [X0  ;  X0 + Wx];
   Y = [Y0  ;  Y0 + Wy];
   Z = [Z0  ;  Z0 + Wz];

%---------------------------------------------------|
%%                  Assign  Output                  :   
   FBM.X = X;    FBM.Y = Y;    FBM.Z = Z            ;
   FBM.Exponent        = Exponent                   ;
   FBM.Hurst           = Hurst                      ;
   FBM.ID              = "Fractional"               ;
%  FBM                 = getMSD(Fractal)            ;
%---------------------------------------------------|
end
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~|
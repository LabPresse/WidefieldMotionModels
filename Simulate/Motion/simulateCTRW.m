%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~|
function CTRW  = simulateBmCTRW(In, varargin)                                               %
    if nargin == 0 ;    In = syntheticInput;    end                                         %
         CTRW  = In;                                                                        %
                 if   ~isfield(In,"pseudoRandom")           %                               |
                       Seed = 1                             ;                               %
                 else; Seed = In.pseudoRandom.Seed          ;                               %
                 end;                              rng(Seed);                               %
%-------------------------------------------------------------------------------------------|
%%                                   Interpret  Input                                       :
  if     isfield(In,"alpha");                   Exponent = alpha      ;                     %  
  elseif isfield(In,"Exponent");                Exponent = In.Exponent;                   end
  if nargin  > 1;                               Exponent = varargin{1};                   end
  if~exist("Exponent",'var');                   Exponent = 2/3        ;                   end
     Constraints(1) = "𝛼:=1 ∵ CTRW ⟹ 0<𝛼⩽1 ⟹ no superdiffusion!"                         ;
  if Exponent < 0 ||   Exponent > 1;    Exponent = 1;    disp(Constraints(1));            end
%-------------------------------------------------------------------------------------------|
%---------------------------------------|                                                   |
%%           Assign shorthand variables           :                                         |
  tK = In.Time.Levels(end);  K  = In.K            ;                                         %
  M  = In.M               ;  D  = In.D            ;                                         %
  Bx = In.Bounds.X(end)   ;  By = In.Bounds.Y(end);                                         %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~|                                               |
%%                Initialize                :                                               |
%-------------------------------------------|                                               |
%   Initialization    %  Initial Position   :                                               |
   ZERO = zeros(K,M)  ;                     %                                               |
      X = ZERO        ;  X(1,:) = In.X      ;                                               %
      Y = ZERO        ;  Y(1,:) = In.Y      ;                                               %
      Z = ZERO        ;  Z(1,:) = In.Z      ;                                               %
    tau = zeros(K,1)  ;                     %                                               |
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~|                                               |
%-----------------------|                                                                   %
%%   CTRW  Parameters   :                                                                   %
   xi   = Exponent + 1  ;                                                                   %
   tMin = 10^(-9)       ; % Lower bound of t.                                               %
   tMax = tK            ; % Upper bound of t.                                               %
   k    = 1             ;                                                                   %
   Constant = tMax / 100;                                                                   %
%-----------------------|                                                                   %
%=================================================================================|         |
%%                     Simulate a Continuous Time Random Walk                     :         |
  for     k  = 2 : K                                                                        %
          U  = rand ; %rand(1,M)                                                            %
    if   Exponent > 0                                                                       %
          t  = (U*(tMax^(1 - xi) - tMin^(1 - xi)) + tMin^(1 - xi)).^(1 / (1 - xi));         %
    else; t  = Constant                                                           ;         %
    end                                                                           %         |
      DS     = sampleNormal(0,D);    d = sampleSphere(1,M,DS)                     ;         %
      X(k,:) = X(k - 1,:) + d.X                                                   ;         %
      Y(k,:) = Y(k - 1,:) + d.Y                                                   ;         %
      Z(k,:) = Z(k - 1,:) + d.Z                                                   ;         %
      tau(k) = tau(k - 1) +  t                                                    ;         %
  end                                                                             %         |
%=================================================================================|         |
%----------------------------------------|                                                  |
%%             Assign Output             :                                                  |
  CTRW.X = X;   CTRW.Y = Y;    CTRW.Z = Z;                                                  %
  CTRW.Exponent        = Exponent        ;                                                  %
  CTRW.ID              = "CTRW"          ;                                                  %
% CTRW                 = getMSD(CTRW)    ;                                                  %
%----------------------------------------|                                                  |
end                                                                                         %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~|
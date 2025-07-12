%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~|
%function Out = diffuseATTM(In)                %
function Out = holdATTM(In)                    %
   if~nargin ; In = anomalousInput("ATTM");  end
         Out = In                              ;
%-------------------------------|              |
%      Shorthand Variables      :              |
   E    = In.Exponent           ;              %
   K    = In.K                  ;              %
   M    = In.M                  ;              %
   tB   = In.Bounds.t(end)      ;              %
   minD = In.D/3                ;              %
   maxD = 3*In.D                ;              %
%-------------------------------|              |
%==============================|               |
%% Draw Diffusivity Parameters :               |
if E ~=1                       %               |
   xi = eps;    zeta = 0       ;               %
while xi > zeta || zeta > xi + 1               %
      xi = unifrnd(eps,3)      ;               %
    zeta = xi / E              ;               %
end                            %               |
else                           %               | 
      xi = 3    * rand         ;               %    
    zeta = rand * (xi + 5) - 5 ;               %
end                            %               |
%==============================================|
%%              Draw Diffusivities             :
  Xi = 1 ./ xi                                 ;
  U  = rand(K - 1, M)                          ;
  D  = (U * (maxD^xi - minD^xi) + minD^xi).^Xi ;
%==============================================|
%======================|                       |
%% Draw Holding Periods:                       |
  zeta = E / xi        ;                       %
  tH   = D .^ (-zeta)  ;                       %
%======================|                       |
%=====================|                        |
%    Rescale Holds    :                        |
tH = tH / max(tH) * tB;                        %
%=====================|                        |
%---------------------------|                  |  
%%      Assign Outputs      :                  |
  Out.Tag = "ATTM"          ;                  %
  Out.D            = mean(D,"All");            %
  Out.allD         = D            ;
  Out.minD         = minD   ;                  %
  Out.maxD         = maxD   ;                  %
  Out.Time.Held    = tH     ;                  %
  Out.Time.HeldMin = min(tH);                  %
  Out.Time.HeldMax = max(tH);                  %
%---------------------------|                  |
end                                            %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~|


%% Challenge Method:
%{
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~|
function Out = holdATTM(In)                                            %
%------------------------------------------------|                     |
%%                Interpret Input                :                     |
   if~nargin ; In = anomalousInput("ATTM");    end                     %
       Out   = In                                ;                     %
%------------------------------------------------|                     |
%---------------------------------|                                    |
%%       Shorthand Variables      :                                    |
         K   = In.K               ;                                    %
         E   = In.Exponent        ;                                    %
       tB    = In.Time.Levels(end);                                    %
       tMin  = tB/10^2            ;                                    %
       tMax  = tB                 ;                                    %
%---------------------------------|                                    |
%-------------------------|                                            |
%% Holding Time Parameters:                                            |
        xi  = E + 1       ;                                            %
        Xi  = 2 - xi      ;                                            %
        XI  = 1 / Xi      ;                                            %
%-------------------------|                                            |
%======================================================================|
%%                              Draw Holding Times                     :
        U   = rand(K, 1)  ; % rand(K,M) <--- generalized to M particles.
     if xi ~= 1;    tH = (U*(tMax^Xi - tMin^Xi) + tMin^Xi).^XI;        %
     else;    disp("<holdATTM>: α=1; cancelling until analytical" ...  |
                   +  "distribution is implemented.");         return  %
     end                                                               %
%======================================================================|
%--------------------------|                                           |
%%     Assign  Outputs     :                                           |
  Out.Tag          = "ATTM";                                           %
  Out.Time.Held    = tH    ;                                           %
  Out.Time.HeldMin = tMax  ;                                           %
  Out.Time.HeldMax = tMax  ;                                           %
%--------------------------|                                           |
end                                                                    %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~|
%}
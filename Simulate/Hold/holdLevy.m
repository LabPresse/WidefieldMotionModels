%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~|
function Out = holdLevy(In)                                     %
%------------------------------------------------|              |
%%                Interpret Input                :              |
   if~nargin ; In = anomalousInput("Lévy");    end              %
       Out   = In                                ;              %
%------------------------------------------------|              |
%---------------------------------|                             |
%%       Shorthand Variables      :                             |
         K   = In.K               ;                             %
         M   = In.M               ;                             %
         E   = In.Exponent        ;                             %
       tB    = In.Time.Levels(end);                             %
       tMin  = tB/10^2            ;                             %
       tMax  = tB                 ;                             %
%---------------------------------|                             |
%-------------------------|                                     |
%% Holding Time Parameters:                                     |
        xi  = E + 1       ;                                     %
        Xi  = 2 - xi      ;                                     %
        XI  = 1 / Xi      ;                                     %
        tC  = tB / 10^3   ;% ~one-sided stable Lévy distribution.
%-------------------------|                                     |
%===============================================================|
%%                         Draw Holding Times                   :
        U   = rand(K, M);   %   <--- generalized to M particles .
     if xi ~= 2;    tH = (U * (tMax^Xi - tMin^Xi) + tMin^Xi).^XI;
     else;          tH = tC * ones(size(U))                     ;
     end                                                        %
%===============================================================|
%--------------------------|                                    |
%%     Assign  Outputs     :                                    |
  Out.Tag          = "Lévy";                                    %
  Out.Time.Held    = tH    ;                                    %
  Out.Time.HeldMin = tMax  ;                                    %
  Out.Time.HeldMax = tMax  ;                                    %
%--------------------------|                                    |
end                                                             %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~|
%————————————————————————————————————————————————————————|
function logP = logMotion(X,Y,Z, D, Parameters)          %
if isempty(X) ; logP = NaN;  return;  end
if size(D,1) > 1;    D = mean(D,1);    end % ATTM(GT,M>1).
%                  Shorthand  Variables                  |
  Prior  = Parameters.Prior;
  meanR0 = Prior.R0.Mean'  ;     sDR0 = Prior.R0.sDev'   ;
  Time   =  Parameters.Time;       
       t = Time.Levels     ;       Dt = diff(Time.Levels);
%‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾|
%                   Initial  Position                    |
%________________________________________________________|
            R0 = [X(1,:);  Y(1,:);  Z(1,:)]              ;
    logPriorR0 = logLikelihoodNormal(R0, meanR0, sDR0.^2);
%‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾|
%                 Successive  Positions                  |
%________________________________________________________|
          DX = diff(X);    DY = diff(Y);    DZ = diff(Z) ;
       meanR = 0;      varR = 2 * D .* Dt                ;
   logPriorR = logLikelihoodNormal(DX, meanR, varR)    ...
             + logLikelihoodNormal(DY, meanR, varR)    ...
             + logLikelihoodNormal(DZ, meanR, varR)      ;
%‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾|
%                      log  Motion                       |
%________________________________________________________|
          logP = logPriorR0 + logPriorR;                 %
end                                                      %
%————————————————————————————————————————————————————————|
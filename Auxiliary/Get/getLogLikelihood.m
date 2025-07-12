function                                     ...
Out = getLogLikelihood(Chain)                  %
%‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾|‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾|
%   Shorthand Variables   |————————————————————|
%_________________________|____________________|
     shortHand
 i = Chain.i(end)       ;   b  = Chain.b            ;
 N = Chain.Parameters.N ;   M  = Chain.Parameters.M ;
% Px = Chain.Parameters.Px;   Py = Chain.Parameters.Py;
%‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾|‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾|
%     Initialization     |—————————————————————|
%________________________|_____________________|
      logMotion = 0;
    logEmission = 0;
              U = zeros(Px, Py, N)            ;
              X = reshape(Chain.X(i,:), [], M);    X = X(:,b(i,:));     %#ok<*PFBNS>
              Y = reshape(Chain.Y(i,:), [], M);    Y = Y(:,b(i,:));
              Z = reshape(Chain.Z(i,:), [], M);    Z = Z(:,b(i,:));
              D = Chain.D(i)                  ;
              F = Chain.F(i)                  ;    h = Chain.h(i) ;
              G = Chain.G(i)                  ;
   logMotion(i) = getLogMotion( X, Y, Z, D,       Chain.Parameters);
 logEmission(i) = getLogEmission(F, h, G, X, Y, Z, Chain.Parameters);

   w = Chain.Parameters.w;           %    Measurements
logw = log(w);                       % logMeasurements
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~|
%           Return  Output           :
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~|
Out.logMotion   = logMotion         ;% logPrior on InitialPosition+Motion.
Out.logEmission = logEmission       ;% logLikelihood on PhotonEmission.
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
end
%———————————————————————————————————————————————————————————————————————————|
function ...                                                                |
logP = getLogMotion(X, Y, Z, D, Parameters)                                   %|
%‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾|~~~~~~~~~~~~~~~~~|
%                    Initial Position                     |~~~~~~~~~~~~~~~~~|
%_________________________________________________________|~~~~~~~~~~~~~~~~~|
         R0 = [X(1,:);  Y(1,:);  Z(1,:)]                                  ;%|
     meanR0 = [Parameters.Prior.R0.Mean(1); Parameters.Prior.R0.Mean(2); Parameters.Prior.R0.Mean(3)];%|
       sDR0 = [Parameters.Prior.R0.sDev(1); Parameters.Prior.R0.sDev(2); Parameters.Prior.R0.sDev(3)];%|
 logPriorR0 = logLikelihoodNormal(R0, meanR0, sDR0.^2)                    ;%|
%‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾|~~~~~~~~~~~~~|
%                    Successive Positions                     |~~~~~~~~~~~~~|
%_____________________________________________________________|~~~~~~~~~~~~~|
       DX = diff(X);  DY = diff(Y);  DZ = diff(Z);                         %|
       Dt = diff(Parameters.Time.Levels);                                  %|
    meanR = 0;      varR = 2*D*Dt;                                         %|
logPriorR = logLikelihoodNormal(DX, meanR, varR)                        ...%|
          + logLikelihoodNormal(DY, meanR, varR)                        ...%|
          + logLikelihoodNormal(DZ, meanR, varR);                          %|
%‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾|~~~~~~~~~~~~~|
%                         log Motion                          |~~~~~~~~~~~~~|
%_____________________________________________________________|~~~~~~~~~~~~~|                                                                          %|
     logP = logPriorR0 + logPriorR;                                        %|
end                                                                        %|
%———————————————————————————————————————————————————————————————————————————|
%‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾|
%                              logProbability of Emission Model                             |
%___________________________________________________________________________________________|
function                                                                                  ...
[logL, varargout] = getLogEmission(F, h, G, onX, onY, onZ, Parameters)                     %|
      pixPSF = zeros(Parameters.Px, Parameters.Py, Parameters.N)                            ;
 for       n = 1 : Parameters.N                                                            %|
   for     m = 1 : size(onX, 2)                                                            %|
     for   k = 1 : Parameters.K                                                            %|
               tIndex = Parameters.tIndex(n,k)                                          ;
               xB = Parameters.xBound                                                   ;
               yB = Parameters.yBound                                                   ;
               pixPSF(:,:,n) = pixPSF(:,:,n)                                              ...
                             + Parameters.tCoeff(k)                                        ...
                             * integratePSF( onX(tIndex, m), onY(tIndex, m), onZ(tIndex, m),   ...
                                 xB, yB, Parameters.PSF)                     ;
     end                                                                                   %|
   end                                                                                     %|
 end                                                                                       %|
    w = Parameters.w                                                                    ;
 logw = log(w)                                                                              ;
    W = Parameters.w / Parameters.f / G; % informed measurements account for EMCCD Gain & ExcessNoiseFactor=2.
 logW = log(W)                                                                              ;
    u = Parameters.tExposure / Parameters.f * (F * Parameters.Bounds.PA + h * pixPSF); % mean photon count.
 logL = sum(u .* logW - gammaln(u) - W - logw, 'All')                                       ;
if nargout > 1;    varargout{1} = u;    end
end%                                                                                        |
%___________________________________________________________________________________________|
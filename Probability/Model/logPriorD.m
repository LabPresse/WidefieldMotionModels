function logPrior = logPriorD(D,Prior)
                    phiD = Prior.D.phi;
                    chiD = Prior.D.chi;
         logPrior = logpdfInverseGamma(D, phiD, phiD*chiD);
end

%% Analytic:
 % logPrior = shape * log(scale)                 ...
 %          - gammaln(shape) - scale ./ variable ...
 %          - log(variable) * (shape + 1)          ;
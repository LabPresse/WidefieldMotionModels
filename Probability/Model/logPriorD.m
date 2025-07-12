function logPrior = logPriorD(D,Prior)
                    phiD = Prior.D.phi;
                    chiD = Prior.D.chi;
         logPrior = logpdfInverseGamma(D, phiD, phiD*chiD);
end

%% Analytic:
 % logPrior = shape * log(scale)                 ...
 %          - gammaln(shape) - scale ./ variable ...
 %          - log(variable) * (shape + 1)          ;

%}

%% Simplism:
%{
function logPrior = logPriorD(variable,Prior)
                    shape = Prior.D.phi;
                    scale = Prior.D.chi;
         logPrior = -(shape + 1) * log(variable) - shape * scale ./ variable;
end
%}
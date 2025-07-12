function logPrior = logPriorF(F,Prior)
                    phiF = Prior.F.phi;
                    psiF = Prior.F.psi;
         logPrior = logpdfGamma(F, phiF, psiF / phiF);

% Analytic:
 % logPrior = (shape - 1) * log(variable)          ...
 %          - variable/scale                       ...
 %          - ( shape * log(scale) + gammaln(shape) );

end


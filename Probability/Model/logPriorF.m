function logPrior = logPriorF(F,Prior)
                    phiF = Prior.F.phi;
                    psiF = Prior.F.psi;
         logPrior = logpdfGamma(F, phiF, psiF / phiF);

% Analytic:
 % logPrior = (shape - 1) * log(variable)          ...
 %          - variable/scale                       ...
 %          - ( shape * log(scale) + gammaln(shape) );
% Simplism: 
 % logPrior = (shape - 1) * log(variable) - shape * variable / shapedScale;


% INVERSE GAMMA:
%logPDF = shape * log(scale)                 ...
%       - gammaln(shape) - scale ./ variable ...
%       - log(variable) * (shape + 1)          ;   % (.,scale = shape*chi) for ~{D,G}

end


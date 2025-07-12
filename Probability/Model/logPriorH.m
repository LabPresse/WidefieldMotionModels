function logPrior = logPriorH(H,Prior)
                    phiH = Prior.h.phi;
                    psiH = Prior.h.psi;
         logPrior = logpdfGamma(H, phiH, psiH / phiH);
end

% logPrior = (shape - 1) * log(variable) - shape * variable / shapedScale
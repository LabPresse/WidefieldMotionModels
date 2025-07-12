function logPrior = logPriorG(G,Prior)
                    phiG = Prior.G.phi;
                    chiG = Prior.G.chi;
         logPrior = logpdfInverseGamma(G, phiG, phiG*chiG);
end

% logPrior = - (shape + 1) * log(variable) - shape * scaledShape / variable;
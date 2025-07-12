function logPrior = logPriorLoad(b, Parameters)
                         M = Parameters.M            ;
                    bGamma = Parameters.Prior.b.gamma;
         logPrior = sum(-b * log1p((M - 1) / bGamma) - (~b) * log1p(bGamma / (M - 1)));
end
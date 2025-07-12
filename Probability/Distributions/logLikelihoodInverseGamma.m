function logL = logLikelihoodInverseGamma(measurements,alpha,beta)
         logL = sum(   logpdfInverseGamma(measurements,alpha,beta),"All");
end

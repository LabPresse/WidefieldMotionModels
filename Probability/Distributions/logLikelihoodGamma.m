function logL = logLikelihoodGamma(measurements,alpha,beta)
         logL = sum(   logpdfGamma(measurements,alpha,beta),"All");
end
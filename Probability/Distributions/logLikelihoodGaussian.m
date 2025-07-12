function logL = logLikelihoodGaussian(measurements,mean,standardDeviation)
         logL = sum(   logpdfGaussian(measurements,mean,standardDeviation),"All");
end
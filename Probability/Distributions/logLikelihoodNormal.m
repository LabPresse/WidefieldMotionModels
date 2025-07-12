function logL = logLikelihoodNormal(measurements, mean, variance)
         logL = sum(   logpdfNormal(measurements, mean, variance),"All");
  if isnumeric(measurements) ... 
   & isnumeric(mean)         ... 
   & isnumeric(variance)
     logL = double(logL)       ;
  end
end
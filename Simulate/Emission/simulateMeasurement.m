function w = simulateMeasurement(sIn)
         u = sIn.u;    f = sIn.f;    G = sIn.G;
%% Simulate Gamma-distributed photon shot noise:
   w = f * G * randg(u / f);
end

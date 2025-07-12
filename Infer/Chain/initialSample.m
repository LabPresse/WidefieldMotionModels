function Sample = initialSample(Parameters)
                  shortHand
%% Iteration & Simulated Annealing Temperature:
  Sample.i = 1;    Sample.T = T0;
%% Diffusivity:
   Sample.D = phiD * chiD / randg(phiD);
%% Photon (γ) Emission Rates:
   Sample.F = psiF / phiF * randg(phiF);
   Sample.h = psiH / phiH * randg(phiH);
%% EMCCD Gain:
   Sample.G = phiG * chiG / randg(phiG);
%% Emitters:
    Sample.b = (rand(1, M) <= gammaB / (gammaB + M - 1));
%% Photostate:
    Sample.S = ones(N, M);
%% Positions (Inactivated until Markov Chain is Burnt In):
   [Sample.X, Sample.Y, Sample.Z] = sampleInactivePositions(M, Sample.D, Parameters);
%% Sampling Records:
    Sample.RecordedEmissionRates = repmat([0; eps], 1, 3); % Emission rates
    Sample.RecordedPositions     = repmat([0; eps], 1, 2); % Position proposals
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~|
%% Additional Samples.
    B = nnz( Sample.b);    Sample.On.B = B;    B1 = max(1,B);
    X = NaN(K * N,B1) ;    Sample.On.X = X;
    Y = NaN(K * N,B1) ;    Sample.On.Y = Y;
    Z = NaN(K * N,B1) ;    Sample.On.Z = Z;
   bi = Sample.b      ;
   Di = Sample.D      ;
   Fi = Sample.F      ;    Gi = Sample.G  ;    Hi = Sample.h;

   Prior  = Parameters.Prior;

   logb   = logPriorLoad(bi,Parameters)             ;    Sample.logPrior.b   = logb  ;
   logR   = logMotion(X,Y,Z, Di, Parameters)        ;    Sample.logMotion    = logR  ;
   logD   = logPriorD(Di,Prior)                     ;    Sample.logPrior.D   = logD  ;
   logFGH = logEmission(Fi,Hi,Gi, X,Y,Z, Parameters);    Sample.logEmission  = logFGH;
   logF   = logPriorF(Fi,Prior)                     ;    Sample.logPrior.F   = logF  ;
   logH   = logPriorH(Hi,Prior)                     ;    Sample.logPrior.h   = logH  ;
   logG   = logPriorG(Gi,Prior)                     ;    Sample.logPrior.G   = logG  ;
   logP   = logb + logR+logD + logFGH+logF+logH+logG;    Sample.logPosterior = logP  ;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Print Sampled Values           :
  Chain.Sample      = Sample      ;    
  Chain.Parameters  = Parameters  ;
  Chain.T           = Sample.T    ;
  showSample(Chain, "Approximate");
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end
function [Sample, Parameters] = Update(Chain)
          Sample  = Chain.Sample;    Parameters = Chain.Parameters;
      loadSamples = true;    shortHand           %#ok<*NODEF>
%% Update iteration (i):
   i = i + 1;
%% Update simulated annealing Temperature (T) :
%  Ti = 1 + (Ti - 1) * (1 - Parameters.DeltaT);        if Ti - 1 < 1e-5;    Ti = 1;    end
   if    Ti > 1;  Ti = 1 + (T0 - 1) / (1 - iT)^2 * (i - iT)^2; 
   else;          Ti = 1 ;
   end
%% Interpret emitters:
   C = ~bi    ; % Inactive emitters.
   B = nnz(bi); %   Active emitters.
%%  safeGuard inactive positions as non-numbers:
    Xi(:, C) = NaN;
    Yi(:, C) = NaN;
    Zi(:, C) = NaN;
    Gi       = NaN;
%% Update emission rates & Gain (F,G):
        % [Sample, Parameters] = sampleFluxGain(Chain);
    [Fi,Hi,Gi,FHi, Parameters] = sampleFluxGain(Fi,Hi,bi, Xi(:,bi),Yi(:,bi),Zi(:,bi), FHi,Ti, Parameters);  %#ok<*ASGLU>
  if B > 0
    for rep = 1 : 30
     [Xi(:,bi),Yi(:,bi),Zi(:,bi),Di,Ri] = sampleActivePositions(B,Xi(:,bi),Yi(:,bi),Zi(:,bi),Fi,Hi,Gi,Ri,Ti,Parameters);
    end
  else;                          Di     = phiD * chiD / randg(phiD);
  end
%% FLIPswap.
  if B > 1;  [Xi(:,bi),Yi(:,bi),Zi(:,bi)] = sampleFlipSwap(B, Xi(:,bi),Yi(:,bi),Zi(:,bi), Di, Parameters, false);  end
%% Update the location of inactive emitters:
  [Xi(:,C),Yi(:,C),Zi(:,C)] = sampleInactivePositions(nnz(C), Di, Parameters);
%% Update molecular brightness, active emitters, and emission rate records:
  [Hi, bi, FHi(:, 2)]       = sampleRatesLoads(Hi, bi, Fi, Xi,Yi,Zi, Gi, FHi(:,2), Ti, Parameters, 5);
%% Assign Sampled Outputs:
   updateSamples
%% Find Active Emitters:
   Sample.On.B = nnz(bi) ;
%% Get Corresponding Tracks:
   X = reshape(Xi, [], M);    X = X(:,bi);    Sample.On.X = X;
   Y = reshape(Yi, [], M);    Y = Y(:,bi);    Sample.On.Y = Y;
   Z = reshape(Zi, [], M);    Z = Z(:,bi);    Sample.On.Z = Z;   
%% Find Expected Diffusive Trajectory:
   Sample.expectedR  = inferExpectedTrack(Chain);
%% Calculate & Store Probabilities:
   Prior  = Parameters.Prior                               ;
   logb   = logPriorLoad(bi,Parameters)                    ;    Sample.logPrior.b     = logb  ;
   logFGH = logEmission(Fi,Hi,Gi, X,Y,Z, Parameters)       ;    Sample.logEmission    = logFGH;
   logF   = logPriorF(Fi,Prior)                            ;    Sample.logPrior.F     = logF  ;
   logH   = logPriorH(Hi,Prior)                            ;    Sample.logPrior.h     = logH  ;
   logG   = logPriorG(Gi,Prior)                            ;    Sample.logPrior.G     = logG  ;
   logR   = logMotion(X,Y,Z, Di, Parameters)               ;    Sample.logMotion      = logR  ;
   logD   = logPriorD(Di,Prior)                            ;    Sample.logPrior.D     = logD  ;
   logP   = logb + (logR+logD) + (logFGH+logF+logH+logG)   ;    Sample.logPosterior   = logP  ;
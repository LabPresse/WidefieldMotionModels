function [F, h, G, Record, Parameters] = sampleFluxGain(F,h, b, onX,onY,onZ, Record,T, Parameters)
                % [Sample, Parameters] = updateFluxGain(In)
                                         shortHand
  pixPSF    = zeros(Px, Py, N);
  for     n = 1 : N
    for   m = 1 : nnz(b)
      for k = 1 : K
        pixPSF(:,:,n) = pixPSF(:,:,n) + tCoeff(k) * integratePSF(onX(tI(n,k),m),onY(tI(n,k),m),onZ(tI(n,k),m), xB,yB, PSF);
      end
    end
  end
     W = w / f        ;
  sumW = sum(W, "All");
  logW = log(W)       ;
%% Calculate counts & derived quantities:
  effectivePhotons = tE / f * (F * PA + h * pixPSF);
  sumPhotons       = sum(effectivePhotons,   "All");
  E                = sum(effectivePhotons .* logW - gammaln(effectivePhotons), "All");
  for rep = 1 : 75
%% Draw proposals:
           h_  = h;
    [F_, loga] = Propose(F, 0, MH(1), 1);

    effectivePhotons_ = tE / f * (F_ * PA + h_ * pixPSF);
          sumPhotons_ = sum(effectivePhotons_, "All");
                   E_ = sum(effectivePhotons_ .* logW - gammaln(effectivePhotons_), "All");

    loga = loga                                                         ...
         + (phiF - 1) * log(F_ / F)                                     ...
         +  phiF * (F - F_) / psiF                                      ...
         + (E_ - E) / T                                                 ...
         + (sumPhotons - sumPhotons_) / T * log(chiG * phiG + sumW / T) ...
         + gammaln(phiG + sumPhotons_ / T)                              ...
         - gammaln(phiG + sumPhotons  / T)                                ;
    if log(rand) < loga;    F = F_;    sumPhotons = sumPhotons_;    E = E_;    Record(1, 1) = Record(1, 1) + 1;    end
    Record(2, 1) = Record(2, 1) + 1;
  end
%% Update Gain
   G = (chiG * phiG + sumW / T) / randg(phiG + sumPhotons / T);
end

function [x_, loga] = Propose(x, loga, a, b)        ;       F = betarnd(a, b);
    if      rand(1) < 0.5  ;      x_ = x * F        ;    loga = loga + log(F);
    else;        x_ = x / F;    loga = loga - log(F);
    end
end

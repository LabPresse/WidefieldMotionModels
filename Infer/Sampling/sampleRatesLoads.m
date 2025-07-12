function [h, b, Record] = sampleRatesLoads(h, b, F, X,Y,Z, G, Record,T,Parameters,batchSize)
                          shortHand                                             %#ok<*USENS>
  h_            = Parameters.GroundTruth.h ;
                % PROPOSE(h, Parameters.MH_sc(2), 1);
  hContribution = zeros(P, N, M)           ;
  FContribution = tE / f * F * PcA         ;
  logSignal     = logW - log(G)            ;
  logPrior      = [log(M - 1); log(gammaB)];

  onIndex       = find(b)                             ;
  offIndex      = setdiff(1 : M, onIndex)             ;
  Mixed         = onIndex(randperm(length(onIndex)))  ;
  MIXED         = offIndex(randperm(length(offIndex)));
  sampleOrder   = [Mixed, MIXED]                      ;
  
  Batch         = sampleOrder(1 : batchSize);
  onOut         = setdiff(find(b), Batch)   ;

  for   m = 1 : M
    for k = 1 : K
        x = X(tI(:,k),m);    y = Y(tI(:,k),m);    z = Z(tI(:,k),m); 
            hContribution(:,:,m) = hContribution(:,:,m) + reshape(tCoeff(k) * integratePSF(x,y,z, xB,yB, PSF), P, N, 1);
    end
  end

    hContribution = tE / f * h_ * hContribution;
    Base          = FContribution + sum(hContribution(:, :, onOut), 3);
    logPosterior_ = getLogPosterior(hContribution(:, :, Batch), Base, logSignal, logPrior, T);
    hContribution = hContribution / h_ * h;
    logPosterior  = getLogPosterior(hContribution(:, :, Batch), Base, logSignal, logPrior, T);
    logr          = logSumEXP(logPosterior_) - logSumEXP(logPosterior)                     ...
                  + (phiH - 1) * log(h_ / h) + phiH * (h - h_) / psiH;

    if log(rand)  < logr
        h = h_;    logPosterior = logPosterior_;    hContribution = hContribution * h_/h;    Record(1) = Record(1) + 1;
    end

    Record(2)     = Record(2) + 1;

    [~, result]   = max(logPosterior - log(-log(rand(length(logPosterior), 1))));
    b(Batch)      = logical(dec2bin(result - 1, batchSize) - 48);

    for index        = batchSize + 1 : batchSize:M
        Batch        = sampleOrder(index : min(index + batchSize - 1, M));
        onOut        = setdiff(find(b), Batch);
        Base         = FContribution + sum(hContribution(:,:,onOut), 3);
        logPosterior = getLogPosterior(hContribution(:,:,Batch), Base, logSignal, logPrior, T);
        [~, result]  = max(logPosterior - log(-log(rand(length(logPosterior), 1))));
        b(Batch)     = logical(dec2bin(result - 1, batchSize) - 48);
    end
end

function x_ = PROPOSE(X,a,b);    F = betarnd(a, b);    if rand(1) < 1/2;  x_ = X * F;  else;  x_ = X / F;  end;    end

function logPosterior   = getLogPosterior(batchContribution, Base, logSignal, logPrior, T)
            batchSize   = size(batchContribution, 3);
         logPosterior   = zeros(2^batchSize, 1)     ;
    for m = 1 : length(logPosterior)
        onNew           = logical(dec2bin(m - 1, batchSize) - 48);
        hContribution   = Base + sum(batchContribution(:, :, onNew), 3);
        logPosterior(m) = sum(hContribution .* logSignal - gammaln(hContribution), "All") / T ...
                        + nnz(onNew) * logPrior(2) + (batchSize - nnz(onNew)) * logPrior(1)     ;
    end
end

function logx = logSumEXP(logx)
         logx = [-inf, sort(reshape(logx(logx > -inf), 1, []))];
         while length(logx) > 1;  logx = [max(logx(1),logx(2)) + log1p(exp(-abs(logx(1) - logx(2)))), logx(3:end)];  end
end
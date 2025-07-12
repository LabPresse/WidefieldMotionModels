function [onX, onY, onZ, D, Record] = sampleActivePositions(B, onX,onY,onZ, F,h,G, Record,T,Parameters)
                                      shortHand                                            %#ok<*USENS>
  proposeX = @(b) MH(4) * refS * randn(K, b);
  proposeY = @(b) MH(4) * refS * randn(K, b);
  proposeZ = @(b) MH(4) * refZ * randn(K, b);
  
  ProposeX = @(b) MH(5) * refS * randn(K, b) .* double(rand(K, b) <= 1 / (K * b));
  ProposeY = @(b) MH(5) * refS * randn(K, b) .* double(rand(K, b) <= 1 / (K * b));
  ProposeZ = @(b) MH(5) * refZ * randn(K, b) .* double(rand(K, b) <= 1 / (K * b));

         W = log(w / (f * G));
       vPn = NaN(Px, Py, N)  ;
        Pn = NaN(N , 1)      ;

  for         n  = 1 : N
      vPn(:,:,n) = inferExpectation(1:B, onX(tI(n,:),:),onY(tI(n,:),:),onZ(tI(n,:),:), tCoeff, xB,yB, tE/f, F,h, PSF);
       Pn(    n) = sum(vPn(:,:,n) .* W(:,:,n) - gammaln(vPn(:,:,n)), "All");
  end

   AD  = phiD + 3/2  *  B  * (N * K - 1);
  IBDi = phiD * chiD + 1/4 * sum(sum(diff(onX).^2 + diff(onY).^2 + diff(onZ).^2, 2) ./ Dt);

  for rep = 1 : 30
    for n  = randperm(N)
%% Proposed Positions of Active Emitters:
      X_   = onX(tI(n,:),:) + proposeX(B);    Y_ = onY(tI(n,:),:) + proposeY(B);    Z_ = onZ(tI(n,:),:) + proposeZ(B);
      vP_  = inferExpectation([],X_,Y_,Z_,tCoeff,xB,yB,tE / f,F,h,PSF);
      Pn_  = sum(vP_ .* W(:, :, n) - gammaln(vP_), "All");
      loga = (Pn_ - Pn(n)) / T;
      switch n
        case 1;    index = 1 : tI(n + 1, 1);                  Status = "Start" ;
            loga = loga + 1/2  * sum(                                        ...
                   ((onX(1,:) - Mean(1)).^2 - (X_(1,:) - Mean(1)).^2) / sD(1)^2  ...
                 + ((onY(1,:) - Mean(2)).^2 - (Y_(1,:) - Mean(2)).^2) / sD(2)^2  ...
                 + ((onZ(1,:) - Mean(3)).^2 - (Z_(1,:) - Mean(3)).^2) / sD(3)^2   );
        case    N; index  = tI(n - 1, end) : N * K       ;    Status = "End"   ;
        otherwise; index  = tI(n - 1, end) : tI(n + 1, 1);    Status = "Middle";
      end
      IBD_ = IBDi + deltaIBD(onX(index,:),onY(index,:),onZ(index,:), X_,Y_,Z_, tk(index), Status);
      loga = loga + AD * log(IBDi / IBD_);
    
      if log(rand)  < loga;    onX(tI(n,:),:) = X_;    onY(tI(n,:),:) = Y_;    onZ(tI(n,:),:)  = Z_;
         vPn(:,:,n) = vP_ ;    Pn(n) = Pn_;    IBDi = IBD_;          Record(1,1) = Record(1,1) + 1 ;
      end;                                                           Record(2,1) = Record(2,1) + 1 ;

%% Proposed Location of Active Emitters:
      X_  = onX(tI(n,:),:) + ProposeX(B);    Y_ = onY(tI(n,:),:) + ProposeY(B);    Z_ = onZ(tI(n,:),:) + ProposeZ(B);
     vP_  = inferExpectation([],X_,Y_,Z_, tCoeff, xB,yB, tE / f, F,h, PSF)      ;
     Pn_  = sum(vP_ .* W(:,:,n) - gammaln(vP_), "All")                         ;
     loga = (Pn_ - Pn(n)) / T                                                  ;

      switch n
        case 1;       index = 1 : tI(n + 1, 1)             ;     Status = "Start" ;
            loga = loga + 1/2  * sum( ...
                   ((onX(1, :) - Mean(1)).^2 - (X_(1, :) - Mean(1)).^2) / sD(1)^2   ...
                 + ((onY(1, :) - Mean(2)).^2 - (Y_(1, :) - Mean(2)).^2) / sD(2)^2   ...
                 + ((onZ(1, :) - Mean(3)).^2 - (Z_(1, :) - Mean(3)).^2) / sD(3)^2    );
        case    N;    index = tI(n - 1, end) : N * K       ;     Status = "End"   ;
        otherwise;    index = tI(n - 1, end) : tI(n + 1, 1);     Status = "Middle";
      end
    
            IBD_ = IBDi + deltaIBD(onX(index,:),onY(index,:),onZ(index,:), X_,Y_,Z_, tk(index), Status);
            loga = loga + AD * log(IBDi / IBD_);
      if log(rand) < loga
           onX(tI(n,:),:) = X_ ;    onY(tI(n,:),:) = Y_ ;    onZ(tI(n,:),:) = Z_  ;
           vPn(:,:,n)     = vP_;    Pn(n)          = Pn_;    IBDi           = IBD_;
           Record(1, 2)   = Record(1, 2) + 1            ;
      end; Record(2, 2)   = Record(2, 2) + 1            ;
    end
  end
    D = sampleDiffusivity(B, onX, onY, onZ, Parameters);
end

%% Internal Functions:
function r = deltaIBD(onX,onY,onZ, X_,Y_,Z_, tk, Status)
         r = 1/4 * sum(sum(Diff(onX, X_, Status) + Diff(onY, Y_, Status) + Diff(onZ, Z_, Status), 2) ./ diff(tk));
end

function r = Diff(Old, Proposed, Status)
    switch Status
        case "Start" ;    r = diff([Proposed; Old(end, :)])           ;
        case "End"   ;    r = diff([Old(1, :); Proposed])             ;
        case "Middle";    r = diff([Old(1, :); Proposed; Old(end, :)]);
        otherwise;   error("!Err<sampleR>: Unknown position status!") ;
    end;                  r = r.^2 - diff(Old).^2                     ;
end
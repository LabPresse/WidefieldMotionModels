function [onX, onY, onZ] = sampleFlipSwap(B, onX, onY, onZ, D, Parameters, outputflag)
                           shortHand
%% Emitter selection
   pairs = getPairs(B);
%% Calculate 〈ΔR²〉
   DeltaR2 = diff(onX).^2 + diff(onY).^2 + diff(onZ).^2; % Squared Displacement
%% Samplers
   for      i = randperm(size(pairs, 1))
     for    n = randperm(Parameters.N)
       for  k = randperm(Parameters.K)
         tNow = tI(n, k);
         if tNow == 1;  continue;    else;  tLast = tNow - 1;    end
         logr  = DeltaR2(tLast, pairs(i, 1)) + DeltaR2(tLast, pairs(i, 2));
         [Xprop, Yprop, Zprop, tag] = proposeTrajectory(                        ...
                                      onX(tNow:end, [pairs(i, 1) pairs(i, 2)]), ...
                                      onY(tNow:end, [pairs(i, 1) pairs(i, 2)]), ...
                                      onZ(tNow:end, [pairs(i, 1) pairs(i, 2)]))   ;
         logr = logr                                      ...
              - (Xprop(1, 1) - onX(tLast, pairs(i, 1)))^2 ...
              - (Yprop(1, 1) - onY(tLast, pairs(i, 1)))^2 ...
              - (Zprop(1, 1) - onZ(tLast, pairs(i, 1)))^2 ...
              - (Xprop(1, 2) - onX(tLast, pairs(i, 2)))^2 ...
              - (Yprop(1, 2) - onY(tLast, pairs(i, 2)))^2 ...
              - (Zprop(1, 2) - onZ(tLast, pairs(i, 2)))^2   ;
         logr = logr / (4 * D * Dt(tLast));
         if log(rand) < logr
           if outputflag
             if tag(1)
                disp(['---> flip: at n=', num2str(n),' and k=', num2str(k),', emitter ', num2str(pairs(i, 1))])
             end
             if tag(2)
                disp(['---> flip: at n=', num2str(n),' and k=', num2str(k),', emitter ', num2str(pairs(i, 2))])
             end
             if tag(3)
                disp(['---> swap: at n=', num2str(n),' and k=', num2str(k),', between ', num2str(pairs(i, 1)), ...
                      ' and ', num2str(pairs(i, 2))])
             end
           end
           onX(tNow:end, [pairs(i, 1) pairs(i, 2)]) = Xprop;
           onY(tNow:end, [pairs(i, 1) pairs(i, 2)]) = Yprop;
           onZ(tNow:end, [pairs(i, 1) pairs(i, 2)]) = Zprop;
           DeltaR2 = diff(onX).^2 + diff(onY).^2 + diff(onZ).^2;
         end
       end
     end
   end
end

function pairs = getPairs(N)
    [elem1, elem2] = ndgrid(1 : N)   ;    elem1       = tril(elem1, -1) ;    elem2       = tril(elem2,  -1);
    pairs = zeros(N * (N - 1) / 2, 2);    pairs(:, 1) = elem1(elem1 > 0);    pairs(:, 2) = elem2(elem2 > 0);
end

function [X, Y, Z, tag] = proposeTrajectory(X, Y, Z)
    tag = false(1, 3);
    switch randi(4)
        case 2;    Z(:, 1) = -Z(:, 1);    tag( 1) = true    ;
        case 3;    Z(:, 2) = -Z(:, 2);    tag( 2) = true    ;    
        case 4;    Z(:, 1) = -Z(:, 1);    Z(:, 2) = -Z(:, 2);    tag(1:2) = true;    
    end
    if rand > 1/2;  X(:,[1,2]) = X(:,[2,1]);  Y(:,[1,2]) = Y(:,[2,1]);  Z(:,[1,2]) = Z(:,[2,1]);  tag(3) = true;  end
end
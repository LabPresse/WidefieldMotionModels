function logP = logPhotostate(S, Pj)
              % 1⟶1, 1⟶2, 2⟶2, 2⟶3, 3⟶3.
                logTransition = zeros(5, 1)  ; 
              % log_trans_prob(1) = log1p(-Pj(1)+eps(1));
                logTransition(2) = log(  +Pj(1));
                logTransition(3) = log(  +Pj(2));
                logTransition(4) = log1p(-Pj(2));  
              % + nnz(s(1, :) == 1) * log1p(-Pj(3)) ...  % right now initial state can only be 2
         logP = sum(nTransitions(S) .* logTransition) + nnz(S(1, :) == 2) * log(Pj(3));
end


function nS = nTransitions(S)
            % 1⟶1, 1⟶2, 2⟶2, 2⟶3, 3⟶3.
         nS = zeros(5, 1);
  for     m = 1 : size(S, 2)
    if    S(1, m) == S(end, m)
         nS(S(1, m) * 2 - 1) = nS(S(1, m) * 2 - 1) + size(S, 1) - 1;
    else
     for n = 1 : size(S, 1) - 1
         nS(S(n, m) + S(n + 1, m) - 1) = nS(S(n, m) + S(n + 1, m) - 1) + 1;
     end
    end
  end
end
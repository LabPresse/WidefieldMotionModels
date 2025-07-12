function Mask = maskState(S, Parameters)
            K = Parameters.K     ;    M = Parameters.M;    N = Parameters.N;
           tI = Parameters.tIndex;
         Mask = NaN(N * K, M);
    for     m = 1 : M;    Mask(tI(S(:, m) == 2, :), m) = 1;    end
              % Mask(Chain.Sample.S == 2) = 1;
end
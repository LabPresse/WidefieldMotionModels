function [offX, offY, offZ] = sampleInactivePositions(C, D, Parameters) %#ok<*INUSD>
                              shortHand
    RMSD = sqrt(2 * D * Dt);    % 〈R²〉
    offX = cumsum([sD(1) * randn(1, C) + Mean(1)                                  ;  RMSD .* randn(N * K - 1, C)]);
    offY = cumsum([sD(2) * randn(1, C) + Mean(2)                                  ;  RMSD .* randn(N * K - 1, C)]);
    offZ = cumsum([sD(3) * randn(1, C) + Mean(3) .* 2 * ((rand(1, C) < 1/2) - 1/2);  RMSD .* randn(N * K - 1, C)]);
end
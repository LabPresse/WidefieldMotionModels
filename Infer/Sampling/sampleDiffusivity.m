function  D = sampleDiffusivity(B, onX, onY, onZ, Parameters) %#ok<*INUSD>
              shortHand
    if    B > 0
          D = phiD * chiD + 1/4 * sum(sum(diff(onX).^2 + diff(onY).^2 + diff(onZ).^2, 2) ./ diff(tk));
          D = D / randg(phiD + 3/2 * B * (N * K - 1));
    else; D = phiD * chiD    ;
          D = D / randg(phiD);
    end
end
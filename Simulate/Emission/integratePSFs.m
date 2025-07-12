function g = integratePSFs(X,Y,Z, Bx,By, PSF)
      refS = PSF.Reference.XY;
      refZ = PSF.Reference.Z ;

  switch PSF.Tag
    case 1 % "Gaussian"
         Width = refS * sqrt(2 * (1 + (Z / refZ)^2));
             g = 1/4 * diff(erf((Bx - X) / Width)) * diff(erf((By - Y) / Width));
    case 2 % "Numerical Airy"
         xSpan  = 1/2 * (Bx(2 : end) - Bx(1 : end - 1));    ySpan  = 1/2 * (By(2 : end) - By(1 : end - 1));
         xCount = 1/2 * (Bx(2 : end) + Bx(1 : end - 1));    yCount = 1/2 * (By(2 : end) + By(1 : end - 1));
              g = xSpan * ySpan .* sum(bsxfun(@times, PSF.omg, ...
                  PSF.PSI(abs(Z) * ones(length(xSpan), length(ySpan), length(PSF.omg)), ...
                  bsxfun(@plus, bsxfun(@minus, X - xCount, bsxfun(@times, xSpan, PSF.b_x)).^2, ...
                  bsxfun(@minus, Y - yCount, bsxfun(@times, ySpan, PSF.b_y)).^2))), 3);
    case 3 % "Mixed PSF"
         Width = refS * sqrt(2 * (1 + (Z / refZ)^2));
         g = 1/4 * diff(erf((Bx - X) / Width)) * diff(erf((By - Y) / Width));
         
         Width = PSF.s * refS * sqrt(2 * (1 + (Z / refZ)^2));
         g = (1 - PSF.p) * g + PSF.p * 1/4 * diff(erf((Bx - X) / Width)) * diff(erf((By - Y) / Width));
    otherwise;    error("PointSpreadFunction not known.")
  end
end
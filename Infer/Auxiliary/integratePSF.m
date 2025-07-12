function g = integratePSF(X,Y,Z, xB,yB, PSF)
      refS = PSF.Reference.XY;
      refZ = PSF.Reference.Z ;
     Width = refS * sqrt(2 * (1 + (Z / refZ).^2));
     Width = reshape(Width, 1, 1, length(Width)) ;
         g = 1/4 * pagemtimes(                              ...
             diff(erf(permute(xB - X', [1 3 2]) ./ Width)), ...
             diff(erf(permute(yB - Y , [3 2 1]) ./ Width)))   ;
end
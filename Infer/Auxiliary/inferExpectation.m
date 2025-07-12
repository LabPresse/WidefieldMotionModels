function  U = inferExpectation(fm, X,Y,Z, tCoeff, xB,yB, tE,F,h,PSF)
              if isempty(fm);    mIndex = 1 : size(X, 2);    else;    mIndex = find(fm);    end
          U = zeros(length(xB) - 1, length(yB) - 1);
    for   m = mIndex
      for k = 1 : length(tCoeff)
          U = U + tCoeff(k) * integratePSF(X(k,m),Y(k,m),Z(k,m), xB,yB, PSF);
      end
    end
    U = tE * (F * diff(xB)*diff(yB) + h*U);
end
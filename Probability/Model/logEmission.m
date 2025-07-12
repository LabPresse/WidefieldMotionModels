%‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾|
%                             log Probability of Emission  Model                             |
%____________________________________________________________________________________________|
function                                                                                   ...
[logL, varargout] = logEmission(F, h, G, onX, onY, onZ, Parameters)                          %
      B  = size(onX, 2)            ;      N = Parameters.N         ;    K = Parameters.K;    %
      f  = Parameters.f            ;    PSF = Parameters.PSF       ;    w = Parameters.w;    %
      Px = Parameters.Bounds.Px    ;     Py = Parameters.Bounds.Py ;                         %
      Bx = Parameters.Bounds.X     ;     By = Parameters.Bounds.Y  ;                         %
      PA = Parameters.Bounds.PA    ;                                                         %
      tE = Parameters.Time.Exposure;     ti = Parameters.Time.Index;                         %
  pixPSF = zeros(Px, Py, N)        ;                                                         %
  for        n = 1 : N                                                                       %
    for      m = 1 : B                                                                       %
      for    k = 1 : K                                                                       %
        tI = ti(n,k)                                                                         ;
        X  = onX(tI, m);    Y = onY(tI, m);        Z = onZ(tI, m)                            ;
        g  = integratePSF(X,Y,Z, Bx,By, PSF)   ;    tCoeff = Parameters.tCoeff(k)            ;
        pixPSF(:,:,n) = pixPSF(:,:,n) + tCoeff * g                                           ;
      end                                                                                    %
    end                                                                                      %
  end                                                                                        %
 logw = log(w)                                                                               ;
    W = w/(2*G)                                                                              ;
 logW = log(W)                                                                               ;
    u = tE/2 * (F*PA + h*pixPSF);                                                            % Photoelectron load.
 logL = sum(u .* logW - gammaln(u) - W - logw, "All")                                        ;
  if nargout > 1;     varargout{1} = u;                                                    end
end                                                                                          %
%____________________________________________________________________________________________|
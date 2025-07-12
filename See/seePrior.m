function seePrior(Axes,Tag,Hyper1,Hyper2)
  X = get(Axes,"YLim");
  X = getRuler([min(X),  max(X)]);
  d = eps;
% PDF
switch Tag
    
    case "norm" % p1 = mu, p2 = sg
        Prior = d + normpdf(X,Hyper1,Hyper2);
    
    case "symnorm" % p1 = mu, p2 = sg
        Prior = d + 0.5*normpdf(X,+Hyper1,Hyper2) + 0.5*normpdf(X,-Hyper1,Hyper2);
    
    case "foldnorm" % p1 = mu, p2 = sg
        Prior = d + normpdf(X,+Hyper1,Hyper2) + normpdf(X,-Hyper1,Hyper2);

    case "gamma" % p1 = phi, p2 = psi
        Prior = d + (Hyper1/Hyper2)^Hyper1/gamma(Hyper1)*X.^(Hyper1-1).*exp(-X*Hyper1/Hyper2);

    case "beta" % p1 = A, p2 = B
        Prior = d + betapdf(X,Hyper1,Hyper2);
    
    case "invgamma" % p1 = phi, p2 = chi
        Prior = d + (Hyper1*Hyper2)^Hyper1/gamma(Hyper1)*X.^(-Hyper1-1).*exp(-Hyper1*Hyper2./X);
    
    case "symgamma" % p1 = A, p2 = B
        Prior = d + 0.5*(Hyper1/Hyper2)^Hyper1/gamma(Hyper1)*abs(X).^(Hyper1-1).*exp(-abs(X)*Hyper1/Hyper2);
    
    case "besselK" % p1(1:2) = phi(1:2), p2 = psi(1:2)
        Prior = d + 2/(gamma(Hyper1(1))*gamma(Hyper1(2)))*(Hyper1(1)*Hyper1(2)/(Hyper2(1)*Hyper2(2))*X).^(0.5*(Hyper1(1)+Hyper1(2))).*besselk(Hyper1(1)-Hyper1(2),2*sqrt(Hyper1(1)*Hyper1(2)/(Hyper2(1)*Hyper2(2))*X))./X;

    otherwise
        warning("Unknown tag (prior visualizer)")
end


Prior = min(get(Axes,"XLim")) + 0.15*(max(get(Axes,"XLim"))-min(get(Axes,"XLim")))*Prior/max(Prior);
line(Prior,X,"Color","k", "LineStyle","--", "Parent",Axes);

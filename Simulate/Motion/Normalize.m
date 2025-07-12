function Out = Normalize(Tracks)
              Out = Tracks              ;
                  X = Tracks.X            ;     Y  = Tracks.Y            ;      Z  = Tracks.Z;
                 M = Tracks.M            ;
                Bx = Tracks.Bounds.X(end);    By =  Tracks.Bounds.Y(end);

  Scale = 2                                                             ;
  for m = 1 : M
% Normalization (aspect-preserving):
  Rmax(:,m) = [max(abs(X(:,m)),[],"All")  ;  max(abs(Y(:,m)),[],"All") ;
                max(abs(Z(:,m)),[],"All")                              ];
  Ratio(:,m) = [Rmax(1,m)  ;  Rmax(2,m)   ;  Rmax(3,m)] / max(Rmax(:,m));
      X(:,m)   =    (X(:,m)  /  Rmax(1,m))  *  Ratio(1,m) * Scale         ;
      Y(:,m)   =    (Y(:,m)  /  Rmax(2,m))  *  Ratio(2,m) * Scale         ;
      Z(:,m)   =    (Z(:,m)  /  Rmax(3,m))  *  Ratio(3,m) * Scale         ;
  end
%---------------------------------------|
  Out.X = X;    Out.Y = Y;    Out.Z = Z;
end
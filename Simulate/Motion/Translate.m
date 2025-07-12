function Out = Translate(Tracks,varargin)
         Out = Tracks              ;
           X = Tracks.X            ;     Y  = Tracks.Y            ;      Z  = Tracks.Z;
           M = Tracks.M            ;
          Bx = Tracks.Bounds.X(end);    By =  Tracks.Bounds.Y(end);
%   Exponent = Tracks.Exponent; % <--- NOT USUALLY PROVIDED.

if nargin > 1;    Option = varargin{1};    else;  Option = "";    end
  for m = 1 : M
 %% Translation              :
    if min(X(:,m),[],1) <  0 ;    X(:,m) = X(:,m) + abs(min(X(:,m),[],1)) + Bx / 2;    end
       Dx = (Bx / 2 - mean(X,"All"));          X(:,m) = X(:,m) + Dx;
    if min(Y(:,m),[],1) <  0 ;    Y(:,m) = Y(:,m) + abs(min(Y(:,m),[],1)) + By / 2;    end
       Dy = (By / 2 - mean(Y,"All"));          Y(:,m) = Y(:,m) + Dy;
if Option == "Focus";    Z(:,m) = Z(:,m) - mean(Z,"All");    Out.inFocus = true;    end
%    if min(Z(:,m),[],1) <  0 ;    Z(:,m) = Z(:,m) + abs(min(Z(:,m),[],1))      / 2;    %end
 %   end
%   if max(Z(:,m),[],1) > 3/2;    Z(:,m) = Z(:,m) -     max(Z(:,m),[],1)       / 2;    end
  end;           Out.X  =  X;      Out.Y = Y;          Out.Z = Z;
end
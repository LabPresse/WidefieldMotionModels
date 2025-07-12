function R = getExpectedTrack(In, varargin)

     Truth = false;    
if nargin > 1;    if varargin{1} == "Truth";  Truth = true;  end;    end
  %  Shorthand variables  :                          %
  if~isfield(In,"Length") & ~isfield(In,"logMotion") %#ok<*AND2>
    K   = In.K                                       ;
    N   = In.N            ;   t  = In.Time.Levels    ;
    M   = In.M            ;   Dt = In.Time.Increment ;
    tF  = In.Time.Frame   ;   tE = In.Time.Exposure  ;
    tB  = In.Bounds.t     ;
%  if~isfield(In.Bounds,"Exposure")   
%    Be      = tB(1 : end - 1) + (tF - tE)/2;
%    Be(2,:) = Be(1,:) + tE     ;
%  else; Be = In.Bounds.Exposure;
%  end
  %}
    Bx  = In.Bounds.X     ; % dBx = diff(Bx)         ;
    By  = In.Bounds.Y     ; % dBy = diff(By)         ;
    PSF = In.Optic.PSF    ; % dA  = dBx * dBy'       ;
    F   = In.F            ;     h = In.h             ;
    rX  = In.X            ;    rY = In.Y;   rZ = In.Z;
  %--------------------------------------------------|
  else
      Q = In.Parameters;
    K   = Q.K          ;
    N   = Q.N          ;    t  = Q.Time.Levels  ;
    tB  = Q.Bounds.t   ;  
    tF  = Q.Time.Frame ;    tE = Q.Time.Exposure;
    Bx  = Q.Bounds.X   ; % dBx = diff(Bx)         ;
    By  = Q.Bounds.Y   ; % dBy = diff(By)         ;
    PSF = Q.PSF        ; % dA  = dBx * dBy'       ;
    if Truth           ;    GT = Q.GroundTruth ;    M = GT.M  ;    F = GT.F;    h = GT.h;    rX =   GT.X;    rY =   GT.Y;    rZ =   GT.Z;
    else               ;     S = In.Sample     ;    M = S.On.B;    F =  S.F;    h =  S.h;    rX = S.On.X;    rY = S.On.Y;    rZ = S.On.Z;
    end
  %%%%%%
%  Whoops%%%%%%
  %%%%%%

  end

      Be  = tB(1 : end - 1) + (tF - tE)/2;    
  if size(Be,1) > 1;    Be  = Be';    end
      Be(2,:) = Be(1,:) + tE;

%% Get Image Width, Length in [Pixels]:
   Px = length(Bx) - 1;   % Number [pix] in Image's Width .
   Py = length(By) - 1;   % Number [pix] in Image's Height.
%% Shape vectors, evaluate differences, calculate Area:
    Bx = reshape(Bx, Px + 1,    1  ); % Column vector
    By = reshape(By,    1  , Py + 1); % Row    vector
   dBx = diff(Bx);    dBy = diff(By);    dA  = dBx * dBy;
%% Generate Images (i.e., ideal observations):
     u = zeros(Px, Py, N);


X = zeros(N,M);    Y = zeros(N,M);    Z = zeros(N,M);    
   for     n  = 1 : N
           kI = (Be(1,n) <= t) & (t < Be(2,n));
     for   m  = 1 : M
       for k  = find(kI)'
                X(n,m) = rX(k,m);    Y(n,m) = rY(k,m);     Z(n,m) = rZ(k,m);
       end
     end
   end
%  R = [X  ;  Y  ;  Z]; % One particle case.
   
   R.X = X   ;
   R.Y = Y   ;
   R.Z = Z   ;

end
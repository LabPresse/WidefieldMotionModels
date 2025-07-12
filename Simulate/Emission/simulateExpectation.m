function varargout = simulateExpectation(In)
  if~isfield(In,"S")
    %%     Simulate  Photostate     :
      In.S = simulatePhotostates(In);
    %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~|
    %    Neglect  Photobleaching    !
      In.S(1 : end, 1 : end) = 2    ; % <--- TURN BACK OFF!
    %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~|
  end
%--------------------------------------------------|
%  Shorthand variables  :                          %
  N   = In.N            ;   tk = In.Time.Levels    ;
  M   = In.M            ;   Dt = In.Time.Increment ;
  tF  = In.Time.Frame   ;   tE = In.Time.Exposure  ;
  tB  = In.Bounds.t     ;   Be = In.Bounds.Exposure;
  Bx  = In.Bounds.X     ;
  By  = In.Bounds.Y     ;
  PSF = In.Optic.PSF    ;
  F   = In.F            ;     h = In.h             ;
%--------------------------------------------------|
%% Get Image Width, Length in [Pixels]:
   Px = length(Bx) - 1;   % Number [pix] in Image's Width .
   Py = length(By) - 1;   % Number [pix] in Image's Height.
%% Shape vectors, evaluate differences, & calculate Area:
    Bx = reshape(Bx, Px + 1,    1  ); % Column vector
    By = reshape(By,    1  , Py + 1); % Row    vector
   dBx =    diff(Bx);    dBy = diff(By);    dA  = dBx * dBy;
%% Generate Images (i.e., ideal observations):
     u = zeros(Px, Py, N);
 % Gather emitter contributions:
   for     n = 1 : N
     kIndex  = (Be(1,n) <= tk) & (tk < Be(2,n));
     for   m = 1 : M
       for k = find(kIndex)'
               X(n) = In.X(k,m);    Y(n) = In.Y(k,m);     Z(n) = In.Z(k,m);
               x    =    X(n)  ;    y    =    Y(n)  ;     z    =    Z(n)  ;
         u(:,:,n) = u(:,:,n) + integratePSFs(x,y,z, Bx,By, PSF);
       end
     end
   end
   u = F*dA*tE + h*u*Dt;
 %R  = [X  ;  Y  ;  Z] ;
  R.X = X;    R.Y = Y;    R.Z = Z;
 % u = bsxfun(@plus, F*tE*dA, h*u*Dt);

  if     nargout == 1;  varargout{1} = u;
  elseif nargout == 2;  varargout{1} = u;    varargout{2} = R;
  end
end
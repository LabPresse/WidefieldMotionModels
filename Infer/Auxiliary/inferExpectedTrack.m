%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~|
function R = inferExpectedTrack(Chain)                       %
%%                    Shorthand Variables                    :
Sample = Chain.Sample   ;  Parameters = Chain.Parameters     ;
  Time = Parameters.Time;      Bounds = Parameters.Bounds    ;
    K  = Parameters.K   ;          tk = Time.Levels          ;
    N  = Parameters.N   ;          tE = Time.Exposure        ;
    B  = Sample.On.B    ;          tF = Parameters.Time.Frame;
    tB = Bounds.t       ;                                    %
    Bx = Bounds.X       ;      By = Parameters.Bounds.Y  ;   %
  if~isfield(Bounds,"Exposure")                              %
        Be      = tB(1 : end - 1) + (tF - tE)/2;             %
        if size(Be,2) == 1;    Be = Be';     end             %
        Be(2,:) = Be(1,:) + tE                 ;             %
  else; Be      = Bounds.Exposure              ;             %
  end                                                        %
%%             Get Image Width, Length in [Pixels]           :
    Px = length(Bx) - 1;    % Number [pix] in Image's Width .|
    Py = length(By) - 1;    % Number [pix] in Image's Height.|
%%     Shape vectors, evaluate differences, calculate Area   :
    Bx = reshape(Bx, Px + 1,    1  ); % Column vector        |
    By = reshape(By,    1  , Py + 1); % Row    vector        |
   dBx = diff(Bx)   ;  dBy = diff(By)   ;   dA = dBx * dBy  ;%
   onX = Sample.On.X;  onY = Sample.On.Y;  onZ = Sample.On.Z;%
%%                 Initialize  Output                 :      %
   X = NaN(N,B);    Y = NaN(N,B);    Z = NaN(N,B)     ;      %
%%            Gather emitter contributions            :      |
   for     n        = 1 : N                           %      |
        kI          = (Be(1,n) <= tk) & (tk < Be(2,n));      %
     for      m     = 1 : B                           %      |
       for       k  = find(kI)'                       %      |
         X(n, m)    = onX(k, m);                      %      |
         Y(n, m)    = onY(k, m);                      %      |
         Z(n, m)    = onZ(k, m);                      %      |
       end                                            %      |
     end                                              %      |
   end;  R.X = X;    R.Y = Y;    R.Z = Z;             %      |
end                                                          %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~|
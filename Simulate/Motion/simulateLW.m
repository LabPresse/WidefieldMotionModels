function  Levy = simulateBmLevy(In) % This is more like a Lévy flight than a Lévy walk.
    if~nargin  ;  In = anomalousInput;    end
                 if   ~isfield(In,"pseudoRandom")           %
                       Seed = 1                             ;
                 else; Seed = In.pseudoRandom.Seed          ;
                 end ;                             rng(Seed);
          Levy = In  ;

if isfield(In,"Exponent");    Exponent = In.Exponent;    
else;  if nargin < 2;         Exponent = 3/2        ;  end
end

if     Exponent  < 1;    Exponent = 3/2   ;    disp("<simLévy>: no subdiffusion! α:=3/2.");
  if     nargin  < 2;    Exponent = 3/2   ;    end
elseif Exponent == 2;    sD = 1           ; % Brownian Motion (Gaussian)
else                ;    sD = 3 - Exponent; % Lévy exponent relation
end

%----------------------------------------------------------|
%% Assign shorthand variables                              :
                                          Time = In.Time   ;
        K  = In.K;  t = Time.Levels;  dt = Time.Increment  ;
        M  = In.M;               
        D  = In.D;                  Bz  = 1; % <--- Suggested
        Bx = In.Bounds.X(end);      By  = In.Bounds.Y(end) ;
        X0 = In.X;    Y0 = In.Y;    Z0  = In.Z             ;
%----------------------------------------------------------|
%=========================================================================|
%% Define hyperparameters for sojourn time distribution:
  if Exponent == 2;    xi = rand             ;
  else            ;    xi = 3 - Exponent     ;
  end
  Dt           = (1 - rand(K,1)) .^ (-1 / xi);
  Dt(Dt > K)   = K;

%% Initialization  ;
  ZERO = zeros(K,M);
     X = ZERO;    X(1,:) = X0;
     Y = ZERO;    Y(1,:) = Y0;
     Z = ZERO;    Z(1,:) = Z0;

%% Simulation           :
 % Randomize velocity   :
         v  = rand(1,M) ; % <--- Could allow variation with time, dimension, & particle.
%    for k  = 2 : K
%        dt = Dt(k)  ;    
[DX, DY, DZ] = sampleSphere(K - 1, M, v);
      X(2 : K, :) = DX .* Dt(2 : K);
      Y(2 : K, :) = DY .* Dt(2 : K);
      Z(2 : K, :) = DZ .* Dt(2 : K);
%    end
    X = cumsum(X,1); % - X(1,:);
    Y = cumsum(Y,1); % - Y(1,:);
    Z = cumsum(Z,1); % - Z(1,:);
%----------------------------------------|
%             Assign  Output             :
Levy.Dt = Dt;   Levy.v = v               ;
Levy.X  = X ;   Levy.Y = Y;    Levy.Z = Z;
Levy.Exponent          = Exponent        ;
Levy.ID                = "Levy"          ;
%Levy                  = getMSD(Levy)    ;
%----------------------------------------|

end
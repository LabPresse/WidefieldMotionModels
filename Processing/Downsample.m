function R   = Downsample(ID, varargin)
      Save   = false;
  if  nargin > 1
      for      any  = 1 : nargin - 1;  Any  = varargin{any};
        if islogical(Any);    Save = Any;
        else
          if isstring(Any) || ischar(Any)
            if     Any == "Save"       ||  Any == "save";    Save = true;    
            elseif Any == "GroundSample";  GroundSample = true;
            end
          end
        end
      end
  end;    if~exist("GroundSample",'var');  GroundSample = false;  end

if GroundSample
    % Allow direct input <Chain>.
    if     isfield(ID, "Parameters" );    Q = ID.Parameters;
    elseif isfield(ID, "GroundTruth");    Q = ID           ;
    end
    GT = Q.GroundTruth;    In = GT;
    B  = GT.M         ;
else
  if     isstruct(ID)
      Chain = ID;
  elseif isstring(ID)
                  load("Data/SPT/Inferred/Inferred(" + ID + ").mat", 'Chain')
  end
  Q  = Chain.Parameters ;
  GT = Q.GroundTruth    ;
  B  = Chain.Sample.On.B;
end

              K = size(GT.X, 1);    k = Q.K * Q.N;    

             dS = round(K / k); % Downsample to 1 in dS samples.
%disp("K = " + K + " should be greater than " + "k = " + k)
%disp("round(K / k) = " + dS)
% if dS == 0;  dS = round(k / K);  end % <--- WHY?

  clear X Y Z;    Zero = zeros(k,1);   ZERO = zeros(k, B);
        t       = Zero  ;
        X       = ZERO  ;
        Y       = ZERO  ;
        Z       = ZERO  ;
        i       = 0     ;
        j       = 1 : dS;
  while j(end) <= K
     if j() > K;    break;    end

        i       = i + 1 ;
        J       = j(end);
      t(i)      = mean(GT.t(j, :), 1);
      X(i,:)    = mean(GT.X(j, :), 1);
      Y(i,:)    = mean(GT.Y(j, :), 1);
      Z(i,:)    = mean(GT.Z(j, :), 1);
        j       = j + dS;
  end;      R.t = t;    R.X = X;    R.Y = Y;    R.Z = Z;
  if Save;    save("Data/Downsampled(" + ID + ").mat", 'R');    end
end
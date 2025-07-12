function R = DownsampleGT(ID, k)

  if      isstruct(ID)
    if    isfield(ID,"Parameters");    R = Downsample(ID,"GroundSample");    return;    
    else; Input = ID;
    end
  elseif  isstring(ID)
          Input = importdata("Data/SPT/GroundTruth/Modelled(" + ID + ").mat");
  end

   GT = Input;    Q = Input;    B = GT.M ;    GT.t = GT.Time.Levels;


              K = size(GT.X, 1);    
             dS = round(K / k) ; % Downsample to 1 in dS samples.
  clear X Y Z;    Zero = zeros(k,1);   ZERO = zeros(k, B);
        t       = Zero  ;
        X       = ZERO  ;
        Y       = ZERO  ;
        Z       = ZERO  ;
        i       = 0     ;
        j       = 1 : dS;

  while j(end) <= K
        i       = i + 1 ;
        J       = j(end);
      t(i)      = mean(GT.t(j, :), 1);
      X(i,:)    = mean(GT.X(j, :), 1);
      Y(i,:)    = mean(GT.Y(j, :), 1);
      Z(i,:)    = mean(GT.Z(j, :), 1);
        j       = j + dS;
  end;      R.t = t;    R.X = X;    R.Y = Y;    R.Z = Z;
% if Save;    save("Data/DownsampledGT(" + ID + ").mat", 'R');    end
end
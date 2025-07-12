function Out = Standardize(Tracks)
         Out = Tracks  ;
           X = Tracks.X;      Y  = Tracks.Y;      Z  = Tracks.Z;
% for m = 1 : M
 % Standardization:
   Out.X = (X - mean(X, 1)) ./ std(X, 1);
   Out.Y = (Y - mean(Y, 1)) ./ std(Y, 1);
   Out.Z = (Z - mean(Z, 1)) ./ std(Z, 1);
% end
%---------------------------------------|         
end
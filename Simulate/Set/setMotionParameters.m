%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~|
function   Out   = setMotionParameters(In)
           Out   = In     ;  % Avoids overwriting the structure.
if~isfield(Out,"D");    Out.D =  5 / 100;    end  % Diffusivity.
%% Assign Shorthand Variables:
   Bounds = In.Bounds       ;              M = In.M            ;
     Mean = In.Prior.R0.Mean;             sD = In.Prior.R0.sDev;
%% Initialize simulation                                       :
     rX = randn(1,M);    rY = randn(1,M);      rZ = randn(1,M) ;
     RZ = 2*(double(rand(1, M) < 1/2) - 1/2)                   ;
%% Draw initial positions                                      :
     X0 = Mean(1)      + sD(1) * rX                            ;
     Y0 = Mean(2)      + sD(2) * rY                            ;
     Z0 = Mean(3) * RZ + sD(3) * rZ                            ;
%--------------------------------------------------------------|
%                        Assign  Output                        :
     Out.X(1,:) = X0;    Out.Y(1,:) = Y0;    Out.Z(1,:) = Z0   ;
%--------------------------------------------------------------|
end
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~|

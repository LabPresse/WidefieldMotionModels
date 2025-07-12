function Out   = simulateEmission(In,varargin)
%{
  if~nargin
     In = simulateBm...
    else
      for any = 1 : nargin - 1
      end
    end
%}
        Out        = In                      ;
        Out.S      = simulatePhotostates(In) ;
    %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~|
    % Neglect Photobleaching:
        Out.S(:,:) = 2                       ; % <--- TURN BACK OFF!
    %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~|
        [u,R]      = simulateExpectation(Out);    Out.u = u;    Out.ExpectedR = R;
        Out.w      = simulateMeasurement(Out);
end
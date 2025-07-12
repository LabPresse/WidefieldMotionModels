function Out   = simulateEmission(In,varargin)
        Out        = In                      ;
        Out.S      = simulatePhotostates(In) ;
    %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~|
    % Neglect Photobleaching:
        Out.S(:,:) = 2                       ; % <--- TURN BACK OFF!
    %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~|
        [u,R]      = simulateExpectation(Out);    Out.u = u;    Out.ExpectedR = R;
        Out.w      = simulateMeasurement(Out);
end
function w = simulateMeasurement(In)
% Define shorthand variables:
         u = In.u    ;    G  = In.G    ;
if   isfield(In,"QE");    QE = In.QE   ; % Quantum Efficiency.
else                 ;    QE = 1       ;
                             % 95 / 100; % Typical of EMCCDs.
end
%% Simulate Gamma-distributed detector noise:
   w = 2*G * randg(QE*u / 2);
end

function showSamples(Chain)
  I = Chain.Length;
  
  unChain.logPosterior = Chain.logPosterior ;
  unChain.Parameters   = Chain.Parameters   ;
    Chain.T(1)         = Chain.Parameters.T0; % <groundSample> used to store this value incorrectly.
  unChain.T            = Chain.T            ;

  for i = 1 : I
      Sample.i = i                ; % Iteration
      Sample.T = Chain.T(i)       ; % Simulated Annealing Temperature
      Sample.B = nnz(Chain.b(i,:)); % Photophysically Active Molecules
                 Sample.On.B = Sample.B;
      Sample.D = Chain.D(i)       ; % Diffusivity
      Sample.F = Chain.F(i)       ; % Ambient Photon Flux
      Sample.G = Chain.G(i)       ; % Electron-Multiplying Gain
      Sample.h = Chain.h(i)       ; % Photon Emission Rate

      unChain.Sample = Sample;    
      showSample(unChain)    ;    unChain = rmfield(unChain, "Sample");      
  end
end
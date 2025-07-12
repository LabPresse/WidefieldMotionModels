function Out   = setEmissionParameters(In)
         Out   = In      ; % Don't overwrite structure.
         Out.f = 2       ; % EMCCD Excess Noise Factor.
if~isfield(Out,"F");  Out.F = 10^(5);  end % Background Photon Flux [γ/μm2s].
if~isfield(Out,"G");  Out.G = 100   ;  end % EMCCD Gain             [1/ADU] .
if~isfield(Out,"h");  Out.h = 10^(4);  end % Photon Emission Rate   [γ/s]   .
end
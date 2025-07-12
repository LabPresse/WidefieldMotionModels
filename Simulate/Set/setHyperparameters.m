function Hyperparameter = setHyperparameters(In)
                 Bounds = In.Bounds;
%------------------------------------------------------------|
Hyperparameter.R0.Mean(1) = (Bounds.X(1) + Bounds.X(end)) / 2; % [μm]
Hyperparameter.R0.Mean(2) = (Bounds.Y(1) + Bounds.Y(end)) / 2; % [μm]
Hyperparameter.R0.Mean(3) = 1/5                              ; % [μm]
%------------------------------------------------------------|

%---------------------------------|
Hyperparameter.R0.sDev(1) = 5 / 10; % [μm]
Hyperparameter.R0.sDev(2) = 2 / 10; % [μm]
Hyperparameter.R0.sDev(3) = 2 / 10; % [μm]
%---------------------------------|

%---------------------------------------------------|
Hyperparameter.F.phi = 2                            ;
if isfield(In,"Measurements")                       % 
Hyperparameter.F.psi = In.f                       ...
                     * mean(In.Measurements(:))^2 ...
                     / var(In.Measurements(:))    ...
                     / Time.Exposure              ...
                     / (sum(Bounds.PA, "All")     ... 
                     / Bounds.Px                  ... 
                     / Bounds.Py)                   ; 
end                                                 %
                     % [γ/(𝔸⋅t)]                    %
%---------------------------------------------------|

%----------------------------------------------|
Hyperparameter.h.phi = 2                       ;
if isfield(Hyperparameter.F,"psi")             %
Hyperparameter.h.psi = Hyperparameter.F.psi  ...
                     * 5*pi * 2*log(2)       ...
                     * Optic.PSF.Reference.XY^2;
end                                            %
                     % γ/[t]                   %
%----------------------------------------------|

%----------------------------------------------------|
Hyperparameter.D.phi = 5                             ;
Hyperparameter.D.chi = (1 - 1 / Hyperparameter.D.phi);
                     % [𝔸/t]                         %
%----------------------------------------------------|

%-------------------------------------------------------|
Hyperparameter.G.phi = 2                                ;
if isfield(In,"Measurements")                           %
Hyperparameter.G.chi = (1 - 1 / Hyperparameter.G.phi) ...
                     *  var(In.Measurements(:))       ...
                     / mean(In.Measurements(:)) / In.f  ;
                     % [γ]                              %
end                                                     %
%-------------------------------------------------------|

%------------------------------------------------------------------|
Hyperparameter.emitterPhotons = 0.05                               ;
In.emitterLoad = (rand(1, In.M) <= Hyperparameter.emitterPhotons ...
                / (Hyperparameter.emitterPhotons + In.M - 1))      ;
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~|
%==================================================================|

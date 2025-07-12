function Parameters = initialParameters(Input)
%% Sizes
    Bounds.Px = size(Input.w, 1)     ;    
    Bounds.Py = size(Input.w, 2)     ;    
    Bounds.P  = Bounds.Px * Bounds.Py;

    K = 5              ;  % Interpolations per Frame.
%   M = 100; Imposed nonparametric limit for emitters.
    N = size(Input.w, 3); % Frames
%% Pixel boundaries and data
    Bounds.X = reshape(Input.Bounds.X, Bounds.Px + 1, 1); % [μm]
    Bounds.Y = reshape(Input.Bounds.Y, 1, Bounds.Py + 1); % [μm]
    Bounds.PA = diff(Bounds.X) * diff(Bounds.Y);
    Bounds.PcA = reshape(diff(Bounds.X) * diff(Bounds.Y), Bounds.P, 1);
    w = reshape(Input.w, Bounds.Px, Bounds.Py, N);

%% Image discretization
      ONE = ones(1, K - 2);
    tCoeff = [1/2  ONE  1/2] / (K - 1); % composite trapezoid
%% Time levels
    Time.Frame    = Input.Time.Frame     ; % [s] frame separation
    Time.Exposure = Input.Time.Exposure  ; % [s] exposure time
    Bounds.t      = Time.Frame * (0 : N)'; % [s] tn
    Time.Index    = reshape(1 : N * K, K, N)' ;
    tDelta        = Time.Frame - Time.Exposure;
    Time.Levels   = reshape(bsxfun( @plus, Bounds.t(1 : N), linspace(tDelta/2, Time.Frame - tDelta/2, K))', N * K, 1);
                  % getRuler(Bounds.t(end), N*K);
%% Diffusion coefficient
    Prior.D.phi = 5                          ;
    Prior.D.chi = (1 - 1 / Prior.D.phi) * 0.1; % [μm²/s]
%% Optical parameters
    Parameters.PSF = Input.Optic.PSF       ;
    f    = Input.f                         ; % Excess noise factor

    logW = reshape(log(w / f), Bounds.P, N);
%% Emission Hyperparameters:
    Prior.F.phi = 2                                              ;
    Prior.F.psi = f                                            ...
                * mean(w(:))^2                                 ...
                / var(w(:))                                    ...
                / Time.Exposure                                ...
                / (sum(Bounds.PA, "All") / Bounds.Px / Bounds.Py); % [γ/μm²s]

    Prior.h.phi = 2                                                                ;
    Prior.h.psi = Prior.F.psi * 5 * pi * 2 * log(2) * Parameters.PSF.Reference.XY^2; % [γ/s]

    Prior.G.phi = 2                           ;
    Prior.G.chi = (1 - 1 / Prior.G.phi)     ...
                * (var(w(:)) / mean(w(:)) / f); 
                % [ADU / γ]
%% Beta(b)-Bernoulli(B) hyperparameters:
   Prior.b.gamma = 1/2;
%% Hyperparameters of initial position:
    Prior.R0.Mean(1) = 1/2 * (Bounds.X(end) - Bounds.X(1));  % [μm]
    Prior.R0.Mean(2) = 1/2 * (Bounds.Y(end) - Bounds.Y(1));  % [μm]
%   Prior.R0.Mean(3) = Parameters.PSF.Reference.Z;           % [μm]
    Prior.R0.Mean(3) = 0;

    Prior.R0.sDev(1) = 3/10 * (Bounds.X(end) - Bounds.X(1)); % [μm]
    Prior.R0.sDev(2) = 3/10 * (Bounds.Y(end) - Bounds.Y(1)); % [μm]
    Prior.R0.sDev(3) = Parameters.PSF.Reference.Z;           % [μm]
%% Parameter's Annealing & Metropolis Hasting Parameters:
    Parameters.iSkip     =    1       ;
    Parameters.T0        = 200 / 3 / 4; % Simulated annealing initial temperature.
                         % <--- lowered for anomalous single particles.
    Parameters.paceT     =   1   / 100;
    Parameters.iAnnealed = 750        ; % Iteration at which simulated annealing ends.
 %                       &
    Parameters.MH_sc     = [[100  100  2]    [5  5  5]/100];
                         % [[100  100  2]    [3/10*K  1  1/100]];
%% Miscellaneous
 % Account for Ground Truth when present:
   if     isfield(Input, "GroundTruth");    Parameters.GroundTruth = Input.GroundTruth;    end

%% Final Assignments:
   Parameters.K = K;    Parameters.M    = 100   ;    Parameters.N = N;
   Parameters.w = w;    Parameters.logw = log(w);    
                        Parameters.logW = logW  ;
   Parameters.f = f;
   Parameters.tCoeff = tCoeff;    
   Parameters.Prior = Prior;    Parameters.Time = Time;    Parameters.Bounds = Bounds;
end
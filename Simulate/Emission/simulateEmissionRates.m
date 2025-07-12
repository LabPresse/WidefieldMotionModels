function [h, F] = simulateEmissionRates(In)
           disp("<simulateEmissionRates> needs to be verified.")
  %~~~~~~~~~~~~~~~~~~~~~~~~~~~~|
  tau = In.Time.Exposure      ; % tau <-- tExposure
   dX = diff(In.Bounds.X)     ; % (NEED TO CHECK!)
   dY = diff(In.Bounds.Y)     ; % (NEED TO CHECK!)
  if isfield(In,"Optic")      %
    PSF = In.Optic.PSF        ;
  else                        %
  Optic = In.Parameters.Optic ;
    PSF = Optic.PSF           ;
  end                         %
  %~~~~~~~~~~~~~~~~~~~~~~~~~~~|

    g = integratePSFs(0, 0, 0, [-dX/2    +dX/2], [-dY/2    +dY/2], PSF);
    h = 5 * 2 * 0.1 * 100 / tau / g ; % (   Emitter photon count) / [time]
    F = 2 * 0.2 * h * g  / (dX * dY); % (Background photon count) / [area*time]

    % h = h /20;
    % F = F / 3.5;

    disp("   Emitter Photons collected in one {pixel, exposure period} = " + num2str(h * g *      tau))
    disp("Background Photons collected in one {pixel, exposure period} = " + num2str(F * dX * dY * tau))

function Optic = setOptic(In)
  if~nargin
    Optic.numericalAperture  = 1.450;                  
    Optic.refractiveIndex    = 1.515;                  % (Immersion fluid).
    Optic.emissionWavelength = 0.665;                  % [μm]
  else
    Optic.numericalAperture  = In.numericalAperture ; 
    Optic.refractiveIndex    = In.refractiveIndex   ; % (Immersion fluid).
    Optic.emissionWavelength = In.emissionWavelength; % [μm]
  end
    Optic.AbbeLimit          = Optic.emissionWavelength / 2 / Optic.numericalAperture;
    Optic.PSF                = setPSF(Optic);
end
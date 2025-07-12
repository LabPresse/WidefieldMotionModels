function PSF = setPSF(In)
if nargin < 1
    In.numericalAperture   = 1.45 ; 
      In.refractiveIndex   = 1.515; % (of immersion fluid).
   In.emissionWavelength   = 0.561; % [μm] (in vacuum). 
end
 
 halfAngleMAXlightCone = asin(In.numericalAperture / In.refractiveIndex);
            rootCosine = sqrt(cos(halfAngleMAXlightCone));
           cubedCosine = rootCosine^3;
          septumCosine = rootCosine^7;
              FactorNA = (7*(1-cubedCosine))/(4-7*cubedCosine+3*septumCosine);

  PSF.Reference.XY = In.emissionWavelength/2/pi/In.refractiveIndex*sqrt(FactorNA); % [μm]
  PSF.Reference.Z  = In.emissionWavelength/pi/In.refractiveIndex*FactorNA;         % [μm]
  %PSF.Matrix      = exp()./() ...
  %               ./ sum(exp()./(),"All") 
  PSF.Tag          = 1; % "Gaussian";
end
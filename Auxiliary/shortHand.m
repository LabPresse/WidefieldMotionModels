
if~exist("Parameters",'var');    Parameters = Chain.Parameters;    end

%% Assign Shorthand Variables        :
 % Dimensionless Parameters          :
     K     = Parameters.K            ;
     M     = Parameters.M            ;
     N     = Parameters.N            ;

     w     = Parameters.w            ;
  logw     = Parameters.logw         ;
  logW     = Parameters.logW         ;
 % Time                              : 
     tk    = Parameters.Time.Levels  ;
     tE    = Parameters.Time.Exposure;
     tI    = Parameters.Time.Index   ;
     Dt    = diff(tk)                ;
 % Boundaries                        :
     xB    = Parameters.Bounds.X     ;
     yB    = Parameters.Bounds.Y     ;
     Px    = Parameters.Bounds.Px           ;
     Py    = Parameters.Bounds.Py           ;
     P     = Parameters.Bounds.P            ;
     PA    = Parameters.Bounds.PA    ; % Pixel Area
     PcA   = Parameters.Bounds.PcA   ; % Pixel Column Area
 % Discretization                    :
     tCoeff = Parameters.tCoeff        ;

 % Emission Parameters               :
      f    = Parameters.f            ;

 % Hyperparameters                   :  
    Mean     = Parameters.Prior.R0.Mean;
    sD     = Parameters.Prior.R0.sDev;
    phiD   = Parameters.Prior.D.phi  ;
    chiD   = Parameters.Prior.D.chi  ;
    phiG   = Parameters.Prior.G.phi  ;
    chiG   = Parameters.Prior.G.chi  ;
    phiF   = Parameters.Prior.F.phi  ;
    psiF   = Parameters.Prior.F.psi  ;
    phiH   = Parameters.Prior.h.phi  ;
    psiH   = Parameters.Prior.h.psi  ;
    gammaB = Parameters.Prior.b.gamma;

 % Optical Parameters                :
     PSF   = Parameters.PSF          ;
     refS  = PSF.Reference.XY        ;
     refZ  = PSF.Reference.Z         ;

 % Sampling Parameters               :
     MH    = Parameters.MH_sc        ;
     T0    = Parameters.T0           ;
     iT    = Parameters.iAnnealed         ;

%% (Optional) Load Samples
if exist("loadSamples",'var')
  if loadSamples
      i = Sample.i;
     Ti = Sample.T;
     bi = Sample.b;
     Xi = Sample.X;
     Yi = Sample.Y;
     Zi = Sample.Z;
     Di = Sample.D;
     Ri = Sample.RecordedPositions;
     Gi = Sample.G;
     Fi = Sample.F;
     Hi = Sample.h;
    FHi = Sample.RecordedEmissionRates;

     
     
  end
end
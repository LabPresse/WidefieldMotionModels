function Bounds      = setBoundaries(In)
%% Lengths
         Bounds.PL   =  0.133                     ; % [μm]  Pixel sideLength.
         Bounds.X    = (0 : In.FoV(1)) * Bounds.PL; % [μm] xPixel Boundaries.
         Bounds.Y    = (0 : In.FoV(2)) * Bounds.PL; % [μm] yPixel Boundaries.
%% Counts
         Bounds.Px   = length(Bounds.X) - 1        ; % [pixel] Count along width .
         Bounds.Py   = length(Bounds.Y) - 1        ; % [pixel] Count along height. 
%% Areas
         Bounds.P    = Bounds.Px * Bounds.Py       ; % [pixel] Count in the FoV      .
         Bounds.PA   = diff(reshape(Bounds.X, Bounds.Px + 1, 1)) * diff(reshape(Bounds.Y, 1, Bounds.Py + 1));
         Bounds.PcA  = reshape(diff(reshape(Bounds.X, Bounds.Px + 1, 1)) * diff(reshape(Bounds.Y, 1, Bounds.Py + 1)), Bounds.P, 1);
%% Times
 % Establish temporal boundaries of frames                                              :
         Bounds.t    = In.Time.Frame * (0 : In.N)                                       ;
         Bounds.tEnd = Bounds.t(end)                                                    ;
         Bounds.tMin = Bounds.t(1 : In.N)     + 1/2 * (In.Time.Frame - In.Time.Exposure);
         Bounds.tMax = Bounds.t(2 : In.N + 1) - 1/2 * (In.Time.Frame - In.Time.Exposure);
 % Establish boundaries of exposure                                                   :
         Be          = Bounds.t(1 : end - 1) + (In.Time.Frame - In.Time.Exposure)/2   ;
         Be(2,:)     = Be(1,:) + In.Time.Exposure;                Bounds.Exposure = Be;
end
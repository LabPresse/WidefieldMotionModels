%%  This script stores updated samples.
 % NB:   Xi,Yi,Zi    should be  the same as    (Xi(:,bi),Yi(:,bi),Zi(:,bi) & Xi(:,C),Yi(:,C),Zi(:,C))
                                               %    ^  find(b)             &     ~b.
% {i,Ti; Xi,Yi,Zi; Fi,Gi,FHi; Hi, bi, Di,Ri}    are    updated in the Update.m script.
%  ✓ ✓  ✓  ✓  ✓  ✓  ✓  ✓   ✓   ✓   ✓ ✓
                                        %#ok<*IJCL>
    Sample.i                     =   i; % ✓ 
    Sample.T                     =  Ti; % ✓
    Sample.b                     =  bi; % ✓
    Sample.X                     =  Xi; % ✓
    Sample.Y                     =  Yi; % ✓
    Sample.Z                     =  Zi; % ✓
    Sample.D                     =  Di; % ✓
    Sample.RecordedPositions     =  Ri; % ✓
    Sample.G                     =  Gi; % ✓
    Sample.F                     =  Fi; % ✓
    Sample.h                     =  Hi; % ✓
    Sample.RecordedEmissionRates = FHi; % ✓
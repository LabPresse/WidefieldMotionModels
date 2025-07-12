%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~|
function Graph = calculateAxes(varargin) % BEST USED WITH A STRUCTURE; HAVE NOT TEST INDEPENDENT INPUTS.
%----------------------------------------------------------------------------------------------------------------------|
%% Interpret input:
  for any = 1 : nargin
      Any = varargin{any}        ;
      if    isstruct(Any)        ;    In      = Any       ;      
        if ~isfield(In,"Axes")   ;    Axes    = gca       ;    end
        if  isfield(In,"xData")  ;    xData   = In.xData  ;    end
        if  isfield(In,"x")      ;    xData   = In.x      ;    end
        if  isfield(In,"X")      ;    xData   = In.X      ;    end
        if  isfield(In,"yData")  ;    yData   = In.yData  ;    end
        if  isfield(In,"y")      ;    yData   = In.y      ;    end
        if  isfield(In,"Y")      ;    yData   = In.Y      ;    end
        if  isfield(In,"zData")  ;    zData   = In.zData  ;    end
        if  isfield(In,"z")      ;    zData   = In.z      ;    end
        if  isfield(In,"Z")      ;    zData   = In.Z      ;    end
        if  isfield(In,"Azimuth");    Azimuth = In.Azimuth;    end
        if  isfield(In,"Zenith") ;    Zenith  = In.Zenith ;    end
      end
    if        skipIt(Any)
      if     areAxes(Any);     Axes = Any;    end
      if    isstring(Any);    Units = Any;    end % <--- NOT IDEAL:  What if inputting string labels?
    else
      if        isnumeric(Any    ) && nargin > any    ;    xData = Any; 
        if      isnumeric(Any + 1) && nargin > any + 1;    yData = varargin{any + 1};
          if    isnumeric(Any + 2)                    ;    zData = Any; 
%         else;                                            zData = "";  % <--- support for 2D cases.
          end
        end
      end
    end
    if ~exist("Axes", 'var');     Axes = gca;    end;    %if ~exist("xData",'var');    xData = NaN;    end
  % if ~exist("yData",'var');    yData = NaN;    end;    %if ~exist("zData",'var');    ZData = NaN;    end
    if ~exist("Units", 'var');   Units = "" ;    end;
  end
%----------------------------------------------------------------------------------------------------------------------|
%======================================================================================================================|
%% Calculations:
  xMin = min(xData,[],"All");  xMax = max(xData,[],"All");    xLim = [xMin   xMax];    xDelta = xMax - xMin      ;
  yMin = min(yData,[],"All");  yMax = max(yData,[],"All");    yLim = [yMin   yMax];    yDelta = yMax - yMin      ;
                                                              rLim = [xLim;  yLim];    rDelta = [xDelta;  yDelta];
  xMid = xMin + xDelta/2;    xTicks = [xMin      xMid      xMax];
  yMid = yMin + yDelta/2;    yTicks = [yMin      yMid      yMax];
  rMid = [xMid;    yMid];    rTicks = [xTicks;           yTicks];

if exist("zData",'var')
  zMin = min(zData,[],"All");   zMax = max(zData,[],"All");    zLim = [zMin   zMax];    zDelta = zMax - zMin;    
  zMid = zMin + zDelta/2;     zTicks = [zMin      zMid      zMax];
% Reassign quantities outputs (to-be):
  rLim = [rLim;  zLim];       rDelta = [rDelta; zDelta];
  rMid = [rMid;  zMid];       rTicks = [rTicks;  zTicks];
end
   MIN = min(rLim,[],"All");     MAX = max(rLim,[],"All");     Apportioned = (rLim(:,2) - rLim(:,1)) / (MAX - MIN);
%% SPHERICAL ANGLES
if exist("zData",'var') && exist("Azimuth",'var') && exist("Zenith",'var');
   view([Azimuth    Zenith])
%%{
 %                                                               ⇩⇩⇩⇩⇩⇩⇩⇩⇩⇩⇩⇩⇩⇩⇩⇩⇩⇩⇩⇩⇩⇩⇩⇩⇩⇩⇩⇩⇩⇩⇩⇩⇩
%% Label adjustments (6 degrees of freedom): ⇨⇨⇨⇨⇨⇨⇨⇨⇨⇨⇨⇨{NotaBene:  DESIGNED FOR Azimuth < 0}⇦⇦⇦⇦⇦⇦⇦⇦⇦⇦⇦⇦
 %                                                               ⇧⇧⇧⇧⇧⇧⇧⇧⇧⇧⇧⇧⇧⇧⇧⇧⇧⇧⇧⇧⇧⇧⇧⇧⇧⇧⇧⇧⇧⇧⇧⇧⇧
    xShift = [        rMid(1)                    ,    rLim(2,1) - rDelta(2)/rLim(2, 2)/2,    rLim(3,1)];
    yShift = [(rLim(1,1) - rDelta(1)/rLim(1,2))/2,                rMid(2  ),                 rLim(3,1)];
    zShift = [     rLim(1,1)*11/5,                                rLim(2,2),                 rMid(3)  ];
    rShift = [xShift;  yShift;  zShift];

    rAngle = [180/pi * cos(Azimuth)*sin(Zenith);
              360/pi * sin(Azimuth)*sin(Zenith);
              360/pi *              cos(Zenith)];

  if Azimuth > 0 && Zenith > 0;    rAngle(2) = 360 - rAngle(2);    end
% ^^ ^^^^^^^OCT(+ 1)^^^^^^^^^^^ 
% NOT JUST +-,  SO I NEED mod(Azimuth,2*pi) & mod(Zenith,pi)
% OCT(-1): if Azimuth > 0 && Zenith < 0;    ... I'll take 5 minutes to fix this soon. end
% OCT(+2):
% OCT(-2): 
% OCT(+3): 
% OCT(-3): 
% OCT(+4): 
% OCT(-4): 
%% toDo:   FIX {rShift,rAngle}:  formulate symmetry arguments by octant 
   % OCTANTS({+,-}):  (O(+1):  Q1: 0<=Azimuth<=pi/2;  Q2:  pi/2<=Azimuth<=pi; 
   %                           Q3:pi<=Azimuth<=3pi/4;  Q4: 3pi/4<=Azimuth<=2pi
   %                  (O(-1):  SAME except pi/2<Zenith<=pi

  
  %if Azimuth > 0;    rShift(2,1) = -rShift(2,1);    rAngle(2) = -rAngle(2);    <---- notFIXED!
end
%                                  Assign  Output                                  :
  Graph.rLim = rLim   ;    Graph.rMid   = rMid  ;      Graph.rDelta = rDelta       ;
% Graph.Limits = Limits;     Graph.Ticks  = Ticks        ;
% Graph.TickLabels = TickLabels;
end
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~|


function   It = skipIt(In);    It = false        ;  if areAxes(In) | isFigure(In) | isstring(In) | isArray(In);  It = true;  end;  end
                                                                 % | accounts for nonscalars.    % ^^^^^^^^^^^^ OUCH! Necessary.
%{
CAN'T PARSE BY NAME FOR ARRAYS!
      if isnumeric(Any);    Iny = inputname(varargin{any}); 
        if     Iny == "xData";  xData = Any;  elseif Iny == "yData";  yData = Any;  elseif Iny == "zData";  zData = Any;
        elseif Iny == "cData";  cData = Any;  elseif Iny == "tData";  tData = Any;
        elseif isstring(Any) || ischar(Any) || iscell(Any);  if Iny  == "Units";  Units  = Any;  end
                                                             if Iny == "Option";  Option = Any;  end
%}
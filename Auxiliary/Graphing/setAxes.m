







%{

LOOK AT THIS, DUMMY!LOOK AT THIS, DUMMY!LOOK AT THIS, DUMMY!LOOK AT THIS, DUMMY!LOOK AT THIS, DUMMY!LOOK AT THIS, DUMMY!
LOOK AT THIS, DUMMY!LOOK AT THIS, DUMMY!LOOK AT THIS, DUMMY!LOOK AT THIS, DUMMY!LOOK AT THIS, DUMMY!LOOK AT THIS, DUMMY!
LOOK AT THIS, DUMMY!LOOK AT THIS, DUMMY!LOOK AT THIS, DUMMY!LOOK AT THIS, DUMMY!LOOK AT THIS, DUMMY!LOOK AT THIS, DUMMY!
LOOK AT THIS, DUMMY!LOOK AT THIS, DUMMY!LOOK AT THIS, DUMMY!LOOK AT THIS, DUMMY!LOOK AT THIS, DUMMY!LOOK AT THIS, DUMMY!
LOOK AT THIS, DUMMY!LOOK AT THIS, DUMMY!LOOK AT THIS, DUMMY!LOOK AT THIS, DUMMY!LOOK AT THIS, DUMMY!LOOK AT THIS, DUMMY!

if exist("Units",'var')
  if    Units == "" || isempty(Units)
         <>  ---- PUT 10^(Exponent) IN XLABEL !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  else;  <>  ---- PUT      Units    IN XLABEL !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  end
end


LOOK AT THIS, DUMMY!LOOK AT THIS, DUMMY!LOOK AT THIS, DUMMY!LOOK AT THIS, DUMMY!LOOK AT THIS, DUMMY!LOOK AT THIS, DUMMY!
LOOK AT THIS, DUMMY!LOOK AT THIS, DUMMY!LOOK AT THIS, DUMMY!LOOK AT THIS, DUMMY!LOOK AT THIS, DUMMY!LOOK AT THIS, DUMMY!
LOOK AT THIS, DUMMY!LOOK AT THIS, DUMMY!LOOK AT THIS, DUMMY!LOOK AT THIS, DUMMY!LOOK AT THIS, DUMMY!LOOK AT THIS, DUMMY!
LOOK AT THIS, DUMMY!LOOK AT THIS, DUMMY!LOOK AT THIS, DUMMY!LOOK AT THIS, DUMMY!LOOK AT THIS, DUMMY!LOOK AT THIS, DUMMY!

%}









%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~|
function Graph = setAxes(varargin) % BEST USED WITH A STRUCTURE; HAVE NOT TEST INDEPENDENT INPUTS.
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
        if  isfield(In,"Title")  ;    Title   = In.Title  ;    end 
        if  isfield(In,"Legend") ;    Legend  = In.Legend ;    end
      end
    if        skipIt(Any)
      if     areAxes(Any);     Axes = Any;    end
      if    isstring(Any);    Units = Any;    end % <--- NOT IDEAL:  What if inputting string labels?
    else;
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
%======================================================================================================================|
%----------------------------------------------------------------------|
%% Set Figure Properties According to Calculations:
% Title:
if exist("Title",'var')
   if isstring(Title)
      Title    = title(Axes, Title,    "Interpreter",'LaTeX');
   end
else
      Title    = title(Axes, "",       "Interpreter",'LaTeX');
end

% Legend:
if exist("Legend",'var')
   if isstring(Legend)
      Legend = legend(Axes, Legend,    "Interpreter",'LaTeX');
   end
else
      Legend = legend(Axes, "",       "Interpreter",'LaTeX');
end

      LABEL    = "$" + ["x"  "y"] + "\ [" + Units + "] \ $"  ;
      Label(1) = xlabel(Axes,LABEL(1), "Interpreter",'LaTeX');
      Label(2) = ylabel(Axes,LABEL(2), "Interpreter",'LaTeX');
if exist("zData",'var');
      LABEL(3) = "$ z \ [" + Units + "] \ $"                 ;
      Label(3) = zlabel(Axes,LABEL(3), "Interpreter",'LaTeX');
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SCALING: 
          Apportion = true             ;
          epsilon   = 100*eps("double"); % <--- less tolerant than single or double.
for   i = size(Apportioned,1)
  for j = size(Apportioned,2)
    if     rLim(i,1) ~= 0
      if     Apportioned(i,j)/rLim(i,1) < epsilon;    Apportioned = Apportioned + epsilon;
      end
    elseif rLim(i,2) ~= 0
      if     Apportioned(i,j)/rLim(i,2) < epsilon;    Apportioned = Apportioned + epsilon;
      else;  Apportioned = ones(size(Apportioned));
      end
    end
    if  Apportioned(i,j) < 2*epsilon;    Apportion = false;    end
  end
end
if Apportion == true;    daspect(Axes, Apportioned);    else;    daspect auto;    end
%{
if (xMax > 10^4*yMax | xMax > 10^4*zMax)  ... 
|| (yMax > 10^4*xMax | yMax > 10^4*zMax)  ...
|| (zMax > 10^4*xMax | zMax > 10^4*yMax)
   daspect(Axes, Apportioned)
end
%}
set(Axes, "XGrid",'on', "YGrid",'on', "YDir",'normal', "MinorGridLineStyle",':', "Layer",'bottom', "FontSize",13)
     if xDelta/xMax > epsilon      ;    xlim(Axes, xLim);   xticks(Axes, xTicks);    
        xPonent = getExponent(xMin);    xticklabels(Axes, string( round(xTicks, abs(xPonent)+1) ));
     end
     if yDelta/yMax > epsilon      ;    ylim(Axes, yLim);   yticks(Axes, yTicks);    
        yPonent = getExponent(yMin);    yticklabels(Axes, string( round(yTicks, abs(yPonent)+1) ));
     end
%{
    set(Axes, "XGrid",'on', "XLim",xLim, "XTick",xTicks, "XTickLabels",string(round(xTicks,1)), ... rLim(1,:) 
              "YGrid",'on', "YLim",yLim, "YTick",yTicks, "YTickLabels",string(round(yTicks,1)), ... rLim(2,:)
              "MinorGridLineStyle",':', "Layer",'bottom', "FontSize",13)
%}
  if exist("zData",'var')
     set(Axes, "ZGrid",'on')       ;
     if zDelta/zMax > epsilon      ;    zlim(Axes, zLim);    zticks(Axes, zTicks);    
        zPonent = getExponent(zMin);    zticklabels(Axes, string( round(zTicks,abs(zPonent)+1) ));
     end
  end
%----------------------------------------------------------------------------------%
%                                  Assign  Output                                  :
  Graph.rLim = rLim   ;    Graph.rMid   = rMid  ;      Graph.rDelta = rDelta       ;
  Graph.Label  = Label;    Graph.Title  = Title;       Graph.Legend = Legend       ;
   Graph.Axes = Axes;
% Graph.Limits = Limits;     Graph.Ticks  = Ticks        ;
% Graph.TickLabels = TickLabels;
%----------------------------------------------------------------------------------%
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
function                                          ...
           Line  = getRuler(extrema,  varargin)
  if     nargin == 1;      nPoints = 100;    Scale = "Linear";
  else
    for   each  = 1 : nargin - 1;    Each    = varargin{each};
      if         iscellstr(Each);    Each    =   string(Each);    end
        if        isstring(Each);    Scale   =          Each ;
        elseif    isscalar(Each);    nPoints =          Each ;
        end
    end
  end; 
  if~exist("Scale",'var');    Scale = "Linear";    end
  if Scale == "log" && ~exist("nPoints",'var');    nPoints = range(extrema) + 1;    end

  if    nPoints == 1;     Line = extrema(end);  
  else
    if isscalar(extrema)
       extrema(2) = extrema(1);   extrema(1) = 0      ;    
%    disp("<getRuler>: Coordinate ∈ [0,Input(1)] ⟸ Input(1) = scalar.");
    end
            Delta = extrema( 2 ) - extrema( 1 )       ;
            delta =        Delta / (nPoints-1)        ;
             Line = extrema(1):delta:extrema(2)       ;
    if Scale == "log" || Scale == "logarithm" || Scale == "Log" || Scale == "Logarithm";  Line = 10 .^ Line;  end
  end
end


%{
function                                          ...
           Line  = getRuler(extrema,  varargin)
  if     nargin == 1;    nPoints = 100              ;
  elseif nargin == 2;    nPoints = varargin{1}      ;
  end

  if    nPoints == 1;       Line = extrema(end);  
  else
    if isscalar(extrema)
       extrema(2) = extrema(1);   extrema(1) = 0      ;    
%    disp("<getRuler>: Coordinate ∈ [0,Input(1)]" ...
%        +       " ⟸ Input(1) = scalar.")          ;
    end
            Delta = extrema( 2 ) - extrema( 1 )       ;
            delta =        Delta / (nPoints-1)        ;
             Line = extrema(1):delta:extrema(2)       ;
  end
end
%}
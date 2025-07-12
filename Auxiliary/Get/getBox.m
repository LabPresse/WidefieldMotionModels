% BUILD for vector input.
function                                    ...
Mesh = getBox(Extrema, varargin)
                          Center = [0;0;0]    ;
  if     nargin == 1;    nPoints = 100        ;
  elseif nargin  > 1;    nPoints = varargin{1};    
      if nargin  > 2;     Center = varargin{2};    end
  end
% if size(Extrema)     == [1  3];    Extrema = Extrema';    end  !Warn<getBox>[10]: 3D only!
  if size(Extrema,  1) == 1 && size(Extrema,2) > size(Extrema,1);    Extrema = Extrema';    end
  if size(Extrema,  2) == 1;    %disp("<getBox>:  Coordinates ∈ [𝟘,{Input(1)}] ⟸ {Input(1)} = (n×1)Matrix.");
          Extrema(:,2)  = Extrema(:,1);    Extrema(:,1) = zeros(size(Extrema,1),1);    
  end

          I  = size(Extrema,1);    
    if isscalar(nPoints);   Line      = zeros(I, nPoints);
      for i  = 1 : I    ;   Line(i,:) = getRuler(Extrema(i,:), nPoints);    end
       if I == 2     % Two-Dimensional Case
            [X, Y] = ndgrid(Line(1,:), Line(2,:));
             X     = Center(1) + X;    Mesh.X = X;
                Y  = Center(2) + Y;    Mesh.Y = Y;
       elseif I == 3 % Three-Dimensional Case
       [X, Y, Z] = ndgrid(Line(1,:), Line(2,:), Line(3,:));
        X        = Center(1) + X;   Mesh.X = X;
           Y     = Center(2) + Y;   Mesh.Y = Y;
              Z  = Center(3) + Z;   Mesh.Z = Z;
       end
    else; String0     = "Line";   Stringf = "getRuler(Extrema(i,:), nPoints(i));"      ;
      for       i     = 1 : I ;   String  = String0 + num2str(i, "%#d") + "=" + Stringf;    eval(String);    end
      if        I    == 2 %   Two-Dimensional Case :
            [X, Y]    = ndgrid(Line1, Line2)     ;
        Mesh.X        = X;    Mesh.Y = Y           ;
      elseif       I == 3 % Three-Dimensional Case     :
            [X, Y, Z] = ndgrid(Line1, Line2, Line3)  ;
        Mesh.X        = X;    Mesh.Y = Y;    Mesh.Z = Z;
      end
    end
        Mesh.Tag      = "Rectilinear Symmetry.";
end



%% OLD SCRIPT EXCERPT
%{
  if size(Extrema,1) == 2;    disp("!Build<getLattice>[9]:  for 2×2 inputs.");    end
% if size(Extrema)   == [1  3];    Extrema = Extrema';    end  !Warn<getBox>[10]: 3D only!
  if size(Extrema,1) == 1 && size(Extrema,2) > size(Extrema,1);    Extrema = Extrema';    end

  if size(Extrema,2) == 1;    Extrema(:,2) = Extrema(:,1);    Extrema(:,1) = zeros(size(Extrema,1),1);    
     disp("Coordinates ∈ [𝟘,{Input(1)}]"               ...
          +       " ⟸ {Input(1)} = (n×1)Matrix")        ;
  end
%}
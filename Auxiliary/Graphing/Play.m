function  varargout = Play(Array,varargin) 
  %  Animates  Array  about its 3rd axis.
  if            nargin      >  1
    for            any      =  1 : nargin - 1
                   Any      =   varargin{any};    
      if    isnumeric(Any) &&   isscalar(Any);       dt = Any        ;
      elseif isstring(Any) ||  iscellstr(Any);      Any = string(Any);    Iny = inputname(any+1);
          if          Iny  ==  "Limits"      ;   Limits = Any         ;   end
      elseif   isAxes(Any)  ;    Axes = Any ;
      end
%                 Iny   =  getName(Any, any+1);
%     if Iny == "dt";              dt = Any    ;    end            
%     end
    end
  end; if~exist("dt",'var');        dt = 0      ;                            end
  if~exist("Axes",'var')   ;    Figure = figure ;    Axes = axes(Figure);    end
      N = size(Array, 3) ;

  if~exist("Limits",'var')          ;  Limits  = "";    end
if     Limits == "Range"           ||  Limits == "range"
       Limits  = [minimum(Array)                  maximum(Array)];
elseif Limits == "Normalized"      ||  Limits == "normalized"
       Limits  = [min(min(Array,[],3))      max(max(Array,[],3))];
end;if Limits == ""                 ;  Limits = [];    end


  for n = 1 : N
         ArrayXY = Array(:,:,n)'          ; % Reorders Array dimensions (X,Y).
         imshow(ArrayXY, Limits, "Parent",Axes)
           Axes.XAxis.Direction = "Normal";    
           Axes.YAxis.Direction = "Normal";
         drawnow;    pause(dt)
  end
%% Return Output if Requested:
  if nargout;    varargout = Axes;    end

end
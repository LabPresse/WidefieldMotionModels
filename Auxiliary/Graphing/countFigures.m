function N =    countFigures ;    Figures = findobj("type",'figure');    
         N =  length(Figures);
      if N == 0;    N = false;    end
end
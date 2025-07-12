%% Close all graphical objects:
   if countFigures;    close all;    end
%% Reset the directory path & clear variables:
   restoredefaultpath;    
   AUX = string(pwd) + "/Auxiliary";    if ispc;  AUX = strrep(AUX,"/","\");  end;    addpath(AUX)
   clear variables   ;     
%% Activate the Path for Bayes' Diffusion:
   Activate
%% Internal Function (for Inactivated Paths):
function N =    countFigures ;    Figures = findobj("type",'figure');    
         N =  length(Figures);
      if N == 0;    N = false;    end
end
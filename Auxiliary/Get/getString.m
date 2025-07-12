function String  = getString(Number,varargin)  % Version: "Bayes' Diffusion".
% This function returns a number's string formatted in scientific notation.
     Scientific  = false;
  if     Number ==   0  ;    String =  "0" ;    return
  elseif Number == +inf ;    String = "+∞" ;    return
  elseif Number == -inf ;    String = "-∞" ;    return
  elseif  isnan(Number) ;    String = "NaN";    return
  end

  for                any = 1 : nargin - 1
                     Any = varargin{any};
    if     isnumeric(Any);                 Digits = Any ;
    elseif iscellstr(Any);         Any  =    string(Any);
    elseif isstring(Any) || ischar(Any) ; Display = Any ;
    end
  end
  if ~exist("Digits" ,'var');     Digits = 3 ;    end
  if ~exist("Display",'var');    Display = "";    end


  if exist("Display",'var')                                    ...
  && (string(Display) == "Integer" || string(Display) == "Int" ...
  ||  string(Display) == "integer" || string(Display) == "int"   )
      String = num2str(round(Number),"%#d");                return
  end
  if exist("Display",'var')                                              ...
  && (string(Display) == "Scientific" || string(Display) == "scientific" ...
  ||  string(Display) == "Sci"        || string(Display) == "sci"          )
                          Scientific   = true                              ;
  end
%% Define accessible superscripts:
  superScripts = split("¹²³⁴⁵⁶⁷⁸⁹⁰","");   superScripts(superScripts == "") = [];
%% Get the (scientific notation) exponent & coefficient.
      Exponent = getExponent(Number)   ;          
   Coefficient = getCoefficient(Number);    
       Rounded = round(Coefficient)    ;
  if Rounded == 10;     Coefficient = 1;    Rounded = 1;    Exponent = Exponent + 1;    end

   Threshold   = 10^3;  % Threshold for exclusively for Bayes' Diffusion.
   Compare     = Coefficient - round(Coefficient * Threshold) / Threshold;
          With = Coefficient / Threshold         ;
%% Parse exponent and substitute superscripts:
    exponent = split(string(Exponent),"");                   exponent(exponent == "") = [];
  if     Exponent    == -1   &&~Scientific;  String = num2str( Coefficient/10, '%5.'+string(Digits - 1) + 'f');    return
  elseif Exponent    ==  0;                  
      if Coefficient  < 0;                   String = "‒" + num2str(abs(Coefficient),'%5.'+string(Digits - 1) + 'f');
      else;                                  String = num2str(Coefficient,'%5.'+string(Digits - 1) + 'f');
      end
      if Compare      < With &&~Scientific;  String = num2str( Rounded       , "%#d");    end;                     return
  elseif Exponent    == +1;                  String = num2str( Coefficient*10, '%5.'+string(Digits - 1) + 'f');          
      if Compare      < With &&~Scientific;  String = num2str( Rounded    *10, "%#d");    end;                     return
  else
    for each = 1 : length(exponent)
      if     exponent(each) == "0";  exponent(each) = superScripts(10); % <--- disqualified by the line above.
      elseif exponent(each) == "-";  exponent(each) = "⁻"             ;
      else;  exponent(each)  = superScripts(eval((exponent(each))))   ;
      end
    end
           exponent = strjoin(exponent,'');
           Exponent = exponent;
    if     Compare  < With;  Coefficient = num2str(Rounded,"%#d");
    else;                    Coefficient = num2str(Coefficient,'%5.'+string(Digits-1)+'f');
    end
  end

       % COEFFICIENT is UNNECESSARY. Just convert it to a string after this loop, dummy.
         COEFFICIENT  =                       eval(Coefficient)                 ;
  if     COEFFICIENT  <  0;    String  = "‒" + abs(COEFFICIENT) + "·10"+Exponent;
  elseif COEFFICIENT ==  1;    String  =                           "10"+Exponent;
  else
      if Display == "+"   ;    String  = "+" + Coefficient + "·10"+Exponent     ;
      else;                    String  =       Coefficient + "·10"+Exponent     ;
      end
  end
end
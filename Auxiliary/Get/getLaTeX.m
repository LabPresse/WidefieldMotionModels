function String  = getLaTeX(Number,varargin) %#ok<DEFNU>
%% TIP:  Remove the $ symbols or add a space before and after each call.
%{
if length(Number) > 1
    Numbers = Number;
else
    Numbers = Number; % POINTLESS.
end
%}
 Numbers = Number;
for each = 1 : length(Numbers);    Number = Numbers(each);
                   if     nargin == 1;    Digits = 2;    
                   elseif nargin == 2;    Digits = varargin{1};
                   end
    if Number == 0;    String = "$0$";    return;    end
    if ~isempty(findUnits(Number))
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        Measure      = Number;    clear Number
        ProposedUnit = findUnits(Measure);
        Number       = double(separateUnits(Measure));
        syms Power
        UnitExponent = simplify( solve(Measure/(Number*ProposedUnit^Power)==1,Power) );
        Unit         = ProposedUnit^UnitExponent;
% PROPOSED Measure:   Number*ProposedUnit^UnitExponent
    else; UnitExponent = 1;
    end
    if UnitExponent == 1 | Unit == ProposedUnit    %#ok<*OR2>  (| not ||) for multiple {Number}s.
           Exponent  = getExponent(Number)   ;
        Coefficient  = getCoefficient(Number); 
        if     Coefficient(~mod(Coefficient,1)) == Coefficient(:)   ...       % 1    <-- 1.0
%        |     Coefficient( ... ) ~> 1.005*Coefficient   ... %  1 <-- 1.005     {Not always ideal}
%        |     Coefficient( ... ) ~< 0.995*Coefficient   ... %  1 <-- 0.995     {Not always ideal}
            Digits=1;    digCoeff = 0;    digitType = 'd';
        elseif 10*Coefficient(~mod(10*Coefficient,1)) == 10*Coefficient(:) % 1.1 <-- 1.10      FIX! <===<==<=|==========<
            Digits=2;    digCoeff = 0;    digitType = 'f';
        else;                                                                     digCoeff = 2;  digitType = 'f';
        end
          digitTotal = num2str(digCoeff + Digits);%,'d')
%%{
        if   ~exist("Unit",'var')
             if     Exponent    == -1;   %String = "$"+num2str(Coefficient/10, '%#3.'+string(Digits)  + digitType) + "$";
                 if Coefficient == +1;  String(each) = "$"+                                                              "10^{"+string(Exponent)+"}$";   
                 else;                  String(each) = "$"+num2str(Coefficient,    '%#3.'+string(Digits)  + digitType) + "\cdot10^{"+string(Exponent)+"}$";
                 end
             elseif  Exponent   ==  0;  String(each) = "$"+num2str(Coefficient,    '%#3.'+string(Digits)  + digitType) + "$";
             elseif  Exponent   == +1;  String(each) = "$"+num2str(Coefficient*10, '%#3.'+string(Digits-1)+ digitType) + "$";
             else  
               if   Coefficient ~= +1;  String(each) = "$"+num2str(Coefficient,    '%#3.'+string(Digits)  + digitType) + "\cdot10^{"+string(Exponent)+"}$";
               else;                    String(each) = "$"+                                                              "10^{"+string(Exponent)+"}$";
               end
             end
        else 
             if      Exponent == -1;    String(each) = "$"+num2str(Coefficient/10, '%#3.'+string(Digits)  + digitType) + "[\mathrm{"+Unit+"}]$";
             elseif  Exponent ==  0;    String(each) = "$"+num2str(Coefficient,    '%#3.'+string(Digits)  + digitType) + "[\mathrm{"+Unit+"}]$";
             elseif  Exponent == +1;    String(each) = "$"+num2str(Coefficient*10, '%#3.'+string(Digits-1)+ digitType) + "[\mathrm{"+Unit+"}]$";
             else;                      String(each) = "$"+num2str(Coefficient,    '%#3.'+string(Digits)  + digitType) + "\cdot10^{"+string(Exponent)+"}" + "[\mathrm{"+Unit+"}]$";
             end
        end
%%}
%{
        if   ~exist("Unit",'var')
             if     Exponent == -1;    String = "$"+num2str(Coefficient/10, '%#'+digitTotal+'.'+string(Digits)   + digitType) + "$";
             elseif Exponent ==  0;    String = "$"+num2str(Coefficient,    '%#'+digitTotal+'.'+string(Digits)   + digitType) + "$";
             elseif Exponent == +1;    String = "$"+num2str(Coefficient*10, '%#'+digitTotal+'.'+string(Digits-1) + digitType) + "$";
             else;                     String = "$"+num2str(Coefficient,    '%#'+digitTotal+'.'+string(Digits)   + digitType) + "\cdot10^{"+string(Exponent)+"}$";
             end
        else 

             if     Exponent == -1;    String = "$"+num2str(Coefficient/10, '%#'+digitTotal+'.'+string(Digits)   + digitType) + "[\mathrm{"+Unit+"}]$";
             elseif Exponent ==  0;    String = "$"+num2str(Coefficient,    '%#'+digitTotal+'.'+string(Digits)   + digitType) + "[\mathrm{"+Unit+"}]$";
             elseif Exponent == +1;    String = "$"+num2str(Coefficient*10, '%#'+digitTotal+'.'+string(Digits-1) + digitType) + "[\mathrm{"+Unit+"}]$";
             else;                     String = "$"+num2str(Coefficient,    '%#'+digitTotal+'.'+string(Digits)   + digitType) + "\cdot10^{"+string(Exponent)+"}" + "[\mathrm{"+Unit+"}]$";
             end
        end
%}
    else
    end

end
end
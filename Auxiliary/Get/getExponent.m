function Exponent  = getExponent(number, varargin)
% Returns the Base10-Exponent of a {number} in Scientific Notation.
  if nargin > 1 ;
    for any = 1 : nargin -  1;     Any     =  varargin{any}      ;
      if isstring(Any)  ||  ischar(Any)
        if        Any   ==  "Max"         ||  Any == "max"       ;    number = max( number,[],"All");
        elseif    Any   ==  "Mean"        ||  Any == "mean"      ;    number = mean(number,   "All");
        elseif    Any   ==  "Min"         ||  Any == "min"       ;    number = min( number,[],"All");
        elseif    Any   ==  "Sum"         ||  Any == "sum"       ;    number = mean(number,   "All");
        elseif    Any   ==  "Product"     ||  Any == "product"  ...
            ||    Any   ==  "Prod"        ||  Any == "prod"      ;    number = prod(number,   "All");
        elseif    Any   ==  "Reciprocal"  ||  Any == "reciprocal";    number = 1 ./ number          ;
        end
      end
    end
  end;         Exponent  =  round(floor(log10(abs(number))));
end
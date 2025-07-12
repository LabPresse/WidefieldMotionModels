function Coefficient = getCoefficient(Number)
% Returns the Coefficient of a {number} in Scientific Notation to the precision specified by {digits}.
    if ~isempty(findUnits(Number));  Number = separateUnits(Number);   end
    Coefficient = double(Number./(10.^(floor(log10(abs(Number))))));
    Coefficient(Number == 0) = 0                                   ;
end
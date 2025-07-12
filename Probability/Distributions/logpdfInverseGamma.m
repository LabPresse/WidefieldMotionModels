function logPDF = logpdfInverseGamma(variable,shape,scale)
         if isnumeric(variable) & isnumeric(shape) & isnumeric(scale)
            if ~isreal(variable)      | ~isreal(shape)     | ~isreal(scale)    ...
             |  isNegative(variable)  | isNegative(shape)  | isNegative(scale)    %#ok<*OR2>
                disp("<Gamma>InvalidInputDomain: ∃ ℽ(variable;α,β) ∀ {variable,α,β}∈ℝ(0,∞). ") ;
                logPDF = NaN; 
                return
            end
         end
logPDF = shape * log(scale)                 ...
       - gammaln(shape) - scale ./ variable ...
       - log(variable) * (shape + 1)          ;   % (.,scale = shape*chi) for ~{D,G}
end
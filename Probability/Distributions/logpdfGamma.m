function logPDF = logpdfGamma(variable,shape,scale)
         if isnumeric(variable) & isnumeric(shape) & isnumeric(scale)
           if   ~isreal(variable)      | ~isreal(shape)     | ~isreal(scale)   ...
            |    isZed(variable)       | isZed(shape)       | isZed(scale)     ...
            |    isNegative(variable)  | isNegative(shape)  | isNegative(scale)   %#ok<*OR2> (nonscalar).
                 disp("<Gamma>InvalidInputDomain: ∃ ℽ(r;α,β) ∀ {r,α,β}∈ℝ(0,∞).");
                 logPDF = NaN                                                   ;
           else; logPDF = log(gampdf(variable,shape,scale))                     ;
           end
           if abs(logPDF) ~= inf;    return;    end
         end
logPDF = (shape - 1) .* log(variable)         ...
       - variable/scale                       ...
       - ( shape * log(scale) + gammaln(shape) );
end
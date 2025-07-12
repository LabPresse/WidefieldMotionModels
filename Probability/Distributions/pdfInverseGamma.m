
function                                                                     ...
PDF = pdfInverseGamma(variable,shape,scale)
      if isnumeric(variable) & isnumeric(shape) & isnumeric(scale)
         if ~isreal(variable)      | ~isreal(shape)     | ~isreal(scale)     ...
          |  isNegative(variable)  | isNegative(shape)  | isNegative(scale)     %#ok<*OR2>
             disp("<Gamma>InvalidInputDomain: ∃ ℽ⁻¹(r;α,β) ∀ {r,α,β}∈ℝ(0,∞).") ;
             PDF = NaN;
             return
         end
      end
PDF = scale .^ shape ./ gamma(shape)                                         ... 
   .* (1 ./ variable) .^ (shape+1)                                           ...
   .* exp(-scale ./ variable)                                                  ; % (.,scale = shape*chi) for ~{D,G}
end
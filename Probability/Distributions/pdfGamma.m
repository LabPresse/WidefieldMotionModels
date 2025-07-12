function                                                                   ...
PDF = pdfGamma(variable,shape,scale)
      if isnumeric(variable) & isnumeric(shape) & isnumeric(scale)
         if ~isreal(variable)      | ~isreal(shape)     | ~isreal(scale)   ...
          |  isNegative(variable)  | isNegative(shape)  | isNegative(scale)   %#ok<*OR2>
             disp("<Gamma>InvalidInputDomain: ∃ ℽ(r;α,β) ∀ {r,α,β}∈ℝ(0,∞).") ;
               PDF = NaN;                                  
         else; PDF = gampdf(variable,shape,scale);    
         end
               return
      end
PDF =  (variable ./ scale) .^ (shape - 1)                                   ...
   ./ ( scale .* gamma(shape) )                                             ...
   .* exp( -variable ./ scale )                                               ; %(.,scale=psi/shape) for ~F,h
end
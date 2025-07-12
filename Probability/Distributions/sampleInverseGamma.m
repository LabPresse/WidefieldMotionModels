function                                              ...
  instantiation = sampleInverseGamma(shape,scale)    
           if isnumeric(shape,scale)
             if ~isreal(shape)     | ~isreal(scale)   ...
              | isNegative(shape)  | isNegative(scale)   %#ok<*OR2>
                 disp("<InvGamma>InvalidInputDomain: "...
                      +"∃ ℽ(r;α,β) ∀ {r,α,β}∈ℝ(0,∞).")  ;
                instantiation = NaN;               return
             end
           end
  instantiation = gaminv(shape,scale)                    ;
end

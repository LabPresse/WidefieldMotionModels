function sample = sampleGamma(shape,scale)
           if isnumeric(shape) & isnumeric(scale)
             if ~isreal(shape)      | ~isreal(scale)                          ...
              |  isNegative(shape)  | isNegative(scale)                          %#ok<*OR2>
                 disp("<Gamma>InvalidInputDomain: ∃ ℾ(α,β) ∀ {r,α,β}∈ℝ(0,∞). ") ;
                 sample = NaN;                                             return
             end
           end
  sample = scale .* gamrnd(shape, 1)                                             ;
end
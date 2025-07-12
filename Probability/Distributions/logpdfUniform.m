function logPDF = logpdfUniform(varargin)
         args = varargin;
         if nargin == 3
            variable = args{1}; 
            minimum  = args{2};
            maximum  = args{3};
         elseif nargin == 2
            variable = 1;
            minimum  = args{1};
            maximum  = args{2};
         end
         if isnumeric(minimum) && isnumeric(maximum)
           if minimum  > maximum                          ...
           || minimum == -inf                             ...
           || maximum == +inf
              disp("<Uniform>InvalidInputDomain:"         ...
                   +"∃ 𝕦[r;rₘᵢₙ,rₘₐₓ] ∀ ℝ(-∞<rₘᵢₙ<rₘₐₓ<+∞).");
                 logPDF = NaN;    return                    ;   
           else; logPDF = -log(maximum - minimum);    return; 
           end
         end
logPDF = piecewise(maximum>minimum, -log(maximum - minimum));
end
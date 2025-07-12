function                                                 ...
PDF = pdfUniform(varargin)
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
      if isnumeric(minimum) & isnumeric(maximum)
         if minimum  > maximum                          ...
         || minimum == -inf                             ...
         || maximum == +inf
            disp("<Uniform>InvalidInputDomain:"         ...
                 +"∃ 𝕦[r;rₘᵢₙ,rₘₐₓ] ∀ ℝ(-∞<rₘᵢₙ<rₘₐₓ<+∞).");
               PDF = NaN;
         else; PDF = unifpdf(variable,minimum,maximum); 
         end
         return
      end
PDF = piecewise(maximum>minimum, 1/(maximum - minimum));
end
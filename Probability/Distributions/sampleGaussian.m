function sample = sampleGaussian(mean,standardDeviation)
         if isnumeric(mean) & isnumeric(standardDeviation)
            if ~isreal(mean)                             ...
             | ~isreal(standardDeviation)                ...
             |  standardDeviation<=0                         %#ok<*OR2>
                disp("<Normal>InvalidInputDomain: "      ...
                     + "∃ ℕ(μ,σ) ∀ μ∈ℝ,σ∈ℝ(0,∞). ")       ;
                sample = NaN;                         return
             end
          end
sample = mean+sqrt(standardDeviation).*normrnd(0,1)       ;
end
function sample = sampleNormal(mean,variance)
         % drawn from fundamental theorem of simulation.
         if isnumeric(mean) & isnumeric(variance)
            if ~isreal(mean)                             ...
             | ~isreal(variance)                         ...
             |  variance<0                               %#ok<*OR2>
                 disp("<Normal>InvalidInputDomain: "     ...
                      +"∃ ℕ(μ,σ) ∀ μ∈ℝ,σ∈ℝ(0,∞).")        ;
                 return
            end
         end
sample = mean + variance .* normrnd(0,1)                   ;
end
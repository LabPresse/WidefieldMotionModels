function                                          ...
outcome = sampleBernoulli(successProbability)
          % drawn from fundamental theorem of simulation.
          if isnumeric(successProbability)
             if      successProbability<0         ...
              |      successProbability>1         ...
              | imag(successProbability)>0           %#ok<*OR2>
                disp("<Bernoulli>InvalidDomain: " ...
                     + "∃ ℙ(p) ∀ p∈ℝ[0,1]. ")       ;
                outcome = NaN;                 return
             end
          end
  if successProbability >= unifrnd(0,1)
         outcome = successProbability;
  else;  outcome = 0;
  end
end
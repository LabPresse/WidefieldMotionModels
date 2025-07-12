function Chain = Chainer(Chain0, dL, Raw, varargin);    rng("shuffle")
%% Set Default Options:
          Increment =   dL;          Stop =    50;
   chainProbability = true;     fromTRUTH = false;
   Show.Status      = true;   Show.Sample = true ;    Show.Chain = false;    Show.Probability = false;
%% Interpet Input:
  if nargin >  3
    for any =  1 : nargin - 3
        Any = varargin{any}  ;
      if     isstruct( Any)  %if getName(Any,any) == "Show" || getName(Any,any) == "show";    Show = Any;    break;    end
        if~isfield(Any,"Length")
        ALL        = string(fieldnames(Any));
          for each = 1 : length(ALL)
              Each = ALL(each)  ;
              EACH = Any.(Each) ;    Show.(Each) = EACH;
          end
        end
      elseif isnumeric(Any) && isscalar(Any) 
             if inputname(any+3) == "Stop"      || inputname(any+3) == "stop";      Stop   = Any           ;    end
%            if~exist("Increment" , var)
%            if inputname(any+3) == "Increment" || inputname(any+3) ==   "dL";      Increment = Any        ;    end
%            end
      elseif isstring( Any) || iscell(Any)      ||    ischar(Any)            ;        Iny  = inputname(any);
          if           Any  == "cheatCode"       ;                               fromTRUTH = true          ;    end
      end
    end
  end
%%            Initialize Markov Chain             :
  if dL == 0;                          Clock = tic;
    Parameters         = initialParameters(Raw)   ;
    Chain.Parameters   = Parameters               ;
    Chain.Length       = 1                        ;
    Chain.Ledger       = NaN(0, 2)                ;
    Chain.sizeGB       = NaN                      ;
    Chain.Record       = []                       ;

if fromTRUTH    
  % Parameters.T0      = 1                        ;
  % Parameters.iAnnealed = 1                      ;
    Chain.Sample       = groundSample(Parameters) ;
else
    Chain.Sample       = initialSample(Parameters);
end
    Chain.logPrior.b   = Chain.Sample.logPrior.b  ;
    Chain.logMotion    = Chain.Sample.logMotion   ;
    Chain.logPrior.D   = Chain.Sample.logPrior.D  ;
    Chain.logEmission  = Chain.Sample.logEmission ;
    Chain.logPrior.F   = Chain.Sample.logPrior.F  ; 
    Chain.logPrior.G   = Chain.Sample.logPrior.G  ;
    Chain.logPrior.h   = Chain.Sample.logPrior.h  ;
    Chain.logPosterior = Chain.Sample.logPosterior;
%% Collect Markov Chain of Monte Carlo Simulations:
    Chain.i = cast(Chain.Sample.i,      'uint64' );
    Chain.T = cast(Chain.Sample.T,      'double' );
    Chain.b = cast(Chain.Sample.b,      'logical');
    Chain.X = cast(Chain.Sample.X(:)',  'single' );
    Chain.Y = cast(Chain.Sample.Y(:)',  'single' );
    Chain.Z = cast(Chain.Sample.Z(:)',  'single' );
    Chain.D = cast(Chain.Sample.D,      'double' );
    Chain.F = cast(Chain.Sample.F,      'double' );
    Chain.h = cast(Chain.Sample.h,      'double' );
    Chain.G = cast(Chain.Sample.G,      'double' );
 if chainProbability
    Chain.logPrior.b   = cast(Chain.Sample.logPrior.b  , 'double');
    Chain.logMotion    = cast(Chain.Sample.logMotion   , 'double');
    Chain.logPrior.D   = cast(Chain.Sample.logPrior.D  , 'double');
    Chain.logEmission  = cast(Chain.Sample.logEmission , 'double');
    Chain.logPrior.F   = cast(Chain.Sample.logPrior.F  , 'double');
    Chain.logPrior.G   = cast(Chain.Sample.logPrior.G  , 'double');
    Chain.logPrior.h   = cast(Chain.Sample.logPrior.h  , 'double');
    Chain.logPosterior = cast(Chain.Sample.logPosterior, 'double');
end
%   if Show.Status;      disp(" Chain initiated in " + round(toc(Clock)*10^3,1) + "[ms].");    end

%% Prepare Monte Carlo Markov Chain Methods    :
  elseif dL;                        Clock = tic;
    Chain.Parameters = Chain0.Parameters       ;
    K = Chain.Parameters.K                     ;
    L = Chain.Parameters.M * Chain.Parameters.N;
    M = Chain.Parameters.M                     ;
    N = Chain.Parameters.N                     ;
    Chain.Length = Chain0.Length + dL          ;
    Chain.Ledger = Chain0.Ledger               ;
    Chain.sizeGB = NaN                         ;
    Chain.Record = Chain0.Record               ;
    Chain.Sample = Chain0.Sample               ;

    Chain.i = [Chain0.i; zeros(dL,     1, "like", Chain0.i)];
    Chain.T = [Chain0.T; zeros(dL,     1, "like", Chain0.T)];
    Chain.b = [Chain0.b; false(dL,     M                  )];

    Chain.X = [Chain0.X;   NaN(dL, L * K, "like", Chain0.X)];
    Chain.Y = [Chain0.Y;   NaN(dL, L * K, "like", Chain0.Y)];
    Chain.Z = [Chain0.Z;   NaN(dL, L * K, "like", Chain0.Z)];

%{
if fromTRUTH
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if size(Chain0.D,1) > 1;    Chain0.D = mean(Chain0.D,1);    end 
  % for ATTM(GT,M>1).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Chain.D = [Chain0.D;   NaN(dL,     Chain0.Sample.On.B, "like", Chain0.D)];
else
    Chain.D = [Chain0.D;   NaN(dL,     1, "like", Chain0.D)];
end
%}
    Chain.D = [Chain0.D;   NaN(dL,     1, "like", Chain0.D)];
    Chain.F = [Chain0.F;   NaN(dL,     1, "like", Chain0.F)];
    Chain.h = [Chain0.h;   NaN(dL,     1, "like", Chain0.h)];
    Chain.G = [Chain0.G;   NaN(dL,     1, "like", Chain0.G)];
%{%
if chainProbability
 %          B          = nnz(Chain0.On.B)     ; if~B;  O = N * K;  else;  O = B * N * K ;  end
 % Chain.On.B          = [Chain0.On.B         ; zeros(dL, 1, "like", Chain0.On.B      )];
 % Chain.On.b          = [Chain0.On.b         ; zeros(dL,B,"like", Chain0.On.b        )];
 % Chain.On.X          = [Chain0.On.X         ; NaN(dL, O, "like", Chain0.On.X        )];
 % Chain.On.Y          = [Chain0.On.Y         ; NaN(dL, O, "like", Chain0.On.Y        )];
 % Chain.On.Z          = [Chain0.On.Z         ; NaN(dL, O, "like", Chain0.On.Z        )];
 % Chain.On.R          = [Chain0.On.R         ; NaN(dL, O, "like", Chain0.On.R        )];
   Chain.logPrior.b    = [Chain0.logPrior.b   ; NaN(dL, 1, "like", Chain0.logPrior.b  )];
   Chain.logMotion     = [Chain0.logMotion    ; NaN(dL, 1, "like", Chain0.logMotion   )];
%{
if fromTRUTH
  if size(Chain0.D,1) > 1;    Chain0.D = mean(Chain0.D,1);    end 
  % for ATTM(GT,M>1).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Chain.logPrior.D    = [Chain0.logPrior.D   ; NaN(dL, Chain0.Sample.On.B, "like", Chain0.D)];
else
    Chain.logPrior.D    = [Chain0.logPrior.D   ; NaN(dL, 1, "like", Chain0.logPrior.D  )];
end
%}
   Chain.logPrior.D    = [Chain0.logPrior.D   ; NaN(dL, 1, "like", Chain0.logPrior.D  )];
   Chain.logEmission   = [Chain0.logEmission  ; NaN(dL, 1, "like", Chain0.logEmission )];
   Chain.logPrior.F    = [Chain0.logPrior.F   ; NaN(dL, 1, "like", Chain0.logPrior.F  )];
   Chain.logPrior.G    = [Chain0.logPrior.G   ; NaN(dL, 1, "like", Chain0.logPrior.G  )];
   Chain.logPrior.h    = [Chain0.logPrior.h   ; NaN(dL, 1, "like", Chain0.logPrior.h  )];
   Chain.logPosterior  = [Chain0.logPosterior ; NaN(dL, 1, "like", Chain0.logPosterior)];
end

% if Show.Sample
%   if         islogical(Show.Sample);    showSample(Chain);
%   else; if~mod(Chain.i,Show.Sample);    showSample(Chain);    end
%   end
% end
  if Show.Chain
                                       seenSamples = []                    ;
    if         islogical(Show.Chain);  seenSamples = showMarkovChain(Chain);
    else; if~mod(Chain.i,Show.Chain);  seenSamples = showMarkovChain(Chain);    end
    end
  end
  if Show.Probability
                                             seenProbabilities = []                                       ;
    if         islogical(Show.Probability);  seenProbabilities = showProbability(seenProbabilities, Chain);
    else; if~mod(Chain.i,Show.Probability);  seenProbabilities = showProbability(seenProbabilities, Chain);  end
    end
  end


%% Iterate Monte Carlo Markov Chain Methods
        j  = Chain0.Length + 1;
  while j <= Chain.Length
    [Chain.Sample, Chain.Parameters] = Update(Chain);
    
    [Chain.Parameters, Chain.Record, Chain.Sample.RecordedEmissionRates, Chain.Sample.RecordedPositions]...
      = adaptSampling(Chain.Parameters, Chain.Record, Chain.Sample.RecordedEmissionRates,               ...
                      Chain.Sample.RecordedPositions, Chain.Sample.i, Chain.T, Chain.i                   );
    if~mod(Chain.Sample.i, Chain.Parameters.iSkip)
      Chain.i(j)           = Chain.Sample.i          ;
      Chain.b(j,:)         = Chain.Sample.b          ;
      Chain.X(j,:)         = Chain.Sample.X(:)       ;
      Chain.Y(j,:)         = Chain.Sample.Y(:)       ;
      Chain.Z(j,:)         = Chain.Sample.Z(:)       ;
      Chain.D(j)           = Chain.Sample.D          ;
      Chain.F(j)           = Chain.Sample.F          ;
      Chain.h(j)           = Chain.Sample.h          ;
      Chain.G(j)           = Chain.Sample.G          ;
      Chain.T(j)           = Chain.Sample.T          ;
%{%   
               B           = Chain.Sample.On.B       ;
 %    Chain.On.B(j)        = B                       ;
 %    Chain.On.b(j)        = Chain.Sample.On.b       ;
% BELOW IS NOT IDEAL:    PARSED, IT SHOULD BE ~(j, 1 : N * K, 1 : B)
% MAYBE ELIMINATE j=1:J Samples, and just save the final sample.?.
  %   Chain.On.X(j, 1 : B * N * K) = Chain.Sample.On.X(:)';
  %   Chain.On.Y(j, 1 : B * N * K) = Chain.Sample.On.Y(:)';
  %   Chain.On.Z(j, 1 : B * N * K) = Chain.Sample.On.Z(:)';
  %   Chain.On.R(j, 1 : B * N * K) = Chain.Sample.On.Z(:)';
      Chain.logPrior.b  (j) = Chain.Sample.logPrior.b  ;
      Chain.logMotion   (j) = Chain.Sample.logMotion   ;
      Chain.logPrior.D  (j) = Chain.Sample.logPrior.D  ;
      Chain.logEmission (j) = Chain.Sample.logEmission ;
      Chain.logPrior.F  (j) = Chain.Sample.logPrior.F  ;
      Chain.logPrior.h  (j) = Chain.Sample.logPrior.h  ;
      Chain.logPrior.G  (j) = Chain.Sample.logPrior.G  ;
      Chain.logPosterior(j) = Chain.Sample.logPosterior;
%}     
%% Display sample drawn, Markov chain of samples, & Probabilities  :
%if Chain.i(end) ~= Chain.Length
  if islogical(Show.Sample);   if Show.Sample;    showSample(Chain);    end
  else;           if~mod(Chain.i,Show.Sample);    showSample(Chain);    end
  end
  if Show.Chain
    if         islogical(Show.Chain);  seenSamples = showMarkovChain(seenSamples, Chain);
    else; if~mod(Chain.i,Show.Chain);  seenSamples = showMarkovChain(seenSamples, Chain);  end
    end
  end
  if Show.Probability
    if         islogical(Show.Probability);    seenProbabilities = showProbability(seenProbabilities, Chain);
    else; if~mod(Chain.i,Show.Probability);    seenProbabilities = showProbability(seenProbabilities, Chain);    end
    end
  end
%end
%% Account for drawn iteration:
    j = j + 1 ;
    end
  end
%% MCMC Expansion Ledger:
   wallTime     = toc(Clock);                           Unit = "[s]."  ;
   Chain.Ledger = [Chain.Ledger; double(Chain.i(end)), wallTime];
  if  wallTime  > 60;        wallTime = wallTime/60;    Unit = "[min].";    end
  if Show.Status;    disp("Chain expanded by Δ𝒾 = " + dL + " in " + round(wallTime) + Unit);    end
  end
%}
%%  Get memory allocated to the saved file:
    Chain.sizeGB = getMemory(Chain); 
end

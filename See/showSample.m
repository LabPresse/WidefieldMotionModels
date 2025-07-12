function showSample(Chain,varargin)    %#ok<*AGROW>
%% Interpret Input:
  if nargin > 1;    Relation = varargin{1}  ;
  else         ;    Relation = "Approximate";
  end
  if Relation == "Ground"   ;    Relation = "Definition" ;    end
%% Collect values, strings, & lengths  :
   [symS,maxL] = getSymbolics(Chain,Relation);
        [S,St] = getSamples(Chain)  ;
 % Ignore non-numeric logPosterior values.
 if isnan(S.P)
    symS (end) = [];    maxL(end) = [];
       S (end) = [];      St(end) = [];
 end
        nShown = length(symS)       ;
        noShow = symS + St          ;
          L    = strlength(noShow)  ;
          L(5) = L(5) + 1           ;  % <--- Φ miscounted.
%% Calculate spacing:
   Before    = maxL - L;
 % Add space before and after displayed integers:
          I  = [1    2    length(St)-1]   ;
   Before(I) = floor((maxL(I) - L(I)) / 2);    Behind(I) = ceil( (maxL(I) - L(I)) / 2);
%{
%% Compare samples to ground truth when present:
if isfield(Chain.Parameters,"GroundTruth");    GT = Chain.Parameters.GroundTruth;    
       Truth = [NaN;  NaN;    GT.M;  GT.D;  GT.F;  GT.G;  GT.h];
 % Determine convergence for applicable variables:
   Converged = false;
     for   t = 3 : length(St) - 1
        if t ~= 4 % EXCLUSE DIFFUSIVITY
                  Error = abs((S.(getName(S).Fields(t)) - Truth(t)) / Truth(t)) * 100      ;
          if      Error < 3/2   ;     True(t) = t;    I(t) = t;    Converged = true        ;
               GTstring = symS(t) + getString(Truth(t),2);    newL(t) = strlength(GTstring);
          end
        end
     end
  % Adjust the spacing for variables that have converged.
  if Converged;    I(I == 0) = [];    I = sort(I);    
              Before(I) = floor((newL(I) - L(I)) / 2);    Behind(I) = ceil( (newL(I) - L(I)) / 2);
  end
end
%}
%% Re-apply spacing:
for       s  = 1 : nShown
  if ~ismember(s,I);    STRING(s) = symS(s) + addSpace(Before(s)) + St(s);
  else;                 STRING(s) = symS(s) + addSpace(Before(s)) + St(s) + addSpace(Behind(s));
  end
end
   String    = "";      String = join(STRING(1 : nShown),"");    disp(String)
end

%% Internal Functions:
function [S,s] =  getSamples(Chain)
% getSamples returns samples & strings from Markov Chain
          S.i  =  Chain.Sample.i                    ;
          S.T  =  Chain.Sample.T                    ;
          S.B  =  Chain.Sample.On.B                 ;
          S.D  =  Chain.Sample.D                    ;
          S.F  =  Chain.Sample.F                    ;
          S.G  =  Chain.Sample.G                    ;
          S.h  =  Chain.Sample.h                    ;
  if~isfield(Chain.Sample,"logPosterior")
          S.P  =  Chain.logPosterior(S.i)           ;
  else;   S.P  =  Chain.Sample.logPosterior         ;
  end
          s    =  [getString(S.i,   "Integer")    ...
                   getString(S.T,   "Integer")    ...
                   getString(S.B,   "Integer")    ...
                   getString(S.D,2, "Scientific") ...
                   getString(S.F,2)               ...
                   getString(S.G,2)               ...
                   getString(S.h,2)               ...
                   getString(S.P,3)                ];
end

function [symS,maxL,GT] = getSymbolics(Chain,Relation)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   if~exist("Relation",'var');    Relation = "Approximate";    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   if isfield(Chain.Parameters, "GroundTruth")
         GT = Chain.Parameters.GroundTruth    ;
          B = GT.M + 3                        ; % <--- (+3) accounts for positive bias    ;
          G = GT.G                            ;
          H = GT.h                            ;
   else; GT = "∄ Ground Truth"                ;
          B = Chain.Parameters.M              ; % <--- Nonparametric limit = 100 (default).
          G = Chain.G(1)                      ;
          H = Chain.h(1)                      ; % <--- Treated as a deterministic constant.
   end
if     Relation == "Approximate"
         symS = ["𝒾 = "       " ⁞ T = "    " ⁞ B = "    " ⁞ D ≈ "                    ...
                 " ⁞ Φ ≈ "    " ⁞ G ≈ "    " ⁞ φ ≈ "    " ⁞ logℙ ≈ "]                  ;
elseif Relation == "Definition"
         symS = ["𝒾 = "       " ⁞ T = "    " ⁞ B ≡ "    " ⁞ D ≡ "                    ...
                 " ⁞ Φ ≡ "    " ⁞ G ≡ "    " ⁞ φ ≡ "    " ⁞ logℙ ≡ "]                  ;
end
           symL = strlength(symS)                                                  ;
            Max = symS                                                           ...
                + [1000                          getString(Chain.T(1), "Integer")     ...
                   getString(B, "Integer")       getString(51 / 1000,2, "Scientific") ...
                   getString(7.3*10^(4),2)+3     getString(6*10^(2) ,2)...%getString(     G    ,2)              ...
                   getString(7.3*10^(4),2)       getString(-8.42*10^(9),3)             ];
                            % ^  H
           maxL = strlength(Max)                                                        ;
end
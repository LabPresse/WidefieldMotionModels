function sample  = sampleStandardNormal(varargin)
                   % "Standard" ⟹ (μ=0, σ=1)
    if     nargin == 0;           Size    = 1          ;
    elseif nargin == 1;           Size    = varargin{1};
    else;    for s = 1 : nargin;  Size(s) = varargin{s};  end
    end;     if floor(Size) ~= Size;  Size = size(Size);  end
  Mean     = zeros(Size)                   ;
  Variance = ones( Size)                   ;
  sample   = Mean + Variance .* randn(Size);
end
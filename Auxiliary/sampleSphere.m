function varargout = sampleSphere(K,M,v)
% Sample spherical trajectories from uniformly-distributed spherical angles:
  Azimuth = 2  * pi * rand(K, M); % φ % <--- fixed for one k ... otherwise rand(K,M)
   Zenith =      pi * rand(K, M); % ϑ = Colatitude (Zenith).
% Distances:
%  if     isnumeric(v)  &&  isscalar(v);    
X = v    .* sin(Zenith) .* cos(Azimuth);    
Y = v    .* sin(Zenith) .* sin(Azimuth);    Z = v    .* cos(Zenith);    
%  elseif isnumeric(v)  && size(v,2)==1;    X = v    .* sin(Zenith) .* cos(Azimuth);    Y = v(2) .* sin(Zenith) .* sin(Azimuth);    Z = v(3) .* cos(Zenith);
%  elseif isnumeric(v)  && ~isscalar(v);    X = v(1) .* sin(Zenith) .* cos(Azimuth);    Y = v(2) .* sin(Zenith) .* sin(Azimuth);    Z = v(3) .* cos(Zenith);
%  elseif isstruct( v);                     X = v.X  .* sin(Zenith) .* cos(Azimuth);    Y = v.Y  .* sin(Zenith) .* sin(Azimuth);    Z = v.Z  .* cos(Zenith);
%  end

if     nargout == 1;    varargout{1}.X = X;    varargout{1}.Y = Y;    varargout{1}.Z = Z;
elseif nargout == 3;    varargout{1}   = X;    varargout{2}   = Y;    varargout{3}   = Z;
end


end
function varargout = getName(In,varargin)
  if nargin>1;    iN = varargin{1};    end
  if     isstruct(In);    
        IN = struct2cell(In);
        Name   = inputname(1);
        argOut.Name    = string(Name); 
        argOut.Fields  = string(fieldnames(In));
        argOut.nFields = length(argOut.Fields);
  elseif     isscalar(In);         argOut = string(inputname(iN));
  elseif isArray(In)
      if size(In,1) == size(In,2) %% Square matrices 
         Cell = mat2cell(In,size(In)/2,size(In)/2);
         Name = inputname(Cell{1});    argOut{1} = Name;
      else; disp("!Develop<getName> for non-square matrices and tensors!")
      end
  else;    return % Other cases?
  end

  if nargout;   varargout{1} = argOut;
end
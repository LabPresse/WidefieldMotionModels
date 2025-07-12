% Save <ImageStack> as <FileName>.TIF(F); Assumes <ImageStack>'s dimensional indexing is (X,Y,Images).
function stackTIFFs(FileName, ImageStack)
        %stackTIFFs(varargin);    [FileName,ImageStack] = processInput(varargin);
          ImageStack = uint16(ImageStack)              ;
  % disp("stackTIFFs is limited to 16-bits by imwrite.") % !!! FIX: TIFF=Tiff(...);  ...;  close TIFF !!!"
  imwrite(ImageStack(:, end : -1 : 1, 1)', FileName, "Compression",'None');
      N = size(ImageStack, 3);
  for n = 2 : N;  imwrite(ImageStack(:, end : -1 : 1, n)', FileName, 'WriteMode', 'append', "Compression",'None');  end
end

%% Internal Functions
%{
function [FileName,ImageStack] = processInput(argsIn)
  for any = 1 : length(argsIn)
      Any = argsIn   (any);
    if      isstring (Any);    FileName   = string(Any);
    elseif isnumeric(Any)                   ...
        || (isfile("isArray.m") && isArray)
                               ImageStack = double(Any);
    else;   isnumeric(Any);    ImageStack = double(Any);
    end
  end
end
%}
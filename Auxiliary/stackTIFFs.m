% Save <ImageStack> as <FileName>.TIF(F); Assumes <ImageStack>'s dimensional indexing is (X,Y,Images).
function stackTIFFs(FileName, ImageStack)
          ImageStack = uint16(ImageStack)              ;
  imwrite(ImageStack(:, end : -1 : 1, 1)', FileName, "Compression",'None');
      N = size(ImageStack, 3);
  for n = 2 : N;  imwrite(ImageStack(:, end : -1 : 1, n)', FileName, 'WriteMode', 'append', "Compression",'None');  end
end
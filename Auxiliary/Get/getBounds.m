% getBounds returns the minimum and maximum elements from an array.
function Ends = getBounds(Array);    if isArray(Array);  Ends = [getMin(Array)  getMax(Array)];  end;    end
function String = addSpace(Number)
  if Number < 0 ; Number = 0;  end
    String = ""            ;
    Space  = " "           ;
  for    n = 1 : Number
    String = String + Space;
  end
end
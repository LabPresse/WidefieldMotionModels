function Type = getIntegerType(L)
    if L <= intmax(    "uint8" );    Type = "uint8" ;
    elseif L <= intmax("uint16");    Type = "uint16";
    elseif L <= intmax("uint32");    Type = "uint32";
    elseif L <= intmax("uint64");    Type = "uint64";
    else;    error("L > 2⁶⁴-1.");
    end
end
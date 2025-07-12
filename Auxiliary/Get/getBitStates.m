% Returns the number of states from a given Bit Depth (e.g., 8-Bit provides 255 states).
function States = getBitStates(Bits);    States = 2 .^ Bits - 1;    end
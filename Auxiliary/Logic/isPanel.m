function trueORfalse  = isPanel(Panel)
         trueORfalse  = false;
class(Panel) % !DELETE!
    if class(Panel) == "uipanel";  trueORfalse = true;  end
end
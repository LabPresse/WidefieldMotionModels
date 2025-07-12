function varargout = Infer(Name,varargin)
%% Set default options:
   Stop        =   Inf;      Increment = 50;
   Show.Status =  true;    Show.Sample = true;    Show.Chain = false;    Show.Probability = false;    noShow = Show;
   fromTRUTH   = false;
%% Interpret Input:
  if~nargin       ;   Name = "Free";   
  else
    for any =  1  : nargin - 1
        Any = varargin{any}  ;
      if     isstruct( Any)
        if~isfield(Any,"Length")
               ALL = string(fieldnames(Any));
          for each = 1 : length(ALL)
              Each = ALL(each)  ;
              EACH = Any.(Each) ;    Show.(Each) = EACH;
          end
        end
      elseif isnumeric(Any) && isscalar(Any)
             if inputname(any+1) == "Stop"       || inputname(any+1) == "stop";    Stop      = Any;    end
             if inputname(any+1) == "Increment"  || inputname(any+1) ==   "dL";    Increment = Any;    end
      elseif isstring( Any) || iscell(Any)       ||    ischar(Any)            
                                                     Iny  = inputname(any)   ;
        if             Any  == "showSample"      ||  Iny == "showSample"     ;      Show.Sample      = true;
        elseif         Any  == "showChain"       ||  Iny == "showChain"      ;      Show.Chain       = true;
        elseif         Any  == "showProbability" ||  Iny == "showProbability";      Show.Probability = true;
        elseif         Any  == "showAll"         ||  Iny == "showAll"        %
               Show.Status   = true;  Show.Sample = true;  Show.Chain  = true;      Show.Probability = true;
        elseif         Any  == "cheatCode"        ;                                 fromTRUTH        = true;
        end
      end
    end
  end
%% Prepare filenames for loading  & saving.
  Folder   = "Data/";
  fileType = ".mat" ;        savedFile = Folder + "Prepared(" + Name + ")" + fileType;
%% Determine if ∃ Inference File:
  savingFile = Folder  +  "Inferred("  + Name   + ")" + fileType;
  isPrepared = false   ;    Continuing = false        ;
  if isfile( savedFile);    isPrepared = true         ;       end
  if isfile(savingFile);    Continuing = true         ;       end
%% Perform Inference:
  if     Continuing ;    Chain = importdata(savingFile);    disp("Continuing Inference.")
  elseif isPrepared ;      Raw = importdata( savedFile);    disp("Beginning  Inference.");    
  else;  disp("Applicable data not found; simulating " + Name + " Brownian motion now.");    [~,Raw,Chain] = getData(Name);
  end
  %% Begin inference (if necessary):
  if~Continuing
    if~fromTRUTH;            Chain    = Chainer([],0,Raw, Stop,Show)             ;
    else;                     disp("!Warn:  Sampler starting from Ground Truth!");
                             Chain    = Chainer([],0,Raw, Stop,Show, "cheatCode");
    end;                     Chain.ID = Name;
  end
  if~exist("Stop",'var')  ||  Stop == Inf
    while true
      Chain = Chainer(Chain,Increment,[], Stop,Show);
      save(savingFile,"Chain","-v7.3");    disp("Your file, " + savingFile + ", has been saved.")
    end
  else
  %% Continue inference:
    if Chain.Length >= Stop
       disp("Markov Chain reached your specified stopping point: 𝒾 = " + Stop + ".");
       if Show.Chain;    showMarkovChain([],Chain);    end;    return;
      %load("Data/Inferred(" + Name + ")" + ".mat", 'Chain');    showMarkovChain([],Chain);    
    return
    end
    while   Chain.Sample.i  <  Stop
      if    Chain.Length + Increment  < Stop
      else;                Increment  = Stop - Chain.Length;
      end
                                Chain = Chainer(Chain,Increment,[], Show);
%%  Save Markov Chain:
  %% Create a hyperlink to the file:
   % Define the path to the folder on the desktop:
      Root = string(pwd);
      Path = Root + "/" + savingFile;   %if~ispc;  Path = strrep(Path,"\","/");  end
      save(savingFile,"Chain","-v7.3");
      if ispc;    Text(1) = "Your file has been saved.";    Text(2) = "<Open Directory>";
                 fprintf(1,'%s <a href="matlab: winopen(''%s'') ">%s</a>\n', Text(1), Path, Text(2));
      else   ;    disp("Saved: " + (Path + savingFile));
      end
    end
  %% Assign output when requested:
    if nargout;    varargout{1} = Chain;    end
  end
end
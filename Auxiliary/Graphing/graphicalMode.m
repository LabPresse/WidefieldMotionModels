function FigureHandle = graphicalMode(Argument)
% This function is based on Matlab's in-house function "colordef".

Argument = convertStringsToChars(Argument);

if nargin==1;    fig = 0;    option = Argument;
elseif nargin==2
    if ischar(Argument)
        if ~strcmpi(Argument, 'new')
            error(message('MATLAB:colordef:InvalidOption'));
        else
            colordef
            fig = figure('visible', 'off');
        end
    elseif all(isgraphics(Argument))
        if isscalar(Argument) && ~isgraphics(Argument, 'figure') && ~isgraphics(Argument, 'root')
            error(message('MATLAB:colordef:RootOrFigureHandle'));
        elseif ~isscalar(Argument) && ~all(isgraphics(Argument, 'figure'))
            error(message('MATLAB:colordef:FigureHandleExpected'));
        else
            fig = Argument;
        end
    else
        error(message('MATLAB:colordef:InvalidHandle'));
    end
end
if all(isgraphics(fig, 'figure')) && ~isempty(findobj(fig, '-regexp', 'Type', '.*axes'))
    error(message('MATLAB:colordef:MustClearFigure'));
end
  kdefault(fig)
if nargout>0, FigureHandle = fig; end
end

%----------------------------------------------------------
function kdefault(fig)
if nargin==0, fig = 0; end
whitebg(fig,[0 0 0])
gray85 = [.85 .85 .85];
fc = [.15 .15 .15];
if fig==0
  set(fig,'DefaultFigureColor',fc)
else
  set(fig,'color',fc)
end
set(fig,'DefaultAxesColor',[0 0 0])
colors =[  255   255  17;
           19    159  255;
           255   105  41;
           100   212  19;
           183   70   255;
           15    255  255;
           255   19   166 ]/255; % Scope axes colors used for black scheme
set(fig,'DefaultAxesColorOrder',colors); set(fig,'DefaultPolarAxesColor',[0,0,0]); 
set(fig,'DefaultPolarAxesColorOrder',colors);
if fig == 0;    cmap = 'DefaultFigureColormap';    else;      cmap = 'colormap';    end
set(fig,cmap,'factory');                       set(fig,'DefaultSurfaceEdgeColor',[0,0,0]); 
set(fig,'DefaultTextColor', gray85);           set(fig,'DefaultAxesXColor',gray85); 
set(fig,'DefaultAxesYColor', gray85);          set(fig,'DefaultAxesZColor',gray85); 
set(fig,'DefaultAxesGridAlpha',0.35);          set(fig,'DefaultAxesGridColor',gray85);        
set(fig,'DefaultAxesMinorGridAlpha',0.5);      set(fig,'DefaultAxesMinorGridColor',gray85);  
set(fig,'DefaultPolarAxesRColor',gray85);      set(fig,'DefaultPolarAxesThetaColor',gray85); 
set(fig,'DefaultPolarAxesGridAlpha',0.35);     set(fig,'DefaultPolarAxesGridColor',gray85);      
set(fig,'DefaultPolarAxesMinorGridAlpha',0.5); set(fig,'DefaultPolarAxesMinorGridColor',gray85); 


end

%------------------------------------------------------------
function wdefault(fig)
    
  if nargin==0, fig = 0; end
    
  whitebg(fig,[1 1 1])
  if fig==0;  set(fig,'DefaultFigureColor','factory');  else;  set(fig,'color', 'factory');  end
     set(fig,'DefaultAxesColor','factory');    set(fig,'DefaultAxesColorOrder','factory');
     set(fig,'DefaultPolarAxesColor','factory');    set(fig,'DefaultPolarAxesColorOrder','factory');
   if fig == 0 
      cmap = 'DefaultFigureColormap';
   else
      cmap = 'colormap';
   end
   set(fig,cmap,'factory');                             set(fig,'DefaultSurfaceEdgeColor','factory');
   set(fig,'DefaultTextColor','factory');               set(fig,'DefaultAxesXColor','factory');
   set(fig,'DefaultAxesYColor','factory');              set(fig,'DefaultAxesZColor','factory');
   set(fig,'DefaultAxesGridColor','factory');           set(fig,'DefaultAxesGridAlpha','factory');
   set(fig,'DefaultAxesMinorGridColor','factory');      set(fig,'DefaultAxesMinorGridAlpha','factory');  
   set(fig,'DefaultPolarAxesThetaColor','factory');     set(fig,'DefaultPolarAxesRColor','factory');
   set(fig,'DefaultPolarAxesGridColor','factory');      set(fig,'DefaultPolarAxesGridAlpha','factory');  
   set(fig,'DefaultPolarAxesMinorGridColor','factory'); set(fig,'DefaultPolarAxesMinorGridAlpha','factory')
end

%%
function whitebg(fig,c)  
    if nargin > 0
        fig = convertStringsToChars(fig);
    end
    
    if nargin > 1
        c = convertStringsToChars(c);
    end
    
    rgbspec = [1 0 0;0 1 0;0 0 1;1 1 1;0 1 1;1 0 1;1 1 0;0 0 0];
    cspec = 'rgbwcmyk';
    def = ['wk' % Default text colors
        'wk' % Default axesxcolors and xlabel colors
        'wk' % Default axesycolors and ylabel colors
        'wk' % Default axeszcolors and zlabel colors
        'wk' % Default patch face color
        'kk' % Default patch and surface edge color
        'wk' % Default line colors
        ];
    
    if nargin==0
        fig = [gcf 0];
        if ischar(get(fig(1),'DefaultAxesColor'))
            c = 1 - get(fig(1),'color');
        else
            c = 1 - get(fig(1),'DefaultAxesColor');
        end
        
    elseif nargin==1
        if isequal(size(fig),[1 3]) && max(double(fig(:)))<=1
            c = fig; fig = [gcf 0];
        elseif ischar(fig)
            c = fig; fig = [gcf 0];
        else
            c = zeros(length(fig),3);
            for i=1:length(fig)
                if ischar(get(fig(i),'DefaultAxesColor'))
                    if fig(i)==0
                        c(i,:) = 1 - get(fig(i),'DefaultFigureColor');
                    else
                        c(i,:) = 1 - get(fig(i),'Color');
                    end
                else
                    c(i,:) = 1 - get(fig(i),'DefaultAxesColor');
                end
            end
        end
    end
    
    if length(fig)~=size(c,1) && ~ischar(c)
        c = c(ones(length(fig),1),:);
    end
    
    % Deal with string color specifications.
    if ischar(c)
        k = find(cspec==c(1));
        if isempty(k)
            error(message('MATLAB:whitebg:InvalidColorString'));
        end
        if k~=3 || length(c)==1
            c = rgbspec(k,:);
        elseif length(c)>2
            if strcmpi(c(1:3),'bla')
                c = [0 0 0];
            elseif strcmpi(c(1:3),'blu')
                c = [0 0 1];
            else
                error(message('MATLAB:whitebg:UnknownColorString'));
            end
        end
        c = c(ones(length(fig),1),:);
    end
    
    n = size(c,1);
    coef1 = .298936021;
    coef2 = .58704307445;
    coef3 = .114020904255;
    for k=1:n   % Change all the requested figures
        mode = ((coef1.*c(k,1)+ coef2.*c(k,2)+coef3.*c(k,3)) >= .5) + 1; % mode = 1 for black, mode = 2 for white.
        set(fig(k),'DefaultTextColor',def(1,mode))
        set(fig(k),'DefaultAxesXColor',def(2,mode))
        set(fig(k),'DefaultAxesYColor',def(3,mode))
        set(fig(k),'DefaultAxesZColor',def(4,mode))
        set(fig(k),'DefaultAxesGridColor',def(4,mode))
        set(fig(k),'DefaultAxesMinorGridColor',def(4,mode))
        set(fig(k),'DefaultAxesGridAlpha', 'factory')
        set(fig(k),'DefaultAxesMinorGridAlpha', 'factory')
        set(fig(k),'DefaultPatchFaceColor',def(5,mode))
        set(fig(k),'DefaultPatchEdgeColor',def(6,mode))
        set(fig(k),'DefaultSurfaceEdgeColor',def(6,mode))
        set(fig(k),'DefaultLineColor',def(7,mode))
        if (get(0,'ScreenDepth') == 1)
            
            if mode==1
                co = [1 1 1]; 
            else 
                co = [0 0 0]; 
            end
            
        else
            co = get(fig(k),'DefaultAxesColorOrder');
        end
        % Possibly complement the figure color if axis color isn't 'none'
        if ~ischar(get(fig(k),'DefaultAxesColor'))
            fc = get(fig(k),'DefaultAxesColor');
            clum = ((coef1.*fc(1)+coef2.*fc(2)+coef3.*fc(3)) >= .5) + 1; 
            if fig(k)==0
                set(fig(k),'DefaultFigureColor',brighten(0.2*(mode==1)+0.8*c(k,:),.3))
            else
                set(fig(k),'Color',brighten(.2*(mode==1)+0.8*c(k,:),.3))
            end
            set(fig(k),'DefaultAxesColor',c(k,:))
            if (clum==1 && mode==2) || (clum==2 && mode==1)
                set(fig(k),'DefaultAxesColorOrder',1-co)
            end
        else
            if fig(k)==0
                set(fig(k),'DefaultFigureColor',c(k,:))
            else
                fc = get(fig(k),'Color');
                set(fig(k),'Color',c(k,:))
            end
        end
        
        % Blindly turn InvertHardcopy on
        if fig(k)==0
            set(fig(k),'DefaultFigureInvertHardcopy','on');
        else
            set(fig(k),'inverthardcopy','on');
        end
        
        if fig(k)~=0
            otherObjs = [];
            
            % Now set the properties of the figure and axes in the current
            % figure.
            h = get(fig(k),'children');
            for i=1:length(h)
                if any(strcmp(get(h(i),'Type'), {'axes','legend','colorbar'}))

                    % Verify these properties exist for the axes before
                    % trying to access them.
                    if isprop(h(i), 'Color') && ...
                            isprop(h(i), 'ColorOrder') && ...
                            isprop(h(i), 'XLabel') && ...
                            isprop(h(i), 'YLabel') && ...
                            isprop(h(i), 'ZLabel') && ...
                            isprop(h(i), 'Title')
                        
                        % Complement the figure and their contents if
                        % necessary
                        if isprop(h(i), 'Color') && ~ischar(get(h(i),'Color'))
                            ac = get(h(i),'Color');
                        else
                            ac = fc;
                        end
                        clum = ((coef1.*ac(1)+coef2.*ac(2)+coef3.*ac(3)) >= .5) + 1; 
                        if (clum==1 && mode==2) || (clum==2 && mode==1)
                            complement = 1;
                        else
                            complement = 0;
                        end
                        
                        if complement
                            co = get(h(i),'colororder');
                            set(h(i),'colororder',1-co);
                        end
                        hh = [get(h(i),'Title')
                            get(h(i),'xlabel')
                            get(h(i),'ylabel')
                            get(h(i),'zlabel')
                            get(h(i),'children')];
                        modifyObjectColor(hh)
                        
                        % Set the color of the axes if necessary
                        set(h(i),'xcolor',def(2,mode))
                        set(h(i),'ycolor',def(3,mode))
                        set(h(i),'zcolor',def(4,mode))
                        if ~ischar(get(h(i),'color')) || ~ischar(get(fig(k),'DefaultAxesColor'))
                            set(h(i),'color',c(k,:))
                        end
                    else
                        % Save other objects (legends or color bars)
                        % to process after axes
                        otherObjs(length(otherObjs)+1) = h(i); %#ok<AGROW>
                    end
                end
            end
            
            if ~isempty(otherObjs)
                % Handle other objects (legends or color bars)
                for j=1:length(otherObjs)
                    obj = otherObjs(j);
                    
                    if strcmp(get(obj,'Type'), 'colorbar')
                        setColorIfProp(obj, 'Color')
                    elseif strcmp(get(obj,'Type'), 'legend')
                        setColorIfProp(obj, 'Color')
                        setColorIfProp(obj, 'EdgeColor')
                        setColorIfProp(obj, 'TextColor')
                    end
                end
            end
        end
    end
    
    %-----------------------------------------------------------
    function setColorIfProp(obj, prop)
        if isprop(obj, prop) && ~ischar(get(obj, prop))
            setNewColor(obj, prop)
        end
    end
    
    %-----------------------------------------------------------
    function modifyObjectColor(objArray)
        for idx=1:length(objArray)
            obj = objArray(idx);
            
            % Modifies the appropriate color properties, depending on the type
            % of object obj is.  For example, the 'Color' properties for text
            % objects, or the 'FaceColor' for surface plots.
            tt = get(obj,'Type');
            if  strcmp(tt,'text') || strcmp(tt,'line')
                setNewColor(obj, 'Color')
            elseif strcmp(tt,'surface')
                if ~ischar(get(obj,'FaceColor'))
                    setNewColor(obj, 'FaceColor');
                    
                    if ~ischar(get(obj,'EdgeColor'))
                        setNewColor(obj, 'EdgeColor');
                    end
                elseif strcmp(get(obj,'FaceColor'),'none')
                    if ~ischar(get(obj,'EdgeColor'))
                        setNewColor(obj, 'EdgeColor')
                    end
                end
            elseif strcmp(tt,'patch')
                if ~ischar(get(obj,'EdgeColor'))
                    setNewColor(obj, 'EdgeColor')
                end
                if ~ischar(get(obj,'FaceColor'))
                    setNewColor(obj, 'FaceColor')
                end
            end
        end
    end
    
    % --------------------------------------------------------------------
    function setNewColor(obj, property)
        % Sets the new color, specified by property, for the given object
        % obj.
        % Ensures that objects using updated ColorOrder aren't inverted again. 
        if isa(obj, 'matlab.graphics.mixin.ColorOrderUser')
            participateColorOrder = isequal(obj.SeriesIndex, 0) || isequal(obj.SeriesIndex, 'none');
        else
            participateColorOrder = true; 
        end
        
        if isequal(get(obj, property),ac)
            set(obj, property, c(k,:))
        elseif complement && participateColorOrder
            set(obj, property, 1-get(obj, property))
        end
    end
end

% LocalWords:  rgbwcmyk axesxcolors axesycolors axeszcolors XColor YColor kk
% LocalWords:  ZColor colororder xcolor ycolor zcolor bla blu inverthardcopy

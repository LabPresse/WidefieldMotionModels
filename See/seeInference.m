function                                  ...
     varargout = seeInference(Chain,varargin)
    Parameters = Chain.Parameters ;
        Bounds = Parameters.Bounds;
        Time   = Parameters.Time  ;
shortHand
      fontSize = 12;    FontSize = fontSize + 1;    FontSIZE = FontSize + 1;    FONTSIZE = FontSIZE + 2;
     if nargin > 1
       for any = 1 : nargin - 1
           Any = varargin{any} ;
         if      isstring(Any) ;    ID = Any;  
         elseif  iscell(  Any) && length(Any) > 1
           for      each = 1 : length(Any)
                    Each = Any(each)    ;           All  =   cell2struct(Each,"Each");
             if     isstring(All.Each)  ;                               ID = All.Each;
             elseif isnumeric(All.Each) && isscalar(All.Each);    Exponent = All.Each;
             end
           end
         end
       end
     end
%‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾|‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾|
%    Shorthand Variables    |————————————————————————————|
%___________________________|____________________________|
       I = length(Chain.i)  ;       i = 1 : I            ;
       b = Chain.b          ;       M = Parameters.M     ;
       N = Parameters.N     ;       K = Parameters.K     ;
      Px = Bounds.Px        ;      Py = Bounds.Py        ;
   tCoeff = Parameters.tCoeff ;  tIndex = Time.Index       ;
      xB = Bounds.X         ;      yB = Bounds.Y         ;
      Bx = xB(end)          ;      By = yB(end)          ;
     PSF = Parameters.PSF   ;                            %
%‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾|‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾|
%       Initialization       |———————————————————————————|
%____________________________|___________________________|
if size(Chain.X,2) > 100
% for  i = 1 : Chain.Length                   %
              i = I                           ;
              X = reshape(Chain.X(i,:), [], M);    X = X(:,b(i,:));     %#ok<*PFBNS>
              Y = reshape(Chain.Y(i,:), [], M);    Y = Y(:,b(i,:));
              Z = reshape(Chain.Z(i,:), [], M);    Z = Z(:,b(i,:));
              D = Chain.D(i)                  ;
              F = Chain.F(i)                  ;
              h = Chain.h(i)                  ;
              G = Chain.G(i)                  ;
         pixPSF = zeros(Px, Py, N)            ;
    for       n = 1 : N                                                                    %|
      for     m = 1 : size(X, 2)                                                           %|
        for   k = 1 : K                                                                    %|
            tIn = tIndex(n,k)                                                               ;
               pixPSF(:,:,n) = pixPSF(:,:,n)                                              ...
                             + tCoeff(k)                                                   ...
                             * integratePSF( X(tIn, m), Y(tIn, m), Z(tIn, m),                  ...
                                 xB, yB, PSF)                                       ;
                  R.X(n,m)   = X(tIndex(n,k),m);
                  R.Y(n,m)   = Y(tIndex(n,k),m);
                  R.Z(n,m)   = Z(tIndex(n,k),m);
        end                                                                                %|
      end                                                                                  %|
    end                                                                                    %|
    W = w / f / G; % informed measurements account for EMCCD Gain & ExcessNoiseFactor=2.
    U = tE/f * (F*PA + h*pixPSF); % mean photon count. 
% end
end



     X0 = X(1,:);    Xend = X(end,:);    Xmin = min(X,[],"All");    Xmax = max(X,[],"All");
     Y0 = Y(1,:);    Yend = Y(end,:);    Ymin = min(Y,[],"All");    Ymax = max(Y,[],"All");
     Z0 = Z(1,:);    Zend = Z(end,:);    Zmin = min(Z,[],"All");    Zmax = max(Z,[],"All");

    Xmid = Xmin  + (Xmax - Xmin)/2;      Ymid = Ymin +  (Ymax - Ymin)/2;      Zmid = Zmin + (Zmax - Zmin)/2;
  deltaX = Xmax  -  Xmin          ;    deltaY = Ymax -   Ymin          ;    deltaZ = Zmax -  Zmin          ;
      Bz = 3     ;                         dB = 1/5  ;

      if     size(X,1) <  500;   lineWidth = 2.25;
      elseif size(X,1) < 5000;   lineWidth = 2   ;
      else;                      lineWidth = 1   ;
      end

  cStart = [0.467  0.675  0.188] ;     cStop = [1  0  0];         
  cGoing = [0.929  0.694  0.125  ;  0.851  0.325  0.098 ; ...
            0.635  0.078  0.184  ;  0.467  0.675  0.188 ; ...
              0    0.447  0.741  ;  0.494  0.184  0.557]; 

  Figure = figure;                 Activate Night;  set(Figure, "Visible",'on', "WindowState",'maximized');
% Tiles  = tiledlayout(3,3, "TileSpacing","loose", "Parent",Figure);
  Tiles  = tiledlayout(2,6, "TileSpacing","loose", "Parent",Figure);
  Rtile  = nexttile([1  3]);        hold(Rtile, "on");    grid(Rtile, "minor")
           daspect(Rtile,              [1    1    1]);

  clear   each
  for     each  =  1 : size(X,2);    cGOING = cGoing(each,:);
     GO(1,each) =  plot3(  Rtile,  X(:,each),Y(:,each),Z(:,each), "Color",cGOING, "LineWidth",lineWidth);
  end
           plot3( Rtile, 0 : dB : Bx, By, 0,  'w.:');    plot3(Rtile, 0 : dB : Bx,   0,  0, 'w.:');
           plot3( Rtile, Bx, 0 : dB : By, 0,  'w.:');    plot3(Rtile, 0 ,  0 : dB : By,  0, 'w.:');

        if abs(Zmax) > Bz / (3/2)
          plot3(  Rtile, 0 : dB : Bx, By, Bz, 'w.:');    plot3(Rtile, 0 : dB : Bx,   0, Bz, 'w.:');
          plot3(  Rtile, Bx, 0 : dB : By, Bz, 'w.:');    plot3(Rtile, 0 ,  0 : dB : By, Bz, 'w.:');
        end
        xLim       = get(Rtile,"XLim");    xLim(1) = 0;
        yLim       = get(Rtile,"YLim");
        START(1,:) = scatter3(  Rtile,  X0 ,  Y0 ,  Z0 , "filled", "MarkerFaceColor",cStart, "MarkerEdgeColor",cStart, "SizeData",150);
        STOP( 1,:) = scatter3(  Rtile, Xend, Yend, Zend, "filled", "MarkerFaceColor",cStop , "MarkerEdgeColor",cStop , "SizeData",150);
                     hold(  Rtile, "off");    view(3);    grid(Rtile, "minor");
                     Azimuth = -45;    Zenith = 15;
                     view(  Rtile, Azimuth,Zenith);  Rtile.XDir = "normal";   Rtile.YDir = "normal";
                     xLabel = xlabel(  Rtile, "$x \ [\mu m]$", "Interpreter",'LaTeX', "FontSize",fontSize, "Rotation",-Azimuth/2);
                     yLabel = ylabel(  Rtile, "$y \ [\mu m]$", "Interpreter",'LaTeX', "FontSize",fontSize, "Rotation",Azimuth/2);
                     zlabel(  Rtile, "$z \ [\mu m]$", "Interpreter",'LaTeX', "FontSize",fontSize);

                     xLabel.Position(1) = Xmid + deltaX / 15;    xLabel.Position(2) = xLabel.Position(2) - deltaY / 20;
                     xLabel.Position(3) = xLabel.Position(3) - deltaZ / 20;

                     yLabel.Position(2) = Ymid;    yLabel.Position(1) = yLabel.Position(1) - deltaX / 20;
                     yLabel.Position(3) = yLabel.Position(3) - deltaZ / 20;

      zRtile  =  nexttile([1,3]);    hold(zRtile, "on");    grid(zRtile, "minor");
  for   each  =  1 : size(X,2);    cGOING = cGoing(each,:);
     GO(each) =  plot3(zRtile, X(:,each),Y(:,each),Z(:,each), "Color",cGOING, "LineWidth",lineWidth);
  end
      xLim    = get(zRtile,"XLim");    xLim(1) = 0;        daspect(zRtile, [1  1  1]);
      START(2,:) = scatter3(zRtile, X0,Y0,Z0,      "filled", "MarkerFaceColor",cStart, "MarkerEdgeColor",cStart, "SizeData",150);
      STOP( 2,:) = scatter3(zRtile, Xend,Yend,Zend,"filled", "MarkerFaceColor",cStop , "MarkerEdgeColor",cStop , "SizeData",150);
      title(   zRtile,"Zenith View","Interpreter",'LaTeX', "FontSize",13);
      plot3(   zRtile,0 : dB : Bx, By, Bz, 'w.:');    plot3(zRtile, 0 : dB : Bx, 0, Bz, 'w.:');
      plot3(   zRtile,0, 0 : dB : By,   0, 'w.:');    plot3(zRtile, Bx, 0 : dB : By, Bz, 'w.:');
      plot3(   zRtile,0, By, 0 : dB :   0, 'w.:');    plot3(zRtile, Bx, By, 0 : dB : Bz, 'w.:');
      xlabel(  zRtile, "$x \ [\mu m]$", "Interpreter",'LaTeX', "FontSize",fontSize);
      ylabel(  zRtile, "$y \ [\mu m]$", "Interpreter",'LaTeX', "FontSize",fontSize);
      zlabel(  zRtile, "$z \ [\mu m]$", "Interpreter",'LaTeX', "FontSize",fontSize);
      zRtile.XDir = "normal";    zRtile.YDir = "normal";

           hold(zRtile, "off");    view([0, 90]);    grid(Rtile, "minor");

  Utile    = nexttile([1,2]);    
  meanTile = nexttile([1,2]);    
  Wtile    = nexttile([1,2]);

        N = size(w, 3);    Progress = "";
  for n   = 1 : N
      imshow(U(:,:,n)',[],"Parent",Utile);        
      titleU = title(Utile,"Expected Count", "FontName",'Times', "Color",'w', "FontSize",13, "FontWeight",'normal');
      xlabel(Utile, "$x \ [\mu m]$", "Interpreter",'LaTeX', "Color",'w', "FontSize",12);    
      ylabel(Utile, "$y \ [\mu m]$", "Interpreter",'LaTeX', "Color",'w', "FontSize",12);
      Utile.YDir = "normal";    Utile.XDir = "normal";

%%%%% 〈R〉
      Fluorescence = [0.941 0.941 0.941];
      grid(meanTile, "minor");
      scatter3(meanTile, R.X(n,:),R.Y(n,:),R.Z(n,:), "MarkerFaceColor",Fluorescence, "MarkerFaceAlpha",1,  ...
                                               "MarkerEdgeColor",Fluorescence, "MarkerEdgeAlpha",1/2, "LineWidth",15);
      view(meanTile, 0,90);    xlim(meanTile, [0    Bx]);    ylim(meanTile, [0    By]);
                       % zlim(zeniAxes, zLim);
%%%%%

      showW      = imshow(w(:,:,n)',[],"Parent",Wtile);
      titleW     = title(Wtile,"Measured Count", "FontName",'Times', "Color",'w', "FontSize",13, "FontWeight",'normal');
      xlabel(Wtile, "$x \ [\mu m]$", "Interpreter",'LaTeX', "Color",'w', "FontSize",12);
      ylabel(Wtile, "$y \ [\mu m]$", "Interpreter",'LaTeX', "Color",'w', "FontSize",12);
      Wtile.YDir = "normal";    Wtile.XDir = "normal";

  Progress   = Progress + "●";    
  Remaining = N - n;
  if n == N;    Empty = "";
  else;         Empty(1 : Remaining) = " ";    Empty = join(Empty,"");    
  end

  title(meanTile, "Expected Diffusive Trajectory", "Interpreter",'LaTeX', "FontSize",FontSize)
  xlabel(meanTile, "[" + Progress + Empty + "]","FontName",'Consolas', "FontSize",FontSize)


  drawnow;     
  end

%% Assign output if requested:
   if nargout;    varargout{1} = Tiles;    end
end
function State = simulatePhotostates(In)
  K = In.K;    M = In.M;    dt = In.Time.Increment;    t = In.Time.Levels;
if ~isfield(In,"p2");    In.p2 = 1  ;    end;         p2 = In.p2    ;
                 % ^^ <---- IS THIS Photostate(2) ???
                    % the probability of emitters being in State 2 ???
if ~isfield(In.Time,"tStart");    In.tStart = inf;    end;    tStart = In.tStart;
if ~isfield(In.Time,"tEnd"  );    In.tEnd   = inf;    end;    tEnd   = In.tEnd  ;

    % State(1) = pre-photo-activated ( dark )
    % State(2) =     photo-activated (bright)
    % State(3) =     photo-bleached  ( dark )
%{
    if nargin      <  1
        units.time = 's';
        N          = 100    ; % total number of frames
        dt_stp     = 33/1000; % [time] time per frame
        M          = 10     ; % total number of emitters
        % Photo-physics
        p2 = 0.2;
        tStart = 1.0; % [time]
        tEnd = 0.2; % [time]
        nFig = 1;
        K = 1000 * N;
        dt = N / K * dt_stp;
        t = dt * (1/2 : K)';
    end
%}

    %%
  Qj = [-1/tStart  +1/tStart       0   ;
            0       -1/tEnd     +1/tEnd;
            0          0           0   ];

    Pj = expm(Qj * dt)    ;
    P0 = [1-p2    p2    0];

%% Simulate Photophysics:
   State   = 3 * ones(K, M);
   for   m = 1 : M;  State(1, m) = sample(P0);
     for k = 2 : K;  State(k, m) = sample(Pj(State(k - 1, m), :));  if State(k, m) == 3;  break;  end;  end
   end
%  if nargout < 1;    clear State;    end
end


function j = sample(p)

    % P = cumsum(p);
    % j = find( P(end)*rand(1) <= P, 1 );

    [p, ind] = sort(p, 'descend');
    P = cumsum(p);
    j = ind(find(P(end) * rand(1) <= P, 1));

    % % if P(end)==0 || isnan(P(end))
    % %     p'
    % %     keyboard
    % % end
end
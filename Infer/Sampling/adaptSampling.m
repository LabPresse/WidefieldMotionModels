function   [Parameters, Record, EmissionRecord, PositionRecord] ...
         = adaptSampling(Parameters, Record, EmissionRecord, PositionRecord, i, ChainT, iChain)

% Shorthand Variables
  MH     = Parameters.MH_sc;

  indexT = find(ChainT <= 2 & ChainT ~=0, 1);
  if isempty(indexT);    return;     else;    iT = iChain(indexT);    end

  TargetFH = [50 50 35] / 100; % Target acceptance for emission rates.
  TargetR  = [25    25] / 100; % Target acceptance for active locations.
  rep = 25;

  if isempty(Record);    Record =          [EmissionRecord, PositionRecord];
  else;                  Record = Record + [EmissionRecord, PositionRecord];
  end

  if i - iT <= rep * 20
    if mod(i, rep) == 0;    disp("Adapting samples.")

        batchFH = EmissionRecord(1, 1 : 2) ./ EmissionRecord(2, 1 : 2); % Acceptance
        MH(1) = MH(1) / min(max(batchFH(1)  / TargetFH(1), 0.1), 10)  ;
        MH(2) = MH(2) / min(max(batchFH(2)  / TargetFH(2), 0.1), 10)  ;

        batchR = PositionRecord(1, 1 : 2) ./ PositionRecord(2, 1 : 2);  % Acceptance
        MH(4)  = MH(4) * min(max(batchR(1) / TargetR(1), 0.1), 10)   ;
        MH(5)  = MH(5) * min(max(batchR(2) / TargetR(2), 0.1), 10)   ;

        EmissionRecord(:) = 0 ;    PositionRecord(:) = 0;
        Parameters.MH_sc  = MH;
    end
  end
end
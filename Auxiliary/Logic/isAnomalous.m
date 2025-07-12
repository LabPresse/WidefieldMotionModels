function Anomalous = isAnomalous(ID) % Logical
% Could be simplified by calling ismember(ID, Anomalies)
         Anomalous = false     ;              setModels   ;
  for l = 1 : length(Anomalies);    Anomaly = Anomalies(l);    if ID == Anomalies(l);  Anomalous = true;  end;    end
end

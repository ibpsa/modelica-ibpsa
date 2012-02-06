within IDEAS.Buildings.Validation.BaseClasses.Occupant;
model None "None"
  extends IDEAS.Interfaces.Occupant;

algorithm
for i in 1:nZones loop
  heatPortCon[i].Q_flow := 0;
  heatPortRad[i].Q_flow := 0;
  TSet[i] := 273.15;
end for;

end None;

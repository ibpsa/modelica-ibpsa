within IDEAS.Buildings.Validation.BaseClasses.Occupant;
model None "None"
  extends IDEAS.Interfaces.BaseClasses.Occupant(final nLoads=1);

equation
  P[1] = 0;
  Q[1] = 0;
  for i in 1:nZones loop
    heatPortCon[i].Q_flow = 0;
    heatPortRad[i].Q_flow = 0;
    TSet[i] = 273.15;
  end for;
  mDHW60C = 0;

  annotation (Diagram(graphics));
end None;

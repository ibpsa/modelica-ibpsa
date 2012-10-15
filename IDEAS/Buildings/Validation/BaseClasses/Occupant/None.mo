within IDEAS.Buildings.Validation.BaseClasses.Occupant;
model None "None"
  extends IDEAS.Interfaces.Occupant(nLoads=1);

equation
wattsLawPlug[1].P = 0;
wattsLawPlug[1].Q = 0;
for i in 1:nZones loop
  heatPortCon[i].Q_flow =  0;
  heatPortRad[i].Q_flow =  0;
  TSet[i] =  273.15;
end for;
  annotation (Diagram(graphics));
mDHW60C = 0;

end None;

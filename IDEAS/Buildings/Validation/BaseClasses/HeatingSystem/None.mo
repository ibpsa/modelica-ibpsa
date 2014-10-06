within IDEAS.Buildings.Validation.BaseClasses.HeatingSystem;
model None "None"
  extends IDEAS.Interfaces.BaseClasses.HeatingSystem(
    final nLoads=1, nZones=1);

equation
  wattsLawPlug.P = {0};
  wattsLawPlug.Q = {0};

  for i in 1:nZones loop
    heatPortCon[i].Q_flow = 0;
    heatPortRad[i].Q_flow = 0;
    heatPortEmb[i].Q_flow = 0;
  end for;

  QHeaSys = 0;

end None;

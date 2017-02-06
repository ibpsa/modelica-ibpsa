within IDEAS.Buildings.Validation.BaseClasses.HeatingSystem;
model None "None"
  extends IDEAS.Templates.Interfaces.BaseClasses.HeatingSystem(
    final nLoads=1, nZones=1, final nTemSen = nZones);

equation
  P = {0};
  Q = {0};

  for i in 1:nZones loop
    heatPortCon[i].Q_flow = 0;
    heatPortRad[i].Q_flow = 0;
//    heatPortEmb[i].Q_flow = 0;
  end for;

  QHeaSys = 0;

end None;

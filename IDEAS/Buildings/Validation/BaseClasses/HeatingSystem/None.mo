within IDEAS.Buildings.Validation.BaseClasses.HeatingSystem;
model None "None"
  extends IDEAS.Interfaces.BaseClasses.HeatingSystem(
    radiators=true,
    floorHeating=true,
    final nLoads=1,
    QNom=zeros(nZones));

equation
  wattsLawPlug.P = {0};
  wattsLawPlug.Q = {0};
  for i in 1:nZones loop
    heatPortCon[i].Q_flow = 0;
    heatPortRad[i].Q_flow = 0;
    heatPortEmb[i].Q_flow = 0;
  end for;

  QHeatTotal = 0;

end None;

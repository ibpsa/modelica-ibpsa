within IDEAS.Occupants.Extern;
model MultiZone "External file occupant, for multi zone building models"

  extends IDEAS.Interfaces.BaseClasses.Occupant(nLoads=1);

  parameter Real[nZones] VZones "Zone volumes";
  parameter Modelica.SIunits.Temperature TSetOcc=293.15;
  parameter Modelica.SIunits.Temperature TSetNoOcc=289.15;

  outer SimInfoManager sim
    annotation (Placement(transformation(extent={{-98,78},{-78,98}})));
equation

  -heatPortRad.Q_flow = ones(nZones) .* VZones/sum(VZones)*sim.tabQRad.y[id];
  -heatPortCon.Q_flow = ones(nZones) .* VZones/sum(VZones)*sim.tabQCon.y[id];
  P = {sim.tabP.y[id]};
  Q = {sim.tabQ.y[id]};
  mDHW60C = sim.tabDHW.y[id];
  TSet = noEvent(if sim.tabPre.y[id] > 0.5 then ones(nZones)*TSetOcc else ones(
    nZones)*TSetNoOcc);

  annotation (Diagram(graphics));
end MultiZone;

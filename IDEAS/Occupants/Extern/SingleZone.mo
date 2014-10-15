within IDEAS.Occupants.Extern;
model SingleZone "Occupant model based on external files for a single zone"

  extends IDEAS.Interfaces.BaseClasses.Occupant(nZones=1, nLoads=1);
  parameter Modelica.SIunits.Temperature TSetOcc=293.15;
  parameter Modelica.SIunits.Temperature TSetNoOcc=289.15;

  outer SimInfoManager sim
    annotation (Placement(transformation(extent={{-98,78},{-78,98}})));
equation

  -heatPortRad[1].Q_flow = sim.tabQRad.y[id];
  -heatPortCon[1].Q_flow = sim.tabQCon.y[id];
  P = {sim.tabP.y[id]};
  Q = {sim.tabQ.y[id]};
  mDHW60C = sim.tabDHW.y[id];
  TSet[1] = noEvent(if sim.tabPre.y[id] > 0.5 then TSetOcc else TSetNoOcc);

  annotation (Diagram(graphics));
end SingleZone;

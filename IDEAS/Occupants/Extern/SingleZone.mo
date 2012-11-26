within IDEAS.Occupants.Extern;
model SingleZone "Occupant model based on external files for a single zone"

  extends IDEAS.Interfaces.Occupant(nZones=1, nLoads=1);
  parameter Integer occ=1
    "Which user from the read profiles in the SimInfoManager";
  parameter Modelica.SIunits.Temperature TSetOcc = 293.15;
  parameter Modelica.SIunits.Temperature TSetNoOcc = 289.15;

  outer SimInfoManager sim
    annotation (Placement(transformation(extent={{-98,78},{-78,98}})));
equation

-heatPortRad[1].Q_flow = sim.tabQRad.y[occ];
-heatPortCon[1].Q_flow = sim.tabQCon.y[occ];
wattsLawPlug.P[1] = sim.tabP.y[occ];
wattsLawPlug.Q[1] = sim.tabQ.y[occ];
mDHW60C = sim.tabDHW.y[occ];
TSet[1] = noEvent(if sim.tabPre.y[occ] > 0.5 then TSetOcc else TSetNoOcc);

  annotation (Diagram(graphics));
end SingleZone;

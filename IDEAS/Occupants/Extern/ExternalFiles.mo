within IDEAS.Occupants.Extern;
model ExternalFiles "Occupant model based on external files"

  extends IDEAS.Interfaces.Occupant(nZones=1, nLoads=1);
  parameter Integer occ=1
    "Which user from the read profiles in the SimInfoManager";
  parameter Modelica.SIunits.Temperature TSetOcc = 293.15;
  parameter Modelica.SIunits.Temperature TSetNOcc = 289.15;

  outer SimInfoManager sim
    annotation (Placement(transformation(extent={{-98,76},{-78,96}})));
equation

-heatPortRad[1].Q_flow = sim.tabQRad.y[occ];
-heatPortCon[1].Q_flow = sim.tabQCon.y[occ];
wattsLawPlug[1].P = sim.tabP.y[occ];
wattsLawPlug[1].Q = sim.tabQ.y[occ];
mDHW60C = sim.tabDHW.y[occ];
TSet[1] = noEvent(if sim.tabPre.y[profileID] >0.5 then TSetOcc else TSetNoOcc);

  annotation (Diagram(graphics));
end ExternalFiles;

within IDEAS.Occupants.Extern;
model MultiZone "External file occupant, for multi zone building models"

  extends IDEAS.Interfaces.Occupant(nLoads=1);

  parameter Integer occ=1
    "Which user from the read profiles in the SimInfoManager";
  parameter Real[nZones] VZones "Zone volumes";
  parameter Modelica.SIunits.Temperature TSetOcc = 293.15;
  parameter Modelica.SIunits.Temperature TSetNoOcc = 289.15;

  outer SimInfoManager sim
    annotation (Placement(transformation(extent={{-98,78},{-78,98}})));
equation

-heatPortRad.Q_flow = ones(nZones).*VZones/sum(VZones)*sim.tabQRad.y[occ];
-heatPortCon.Q_flow = ones(nZones).*VZones/sum(VZones)*sim.tabQCon.y[occ];
wattsLawPlug[1].P = sim.tabP.y[occ];
wattsLawPlug[1].Q = sim.tabQ.y[occ];
mDHW60C = sim.tabDHW.y[occ];
TSet = noEvent(if sim.tabPre.y[occ] > 0.5 then ones(nZones)*TSetOcc else ones(nZones)*TSetNoOcc);

  annotation (Diagram(graphics));
end MultiZone;

within IDEAS.Occupants.Extern;
model fromFiles

  extends IDEAS.Interfaces.Occupant(nLoads=1);
  parameter Integer occ
    "Which user from the read profiles in the SimInfoManager";
  parameter Modelica.SIunits.Temperature TSetOcc = 293.15;
  parameter Modelica.SIunits.Temperature TSetNOcc = 289.15;

  inner SimInfoManager sim annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
equation
heatPortRad[1].Q_flow = -ones(nZones)*sim.tabQRad.y[occ+1]/nZones;
heatPortCon[1].Q_flow = -ones(nZones)*sim.tabQCon.y[occ+1]/nZones;
wattsLawPlug[1].P = {sim.tabP.y[occ+1]};
wattsLawPlug[1].Q = {sim.tabQ.y[occ+1]};
mDHW60C = sim.tabDHW.y[occ];

if noEvent(sim.tabPre.y[occ+1] >= 0.5) then
  TSet = TSetOcc;
else
  TSet = TSetNOcc;
end if;

  annotation (Diagram(graphics));
end fromFiles;

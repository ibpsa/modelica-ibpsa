within IDEAS.Buildings.Validation.BaseClasses;
model Gain "BesTest nightventilation system"
  extends IDEAS.Interfaces.Occupant(nZones=1, nLoads=1);

parameter Modelica.SIunits.HeatFlowRate[1] Q = {200};

algorithm
heatPortCon.Q_flow := - Q*0.40;
heatPortRad.Q_flow := - Q*0.60;

end Gain;

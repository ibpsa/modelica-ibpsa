within IDEAS.Buildings.Validation.BaseClasses.Occupant;
model Gain "BESTEST fixed internal gains by occupants"
  extends IDEAS.Interfaces.Occupant(nLoads=1);

  parameter Modelica.SIunits.HeatFlowRate Q = 200 "Baseload internal gain";

equation
wattsLawPlug[1].P = Q;
wattsLawPlug[1].Q = 0;
for i in 1:nZones loop
  heatPortCon[i].Q_flow =  - Q*0.40;
  heatPortRad[i].Q_flow =  - Q*0.60;
  TSet[i] =  273.15;
end for;
mDHW60C = 0;

  annotation (Diagram(graphics));
end Gain;

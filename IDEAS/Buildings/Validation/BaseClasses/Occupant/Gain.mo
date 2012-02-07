within IDEAS.Buildings.Validation.BaseClasses.Occupant;
model Gain "BESTEST fixed internal gains by occupants"
  extends IDEAS.Interfaces.Occupant(nLoads=1);

  parameter Modelica.SIunits.HeatFlowRate Q = 200 "Baseload internal gain";

  Electric.BaseClasses.WattsLaw wattsLaw
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));

equation
  connect(wattsLaw.vi, pinLoad) annotation (Line(
      points={{80,0},{100,0}},
      color={85,170,255},
      smooth=Smooth.None));
wattsLaw.P = Q;
wattsLaw.Q = 0;
for i in 1:nZones loop
  heatPortCon[i].Q_flow =  - Q*0.40;
  heatPortRad[i].Q_flow =  - Q*0.60;
  TSet[i] =  273.15;
end for;
  annotation (Diagram(graphics));
end Gain;

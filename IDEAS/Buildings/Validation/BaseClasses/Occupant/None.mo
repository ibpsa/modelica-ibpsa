within IDEAS.Buildings.Validation.BaseClasses.Occupant;
model None "None"
  extends IDEAS.Interfaces.Occupant(nLoads=1);

  Electric.BaseClasses.WattsLaw wattsLaw
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));

equation
  connect(wattsLaw.vi, pinLoad) annotation (Line(
      points={{80,0},{100,0}},
      color={85,170,255},
      smooth=Smooth.None));
wattsLaw.P = 0;
wattsLaw.Q = 0;
for i in 1:nZones loop
  heatPortCon[i].Q_flow =  0;
  heatPortRad[i].Q_flow =  0;
  TSet[i] =  273.15;
end for;
  annotation (Diagram(graphics));
end None;

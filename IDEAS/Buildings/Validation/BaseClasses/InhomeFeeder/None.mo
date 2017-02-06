within IDEAS.Buildings.Validation.BaseClasses.InhomeFeeder;
model None "None"

  extends IDEAS.Templates.Interfaces.BaseClasses.InhomeFeeder;

  Modelica.Electrical.QuasiStationary.MultiPhase.Basic.PlugToPin_p plugToPin(m=
        3) annotation (Placement(transformation(extent={{32,-10},{52,10}})));
equation
  for i in 1:nHeatingLoads loop
    connect(plugHeatingLoad[i], plugToPin.plug_p) annotation (Line(
        points={{-100,40},{0,40},{0,0},{40,0}},
        color={85,170,255},
        smooth=Smooth.None));
  end for;
  for j in 1:nVentilationLoads loop
    connect(plugVentilationLoad[j], plugToPin.plug_p) annotation (Line(
        points={{-100,0},{40,0}},
        color={85,170,255},
        smooth=Smooth.None));

  end for;
  for k in 1:nOccupantLoads loop
    connect(plugOccupantLoad[k], plugToPin.plug_p) annotation (Line(
        points={{-100,-40},{0,-40},{0,0},{40,0}},
        color={85,170,255},
        smooth=Smooth.None));

  end for;

  connect(plugToPin.pin_p, plugFeeder[1]) annotation (Line(
      points={{44,0},{100,0}},
      color={85,170,255},
      smooth=Smooth.None));
  annotation (Diagram(graphics));
end None;

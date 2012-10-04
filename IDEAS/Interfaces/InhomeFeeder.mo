within IDEAS.Interfaces;
partial model InhomeFeeder
  parameter Integer nHeatingLoads(min=1)
    "number of electric loads for the heating system";
  parameter Integer nVentilationLoads(min=1)
    "number of electric loads for the ventilation system";
  parameter Integer nOccupantLoads(min=1)
    "number of electric loads for the occupants";
  parameter Integer numberOfPhazes=1
    "The number of phazes connected in the home"
      annotation(choices(
  choice=1 "Single phaze grid connection",
  choice=4 "threephaze (4 line) grid connection"));

  outer IDEAS.SimInfoManager         sim
    "Simulation information manager for climate data" annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  Modelica.Electrical.QuasiStationary.SinglePhase.Interfaces.PositivePin plugFeeder[
    numberOfPhazes]
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  Modelica.Electrical.QuasiStationary.MultiPhase.Interfaces.PositivePlug[
    nVentilationLoads] plugVentilationLoad
    "Electricity connection for the ventilaiton system" annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Modelica.Electrical.QuasiStationary.MultiPhase.Interfaces.PositivePlug[
    nHeatingLoads] plugHeatingLoad
    "Electricity connection for the heating system" annotation (Placement(transformation(extent={{-110,30},{-90,50}})));
  Modelica.Electrical.QuasiStationary.MultiPhase.Interfaces.PositivePlug[
    nOccupantLoads] plugOccupantLoad "Electricity connection for the occupants"
                                               annotation (Placement(transformation(extent={{-110,-50},{-90,-30}})));
  annotation(Icon(graphics={
        Rectangle(
          extent={{28,60},{70,20}},
          lineColor={85,170,255},
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-26,54},{-26,20},{-6,20},{-6,28},{4,28},{4,32},{-6,32},{-6,44},
              {8,44},{8,50},{-6,50},{-6,54},{-26,54}},
          lineColor={85,170,255},
          smooth=Smooth.None,
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-14,20},{-14,0},{-94,0}},
          color={85,170,255},
          smooth=Smooth.None),
        Rectangle(
          extent={{46,50},{50,42}},
          lineColor={85,170,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{56,34},{60,26}},
          lineColor={85,170,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{38,34},{42,26}},
          lineColor={85,170,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{48,20},{48,0},{96,0}},
          color={85,170,255},
          smooth=Smooth.None)}),                                    Diagram(
        graphics));

end InhomeFeeder;

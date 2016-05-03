within IDEAS.Templates.Interfaces;
partial model Feeder

  parameter Integer nLoads(min=1) "number of electric loads";
  parameter Boolean backbone=false;

  Modelica.Electrical.QuasiStationary.SinglePhase.Interfaces.PositivePin
    plugBackbone if backbone "Electricity connection for the backbone grid"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  Modelica.Electrical.QuasiStationary.SinglePhase.Interfaces.PositivePin[nLoads]
    plugFeeder "Electricity connection for the buildings"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  annotation (Icon(graphics={
        Line(
          points={{30,36},{54,18},{100,4}},
          color={85,170,255},
          smooth=Smooth.Bezier),
        Line(
          points={{-22,36},{30,2},{100,0}},
          color={85,170,255},
          smooth=Smooth.Bezier),
        Polygon(
          points={{-32,40},{-32,34},{-4,34},{-4,-80},{4,-80},{4,34},{34,34},{34,
              40},{4,40},{4,46},{-4,46},{-4,40},{-32,40}},
          lineColor={95,95,95},
          smooth=Smooth.None,
          fillPattern=FillPattern.Solid,
          fillColor={95,95,95}),
        Line(
          points={{-102,4},{-46,12},{-28,36}},
          color={85,170,255},
          smooth=Smooth.Bezier),
        Line(
          points={{-100,0},{-12,12},{30,36}},
          color={85,170,255},
          smooth=Smooth.Bezier)}), Diagram(graphics));

end Feeder;

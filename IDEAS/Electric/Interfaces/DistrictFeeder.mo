within IDEAS.Electric.Interfaces;
partial model DistrictFeeder

  parameter Integer nLoads(min=1) "number of electric loads";

  Modelica.Electrical.QuasiStationary.MultiPhase.Interfaces.PositivePlug plug_feeder
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  Modelica.Electrical.QuasiStationary.MultiPhase.Interfaces.PositivePlug[nLoads] plug_loads
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  annotation(Icon(graphics={
        Polygon(
          points={{-32,40},{-32,34},{-4,34},{-4,-80},{4,-80},{4,34},{34,34},{34,
              40},{4,40},{4,46},{-4,46},{-4,40},{-32,40}},
          lineColor={127,0,0},
          smooth=Smooth.None,
          fillPattern=FillPattern.Solid,
          fillColor={127,0,0}),
        Line(
          points={{-102,4},{-46,12},{-28,36}},
          color={127,0,0},
          smooth=Smooth.Bezier),
        Line(
          points={{-100,0},{-12,12},{30,36}},
          color={127,0,0},
          smooth=Smooth.Bezier),
        Line(
          points={{-22,36},{30,2},{100,0}},
          color={127,0,0},
          smooth=Smooth.Bezier),
        Line(
          points={{30,36},{54,18},{100,4}},
          color={127,0,0},
          smooth=Smooth.Bezier)}),                                  Diagram(
        graphics));

end DistrictFeeder;

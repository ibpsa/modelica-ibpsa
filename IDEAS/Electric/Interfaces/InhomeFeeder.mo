within IDEAS.Electric.Interfaces;
partial model InhomeFeeder

  outer IDEAS.Climate.SimInfoManager  sim
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  parameter Integer nLoads(min=1) "number of electric loads";

  Modelica.Electrical.QuasiStationary.MultiPhase.Interfaces.PositivePlug plug_feeder
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  Modelica.Electrical.QuasiStationary.MultiPhase.Interfaces.PositivePlug[nLoads] plug_loads
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  annotation(Icon(graphics={
        Rectangle(
          extent={{28,60},{70,20}},
          lineColor={127,0,0},
          fillColor={127,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-26,54},{-26,20},{-6,20},{-6,28},{4,28},{4,32},{-6,32},{-6,44},
              {8,44},{8,50},{-6,50},{-6,54},{-26,54}},
          lineColor={127,0,0},
          smooth=Smooth.None,
          fillColor={127,0,0},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-14,20},{-14,0},{-94,0}},
          color={127,0,0},
          smooth=Smooth.None),
        Rectangle(
          extent={{46,50},{50,42}},
          lineColor={127,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{56,34},{60,26}},
          lineColor={127,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{38,34},{42,26}},
          lineColor={127,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{48,20},{48,0},{96,0}},
          color={127,0,0},
          smooth=Smooth.None)}),                                    Diagram(
        graphics));

end InhomeFeeder;

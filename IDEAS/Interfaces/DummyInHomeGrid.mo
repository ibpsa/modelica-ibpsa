within IDEAS.Interfaces;
model DummyInHomeGrid
  "Dummy inhome grid model for a single phase grid connection: one single plug "

Modelica.Electrical.QuasiStationary.MultiPhase.Interfaces.PositivePlug nodeSingle(m=1) annotation (Placement(transformation(extent={{-110,
            -10},{-90,10}})));
Modelica.Electrical.QuasiStationary.SinglePhase.Interfaces.PositivePin pinSingle annotation (Placement(transformation(extent={{90,-10},
            {110,10}}), iconTransformation(extent={{90,-10},{110,10}})));

  Modelica.Electrical.QuasiStationary.MultiPhase.Basic.PlugToPin_p plugToPin_p(
      m=1) annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
equation
 //pinSingle.v = nodeSingle.pin[1].v;
 // pinSingle.i = - nodeSingle.pin[1].i;
  connect(nodeSingle, plugToPin_p.plug_p) annotation (Line(
      points={{-100,0},{-2,0}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(plugToPin_p.pin_p, pinSingle) annotation (Line(
      points={{2,0},{100,0}},
      color={85,170,255},
      smooth=Smooth.None));
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
        graphics),
    Documentation(info="<html>
<p>This gives an in home grid with single phase plugs and single phase grid connection</p>
</html>"));
end DummyInHomeGrid;

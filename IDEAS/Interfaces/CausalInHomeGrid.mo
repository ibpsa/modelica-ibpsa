within IDEAS.Interfaces;
model CausalInHomeGrid
  "Causal inhome grid model for a single phase grid connection: one single plug "

Modelica.Electrical.QuasiStationary.MultiPhase.Interfaces.PositivePlug nodeSingle(m=1) annotation (Placement(transformation(extent={{-110,
            -10},{-90,10}})));
Modelica.Electrical.QuasiStationary.SinglePhase.Interfaces.PositivePin pinSingle annotation (Placement(transformation(extent={{90,-10},
            {110,10}}), iconTransformation(extent={{90,-10},{110,10}})));
Real P(start=0);
Real Q(start=0);

  Electric.BaseClasses.WattsLaw wattsLaw(P=P, Q=Q)
    annotation (Placement(transformation(extent={{8,-10},{28,10}})));
  Modelica.Electrical.QuasiStationary.SinglePhase.Sources.VoltageSource voltageSource(
    f=50,
    V=230,
    phi=0)  annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-50,-38})));
  Modelica.Electrical.QuasiStationary.SinglePhase.Basic.Ground ground
    annotation (Placement(transformation(extent={{-60,-88},{-40,-68}})));
  Modelica.Electrical.QuasiStationary.MultiPhase.Basic.PlugToPin_p plugToPin_p(
      m=1) annotation (Placement(transformation(extent={{-86,-32},{-66,-12}})));
  Modelica.Blocks.Interfaces.RealOutput VGrid
    annotation (Placement(transformation(extent={{96,30},{116,50}})));
algorithm
P := - Modelica.ComplexMath.real(nodeSingle.pin[1].v*Modelica.ComplexMath.conj(nodeSingle.pin[1].i));
Q := - Modelica.ComplexMath.imag(nodeSingle.pin[1].v*Modelica.ComplexMath.conj(nodeSingle.pin[1].i));
VGrid := max(Modelica.ComplexMath.'abs'(pinSingle.v));

equation
  connect(wattsLaw.vi[1], pinSingle) annotation (Line(
      points={{28,0},{100,0}},
      color={85,170,255},
      smooth=Smooth.None));

  connect(nodeSingle, plugToPin_p.plug_p) annotation (Line(
      points={{-100,0},{-78,0},{-78,-22}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(voltageSource.pin_p, plugToPin_p.pin_p) annotation (Line(
      points={{-50,-28},{-50,-22},{-74,-22}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(ground.pin, voltageSource.pin_n) annotation (Line(
      points={{-50,-68},{-50,-48}},
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
end CausalInHomeGrid;

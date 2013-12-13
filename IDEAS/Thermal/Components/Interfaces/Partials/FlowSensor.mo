within IDEAS.Thermal.Components.Interfaces.Partials;
partial model FlowSensor "Partial model of flow sensor"

  extends TwoPort(
    final m=0,
    final T0=0,
    final tapT=1);
  Modelica.Blocks.Interfaces.RealOutput y annotation (Placement(transformation(
        origin={0,-110},
        extent={{10,-10},{-10,10}},
        rotation=90)));
equation
  // no pressure drop
  dp = 0;
  // no energy exchange
  Q_flow = 0;
  annotation (
    Documentation(info="<HTML>
Partial model for a flow sensor (mass flow/heat flow).<br>
Pressure, mass flow, temperature and enthalpy flow of medium are not affected, but mixing rule is applied.
</HTML>"),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={Ellipse(
          extent={{-70,70},{70,-70}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),Line(points={{0,70},{0,40}}, color={0,
          0,0}),Line(points={{22.9,32.8},{40.2,57.3}}, color={0,0,0}),Line(
          points={{-22.9,32.8},{-40.2,57.3}}, color={0,0,0}),Line(points={{37.6,
          13.7},{65.8,23.9}}, color={0,0,0}),Line(points={{-37.6,13.7},{-65.8,
          23.9}}, color={0,0,0}),Line(points={{0,0},{9.02,28.6}}, color={0,0,0}),
          Polygon(
          points={{-0.48,31.6},{18,26},{18,57.2},{-0.48,31.6}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),Ellipse(
          extent={{-5,5},{5,-5}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),Line(points={{-70,0},{-90,0}}, color={
          0,0,0}),Line(points={{70,0},{90,0}}, color={0,0,0}),Line(points={{0,-100},
          {0,-70}}),Text(
          extent={{-150,130},{150,70}},
          lineColor={0,0,255},
          textString="%name")}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}), graphics));
end FlowSensor;

within IDEAS.Thermal.Components.Interfaces.Partials;
partial model RelativeSensor "Partial model of relative sensor"

  parameter Thermal.Data.Interfaces.Medium medium=Data.Interfaces.Medium()
    "Sensor's medium" annotation (__Dymola_choicesAllMatching=true);
  FlowPort_a flowPort_a(final medium=medium) annotation (Placement(
        transformation(extent={{-110,-10},{-90,10}}, rotation=0)));
  FlowPort_b flowPort_b(final medium=medium) annotation (Placement(
        transformation(extent={{90,-10},{110,10}}, rotation=0)));
  Modelica.Blocks.Interfaces.RealOutput y annotation (Placement(transformation(
        origin={0,-110},
        extent={{10,-10},{-10,10}},
        rotation=90)));
equation
  // no mass exchange
  flowPort_a.m_flow = 0;
  flowPort_b.m_flow = 0;
  // no energy exchange
  flowPort_a.H_flow = 0;
  flowPort_b.H_flow = 0;
  annotation (
    Documentation(info="<HTML>
Partial model for a relative sensor (pressure drop/temperature difference).<br>
Pressure, mass flow, temperature and enthalpy flow of medium are not affected.
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
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics));
end RelativeSensor;

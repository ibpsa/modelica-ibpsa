within IDEAS.Controls.Control_fixme;
block rem_NoEvent
  "Timer measuring the time from the time instant where the Boolean input became true"

  parameter Modelica.SIunits.Time interval;

  extends Modelica.Blocks.Interfaces.partialBooleanBlockIcon;
  Modelica.Blocks.Interfaces.RealInput u "Connector of Boolean input signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}},
          rotation=0)));
  Modelica.Blocks.Interfaces.RealOutput y "Connector of Real output signal"
    annotation (Placement(transformation(extent={{100,-10},{120,10}}, rotation=
            0)));

algorithm
  y := (u/interval - noEvent(integer(u/interval)))*interval;

  annotation (
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={Line(points={{-90,-70},{82,-70}}, color={192,192,
          192}),Line(points={{-80,68},{-80,-80}}, color={192,192,192}),Polygon(
          points={{90,-70},{68,-62},{68,-78},{90,-70}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),Polygon(
          points={{-80,90},{-88,68},{-72,68},{-80,90}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),Line(
          points={{-80,-32},{0,48},{0,-32},{80,48},{80,-32}},
          color={0,0,255},
          smooth=Smooth.None),Line(
          points={{-80,-70},{60,70}},
          color={255,0,255},
          smooth=Smooth.None)}),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={Line(points={{-90,-70},{82,-70}}, color={0,0,0}),
          Line(points={{-80,68},{-80,-80}}, color={0,0,0}),Polygon(
          points={{90,-70},{68,-62},{68,-78},{90,-70}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),Polygon(
          points={{-80,90},{-88,68},{-72,68},{-80,90}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),Text(
          extent={{-88,6},{-54,-4}},
          lineColor={0,0,0},
          textString="y"),Text(
          extent={{48,-80},{84,-88}},
          lineColor={0,0,0},
          textString="time"),Text(
          extent={{-88,-36},{-54,-46}},
          lineColor={0,0,0},
          textString="u"),Line(
          points={{-80,-60},{60,80}},
          color={255,0,255},
          smooth=Smooth.None),Line(
          points={{-80,-22},{0,58},{0,-22},{80,58},{80,-22}},
          color={0,0,255},
          smooth=Smooth.None)}),
    Documentation(info="<HTML>
<p> When the Boolean input \"u\" becomes <b>true</b>, the timer is started
and the output \"y\" is the time from the time instant where u became true.
The timer is stopped and the output is reset to zero, once the
input becomes false.
</p>
</HTML>
"));
end rem_NoEvent;

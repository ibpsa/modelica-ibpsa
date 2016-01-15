within IDEAS.Fluid.BaseCircuits;
model CollectorUnit "Collector unit"

  extends IDEAS.Fluid.BaseCircuits.Interfaces.PartialBaseCircuit(final includePipes = false, pipeReturn(dp_nominal=0));

  Modelica.Fluid.Interfaces.FluidPort_a port_a3(
                     redeclare final package Medium = Medium,
                     m_flow(min=if allowFlowReversal1 then -Modelica.Constants.inf else 0),
                     h_outflow(start=h_outflow_a1_start))
    "Fluid connector a1 (positive design flow direction is from port_a1 to port_b1)"
    annotation (Placement(transformation(extent={{50,90},{70,110}},
            rotation=0)));
  Modelica.Fluid.Interfaces.FluidPort_b port_b3(
                     redeclare final package Medium = Medium,
                     m_flow(max=if allowFlowReversal2 then +Modelica.Constants.inf else 0),
                     h_outflow(start=h_outflow_b2_start))
    "Fluid connector b2 (positive design flow direction is from port_a2 to port_b2)"
    annotation (Placement(transformation(extent={{-50,90},{-70,110}},
                          rotation=0),
                iconTransformation(extent={{-50,90},{-70,110}})));
equation
  connect(port_a1, port_b3) annotation (Line(points={{-100,60},{-60,60},{-60,100}},
        color={0,127,255}));
  connect(port_a1, port_b1)
    annotation (Line(points={{-100,60},{0,60},{100,60}}, color={0,127,255}));
  connect(port_b2, port_a3) annotation (Line(points={{-100,-60},{-20,-60},{60,-60},
          {60,100}}, color={0,127,255},
      pattern=LinePattern.Dash));
  connect(port_b2, port_a2) annotation (Line(points={{-100,-60},{100,-60},{100,-60}},
        color={0,127,255},
      pattern=LinePattern.Dash));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),           Documentation(revisions="<html>
<p><ul>
<li>November 2014 by Filip Jorissen:<br> 
Initial version</li>
</ul></p>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}),
        graphics={
        Line(
          points={{-100,-60},{100,-60}},
          color={0,127,255},
          pattern=LinePattern.Dash),
        Line(
          points={{-100,60},{-60,60},{-60,100}},
          color={0,127,255}),
        Line(
          points={{-60,60},{100,60}},
          color={0,127,255}),
        Line(
          points={{60,100},{60,-60}},
          color={0,127,255},
          pattern=LinePattern.Dash),
        Polygon(
          points={{-80,68},{-68,68},{-68,80},{-52,80},{-52,68},{-20,68},{-20,52},
              {-80,52},{-80,68}},
          lineColor={0,0,127},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{80,-52},{68,-52},{68,-40},{52,-40},{52,-52},{20,-52},{20,-68},
              {80,-68},{80,-52}},
          lineColor={0,0,127},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}));
end CollectorUnit;

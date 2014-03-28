within IDEAS.Fluid.Movers;
model Pump "Prescribed mass flow rate, no heat exchange."
  extends IDEAS.Fluid.Interfaces.Partials.PumpTwoPort(idealSource(
        control_m_flow=true));
  parameter Boolean useInput=false "Enable / disable MassFlowRate input"
    annotation (Evaluate=true);

  parameter Modelica.SIunits.Pressure dpFix=50000
    "Fixed pressure drop, used for determining the electricity consumption";
  parameter Real etaTot=0.8 "Fixed total pump efficiency";
  Modelica.SIunits.Power PEl "Electricity consumption";
  Modelica.Blocks.Interfaces.RealInput m_flowSet(
    start=0,
    min=0,
    max=1) = m_flow_pump if useInput annotation (Placement(transformation(
        origin={0,100},
        extent={{-10,-10},{10,10}},
        rotation=270)));
protected
  Modelica.SIunits.MassFlowRate m_flow_pump;

public
  Modelica.Blocks.Sources.RealExpression realExpression1(y=m_flow_pump)
    annotation (Placement(transformation(extent={{-32,32},{-12,52}})));
  Modelica.Blocks.Interfaces.RealOutput P "Electrical power consumption"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={30,100})));
public
  Modelica.Blocks.Sources.RealExpression realExpression2(y=PEl)
    annotation (Placement(transformation(extent={{4,52},{24,72}})));
equation
  if not useInput then
    m_flow_pump = m_flow_nominal;
  end if;

  Q_flow = 0;

  PEl = m_flow_pump/Medium.density(Medium.setState_phX(port_a.p, inStream(port_a.h_outflow), Medium.X_default))*dpFix/etaTot;
  connect(realExpression1.y, idealSource.m_flow_in) annotation (Line(
      points={{-11,42},{0,42},{0,8},{12,8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(realExpression2.y, P) annotation (Line(
      points={{25,62},{30,62},{30,100}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    Documentation(info="<html>
<p><b>Description</b> </p>
<p>Basic pump model without heat exchange. This model sets the mass flow rate, either as a constant or based on an input. The thermal equations are identical to the <a href=\"modelica://IDEAS.Thermal.Components.BaseClasses.Pipe\">Pipe</a> model.</p>
<p>If an input is used (<code>useInput&nbsp;=&nbsp;true)</code>, <code>m_flowSet</code> is supposed to be a real value, and the flowrate is then <code>m_flowSet * m_flowNom. m_flowSet </code>is logically between 0 and 1, but any value is possible, as shown in the provided Example.</p>
<p>The model calculates the electricity consumption of the pump in a very simplified way: a fixed pressure drop and an efficiency are given as parameters, and the electricity consumption is computed as:</p>
<pre>PEl&nbsp;=&nbsp;m_flow&nbsp;/&nbsp;medium.rho&nbsp;*&nbsp;dpFix&nbsp;/&nbsp;etaTot;</pre>
<p><h4>Assumptions and limitations </h4></p>
<p><ol>
<li>This model does not specify a relation between pressure and flowrate, the flowrate is IMPOSED</li>
<li>If the water content of the pump, m, is zero, there are no thermal dynamics. </li>
<li>The electricity consumption is computed based on a FIXED efficiency and FIXED pressure drop AS PARAMETERS</li>
<li>The inefficiency of the pump does NOT lead to an enthalpy increase of the outlet flow.</li>
</ol></p>
<p><h4>Model use</h4></p>
<p><ol>
<li>Decide if the pump will be controlled through an input or if the flowrate is a constant</li>
<li>Set medium and water content of the pump</li>
<li>Specify the parameters for computing the electricity consumption</li>
</ol></p>
<p><h4>Validation </h4></p>
<p>None</p>
<p><h4>Example </h4></p>
<p>An example in which this model is used is the <a href=\"modelica://IDEAS.Thermal.Components.Examples.HydraulicCircuit\">HydraulicCircuit</a>.</p>
</html>", revisions="<html>
<p><ul>
<li>2013, Roel De Coninck, documentation</li>
<li>2012, Ruben Baetens, changed graphics</li>
<li>2010, Roel De Coninck, First version</li>
</ul></p>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={
        Ellipse(
          extent={{-60,60},{60,-60}},
          lineColor={135,135,135},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-40,20},{0,-20}},
          lineColor={0,0,0},
          textString="V"),
        Line(
          points={{-100,0},{-60,0}},
          color={0,128,255},
          smooth=Smooth.None),
        Line(
          points={{100,0},{60,0}},
          color={0,128,255},
          smooth=Smooth.None),
        Line(
          points={{0,0},{0,80}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{-40,80},{40,80}},
          color={0,0,127},
          smooth=Smooth.None),
        Polygon(
          points={{-38,46},{60,0},{60,0},{-38,-46},{-38,46}},
          lineColor={135,135,135},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid)}),
    Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{100,
            100}}), graphics));
end Pump;

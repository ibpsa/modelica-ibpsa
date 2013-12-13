within IDEAS.Thermal.Components.BaseClasses;
model Pump_Insulated
  "Prescribed mass flow rate, with UA-value for environmental heat exchange."

  parameter Thermal.Data.Interfaces.Medium medium=Data.Interfaces.Medium()
    "Medium in the component" annotation (choicesAllMatching=true);
  parameter Modelica.SIunits.Mass m(start=1) "Mass of medium";
  parameter Modelica.SIunits.Temperature TInitial=293.15
    "Initial temperature of all Temperature states";

  parameter Boolean useInput=false "Enable / disable MassFlowRate input"
    annotation (Evaluate=true);
  parameter Modelica.SIunits.MassFlowRate m_flowNom(min=0, start=1)
    "Nominal mass flowrate" annotation (Dialog(enable=not useVolumeFlowInput));
  parameter Modelica.SIunits.Pressure dpFix=50000
    "Fixed pressure drop, used for determining the electricity consumption";
  parameter Real etaTot=0.8 "Fixed total pump efficiency";

  SI.Temperature T=pump_HeatPort.T "Temperature of the fluid";
  Modelica.Blocks.Interfaces.RealInput m_flowSet(
    min=0,
    max=1) = m_flow/m_flowNom if useInput annotation (Placement(transformation(
        origin={0,100},
        extent={{-10,-10},{10,10}},
        rotation=270), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={90,82})));
  parameter SI.ThermalConductance UA "Thermal conductance of the insulation";

protected
  Modelica.SIunits.MassFlowRate m_flow;

  Pump_HeatPort pump_HeatPort(
    medium=medium,
    useInput=useInput,
    m_flowNom=m_flowNom,
    dpFix=dpFix,
    etaTot=etaTot)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor thermalConductor(G=
        UA) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,-44})));

public
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort annotation (
      Placement(transformation(extent={{-20,-90},{0,-70}}), iconTransformation(
          extent={{-20,-90},{0,-70}})));
  Interfaces.FlowPort_a flowPort_a(medium=medium)
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Interfaces.FlowPort_b flowPort_b(medium=medium) annotation (Placement(
        transformation(extent={{190,-10},{210,10}}), iconTransformation(extent=
            {{190,-10},{210,10}})));
  Modelica.Blocks.Interfaces.RealOutput PEl "Electricity consumption"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={92,-80}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={90,-80})));
equation
  if not useInput then
    m_flow = m_flowNom;
  end if;
  connect(m_flowSet, pump_HeatPort.m_flowSet);
  connect(thermalConductor.port_a, heatPort) annotation (Line(
      points={{-6.12323e-016,-54},{-10,-54},{-10,-80}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(thermalConductor.port_b, pump_HeatPort.heatPort) annotation (Line(
      points={{6.12323e-016,-34},{0,-34},{0,-10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(pump_HeatPort.flowPort_a, flowPort_a) annotation (Line(
      points={{-10,0},{-100,0}},
      color={0,128,255},
      smooth=Smooth.None));
  connect(pump_HeatPort.flowPort_b, flowPort_b) annotation (Line(
      points={{10,0},{200,0}},
      color={0,128,255},
      smooth=Smooth.None));
  connect(pump_HeatPort.PEl, PEl) annotation (Line(
      points={{4,-10.6},{48,-10.6},{48,-12},{92,-12},{92,-80}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(extent={{-100,-80},{200,80}}, preserveAspectRatio=
            true), graphics),
    Icon(coordinateSystem(extent={{-100,-80},{200,80}}, preserveAspectRatio=
            true), graphics={
        Ellipse(extent={{-70,60},{50,-60}}, lineColor={100,100,100}),
        Line(
          points={{-100,0},{-80,0}},
          color={0,0,127},
          smooth=Smooth.None),
        Polygon(
          points={{-40,46},{46,0},{46,0},{-40,-44},{-40,46}},
          lineColor={135,135,135},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-80,60},{-80,-60}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{180,60},{180,-60}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{180,0},{200,0}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{170,60},{26,-48}},
          color={100,100,100},
          smooth=Smooth.None),
        Line(
          points={{170,-60},{90,0}},
          color={100,100,100},
          smooth=Smooth.None),
        Polygon(
          points={{170,60},{130,46},{144,28},{170,60}},
          lineColor={100,100,100},
          smooth=Smooth.None,
          fillColor={100,100,100},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{130,-30},{120,-16},{114,-24},{130,-30}},
          lineColor={100,100,100},
          smooth=Smooth.None,
          fillColor={100,100,100},
          fillPattern=FillPattern.Solid)}),
    Documentation(info="<html>
<p><b>Description</b> </p>
<p>Basic pump model with UA-value for heat exchange to environment. This model sets the mass flow rate, either as a constant or based on an input. The thermal equations are identical to the <a href=\"modelica://IDEAS.Thermal.Components.BaseClasses.Pipe_Insulated\">Pipe_Insulated</a> model.</p>
<p>If an input is used (<code>useInput&nbsp;=&nbsp;true)</code>, <code>m_flowSet</code> is supposed to be a real value between 0 and 1, and the flowrate is then <code>m_flowSet * m_flowNom.</code></p>
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
<li>Set the UA value and connect the heatPort</li>
</ol></p>
<p><h4>Validation </h4></p>
<p>None</p>
<p><h4>Example </h4></p>
<p>The <a href=\"modelica://IDEAS.Thermal.Components.Examples.HydraulicCircuit\">HydraulicCircuit</a> example uses <a href=\"modelica://IDEAS.Thermal.Components.BaseClasses.Pump\">Pump</a> models but they can easily be replaced with this Pump_Insulated model.</p>
</html>", revisions="<html>
<p><ul>
<li>May 2013, Roel De Coninck, documentation</li>
<li>March 2013, Ruben Baetens, graphics</li>
<li>October 2012, Roel De Coninck, first version.</li>
</ul></p>
</html>"));
end Pump_Insulated;

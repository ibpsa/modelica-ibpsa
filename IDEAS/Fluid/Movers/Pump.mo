within IDEAS.Fluid.Movers;
model Pump "Prescribed mass flow rate, no heat exchange."
  extends IDEAS.Fluid.Interfaces.OnOffInterface;
  extends IDEAS.Fluid.Interfaces.Partials.PumpTwoPort(idealSource(
        control_m_flow=true, allowFlowReversal=true));
  parameter Boolean useInput=false "Enable / disable MassFlowRate input"
    annotation (Evaluate=true);
  // Classes used to implement the filtered mass flow rate
  parameter Boolean filteredMassFlowRate=false
    "= true, if speed is filtered with a 2nd order CriticalDamping filter";
  parameter Modelica.SIunits.Time riseTime=1
    "Rise time of the filter (time to reach 99.6 % of the mass flow rate)";
  parameter Modelica.SIunits.Pressure dpFix=50000
    "Fixed pressure drop, used for determining the electricity consumption";
  parameter Real etaTot=0.8 "Fixed total pump efficiency";
  parameter Boolean addResistor = false;
  parameter Modelica.SIunits.ThermalConductance UA = 1
    "Thermal conductance of the insulation"
    annotation(Dialog(enable=addResistor));

  Modelica.SIunits.Power PEl "Electricity consumption";
  Modelica.Blocks.Interfaces.RealInput m_flowSet(
    start=0,
    min=0,
    max=1) if useInput annotation (Placement(transformation(
        origin={0,104},
        extent={{-10,-10},{10,10}},
        rotation=270)));
  Modelica.Blocks.Sources.RealExpression realExpression1(y=on_internal_filtered*
        m_flow_pump)
    annotation (Placement(transformation(extent={{82,8},{20,28}})));
  Modelica.Blocks.Interfaces.RealOutput P "Electrical power consumption"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={80,106})));
  Modelica.Blocks.Sources.RealExpression realExpression2(y=PEl)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={80,76})));
  Modelica.Blocks.Interfaces.RealOutput m_flow_actual(min=0, max=m_flow_nominal,
                                                 final quantity="MassFlowRate",
                                                  final unit="kg/s",
                                                  nominal=m_flow_nominal) = m_flow_pump if useInput
    annotation (Placement(transformation(extent={{40,54},{60,74}})));
  Modelica.Blocks.Math.Gain gaiFlow(final k=m_flow_nominal,
    u(min=0, max=1),
    y(final quantity="MassFlowRate",
      final unit="kg/s",
      nominal=m_flow_nominal)) if useInput
    "Gain for mass flow rate input signal"
    annotation (Placement(transformation(extent={{-12,58},{0,70}})));
  Modelica.Blocks.Interfaces.RealOutput m_flow_filtered(min=0, max=m_flow_nominal,
                                                 final quantity="MassFlowRate",
                                                  final unit="kg/s",
                                                  nominal=m_flow_nominal) if
     useInput and filteredMassFlowRate
    "Filtered m_flow in the range 0..m_flow_nominal"
    annotation (Placement(transformation(extent={{40,72},{60,92}}),
        iconTransformation(extent={{60,50},{80,70}})));
  Modelica.Blocks.Continuous.Filter filter(
     order=2,
     f_cut=5/(2*Modelica.Constants.pi*riseTime),
     x(each stateSelect=StateSelect.always),
     u_nominal=m_flow_nominal,
     u(final quantity="MassFlowRate", final unit="kg/s", nominal=m_flow_nominal),
     y(final quantity="MassFlowRate", final unit="kg/s", nominal=m_flow_nominal),
     final analogFilter=Modelica.Blocks.Types.AnalogFilter.CriticalDamping,
     final filterType=Modelica.Blocks.Types.FilterType.LowPass) if
        useInput and filteredMassFlowRate
    "Second order filter to approximate valve opening time, and to improve numerics"
    annotation (Placement(transformation(extent={{20,75},{34,89}})));
protected
  Modelica.SIunits.MassFlowRate m_flow_pump;
  Modelica.Blocks.Interfaces.RealOutput on_internal_filtered;
public
  Modelica.Blocks.Math.BooleanToReal booleanToReal if use_onOffSignal
    annotation (Placement(transformation(extent={{0,34},{12,46}})));
  Modelica.Blocks.Sources.BooleanExpression realExpression3(y=on_internal) if use_onOffSignal
    annotation (Placement(transformation(extent={{-28,30},{-8,50}})));
  Modelica.Blocks.Continuous.Filter filterOnOff(
     order=2,
     f_cut=5/(2*Modelica.Constants.pi*riseTime),
     x(each stateSelect=StateSelect.always),
     final analogFilter=Modelica.Blocks.Types.AnalogFilter.CriticalDamping,
     final filterType=Modelica.Blocks.Types.FilterType.LowPass,
    y_start=if onOff then 1 else 0) if use_onOffSignal
    "Second order filter to approximate valve opening time, and to improve numerics"
    annotation (Placement(transformation(extent={{20,33},{34,47}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor thermalConductor(G=
        UA) if addResistor annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,-50})));
public
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort annotation (
      Placement(transformation(extent={{-10,-110},{10,-90}}),
                                                            iconTransformation(
          extent={{-20,-90},{0,-70}})));
equation
  if not useInput then
    m_flow_pump = m_flow_nominal;
  else
      if filteredMassFlowRate then
        connect(gaiFlow.y, filter.u) annotation (Line(
          points={{0.6,64},{10.6,64},{10.6,82},{18.6,82}},
          color={0,0,127},
          smooth=Smooth.None));
        connect(filter.y, m_flow_actual) annotation (Line(
          points={{34.7,82},{38,82},{38,64},{50,64}},
          color={0,0,127},
          smooth=Smooth.None));
        connect(filter.y, m_flow_filtered) annotation (Line(
          points={{34.7,82},{50,82}},
          color={0,0,127},
          smooth=Smooth.None));
      else
        connect(gaiFlow.y, m_flow_actual) annotation (Line(
          points={{0.6,64},{50,64}},
          color={0,0,127},
          smooth=Smooth.None));
      end if;
    end if;
  Q_flow = 0;
  PEl = m_flow_pump/Medium.density(Medium.setState_phX(port_a.p, inStream(port_a.h_outflow), Medium.X_default))*dpFix/etaTot;
  connect(realExpression2.y, P) annotation (Line(
      points={{80,87},{80,106}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(m_flowSet, gaiFlow.u) annotation (Line(
      points={{0,104},{0,82},{-16,82},{-16,64},{-13.2,64}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(realExpression1.y, idealSource.m_flow_in) annotation (Line(
      points={{16.9,18},{12,18},{12,8}},
      color={0,0,127},
      smooth=Smooth.None));

  if not use_onOffSignal then
    on_internal_filtered = if on_internal then 1 else 0;
  else
    connect(on_internal_filtered,filterOnOff.y);
    connect(realExpression3.y, booleanToReal.u) annotation (Line(
      points={{-7,40},{-1.2,40}},
      color={255,0,255},
      smooth=Smooth.None));
    connect(booleanToReal.y, filterOnOff.u) annotation (Line(
      points={{12.6,40},{18.6,40}},
      color={0,0,127},
      smooth=Smooth.None));
  end if;
  connect(thermalConductor.port_b, vol.heatPort) annotation (Line(
      points={{6.66134e-16,-40},{1,-40},{1,10},{-44,10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(thermalConductor.port_a,heatPort)  annotation (Line(
      points={{0,-60},{0,-100}},
      color={191,0,0},
      smooth=Smooth.None));
  if not addResistor then
    connect(vol.heatPort, heatPort) annotation (Line(
      points={{-44,10},{0,10},{0,-100}},
      color={191,0,0},
      smooth=Smooth.None));
  end if;
  annotation (
    Documentation(info="<html>
<p><b>Description</b> </p>
<p>Basic pump model with limited options. This model sets the mass flow rate, either as a constant or based on an input.</p>
<p>If an input is used (<code>useInput&nbsp;=&nbsp;true)</code>, <code>m_flowSet</code> is supposed to be a real value, and the flowrate is then <code>m_flowSet * m_flowNom. m_flowSet </code>is logically between 0 and 1, but any value is possible, as shown in the provided Example.</p>
<p>The model calculates the electricity consumption of the pump in a very simplified way: a fixed pressure drop and an efficiency are given as parameters, and the electricity consumption is computed as:</p>
<pre>PEl&nbsp;=&nbsp;m_flow&nbsp;/&nbsp;medium.rho&nbsp;*&nbsp;dpFix&nbsp;/&nbsp;etaTot;</pre>
<h4>Assumptions and limitations </h4>
<ol>
<li>This model does not specify a relation between pressure and flowrate, the flowrate is IMPOSED</li>
<li>If the water content of the pump, m, is zero, there are no thermal dynamics. </li>
<li>The electricity consumption is computed based on a FIXED efficiency and FIXED pressure drop AS PARAMETERS</li>
<li>The inefficiency of the pump does NOT lead to an enthalpy increase of the outlet flow.</li>
</ol>
<h4>Model use</h4>
<ol>
<li>Decide if the pump will be controlled through an input or if the flowrate is a constant</li>
<li>Set medium and water content of the pump</li>
<li>Specify the parameters for computing the electricity consumption</li>
</ol>
<h4>Validation </h4>
<p>None</p>
<h4>Example </h4>
<p>An example in which this model is used is the <a href=\"modelica://IDEAS.Thermal.Components.Examples.HydraulicCircuit\">HydraulicCircuit</a>.</p>
</html>", revisions="<html>
<p><ul>
<li>December 2014, Filip Jorissen, merged Pump, Pump_HeatPort and Pump_Insulated into one model</li>
<li>April 2014, Damien Picard, add a filter to the input of pump, to avoid singularities with pulse controller.</li>
<li>March 2014, Filip Jorissen, Annex60 compatibility</li>
<li>2013, Roel De Coninck, documentation</li>
<li>2012, Ruben Baetens, changed graphics</li>
<li>2010, Roel De Coninck, First version</li>
</ul></p>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={
        Ellipse(
          extent={{-60,60},{60,-60}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
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
          lineColor={0,0,127},
          fillColor={0,127,255},
          fillPattern=FillPattern.Solid)}),
    Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{100,
            100}}), graphics));
end Pump;

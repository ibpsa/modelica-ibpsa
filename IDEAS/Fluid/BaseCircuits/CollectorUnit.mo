within IDEAS.Fluid.BaseCircuits;
model CollectorUnit "Collector unit"

  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
    "Medium in the component"
    annotation (__Dymola_choicesAllMatching=true);

  //Extensions
  extends IDEAS.Fluid.Interfaces.FourPort(
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium,
    final allowFlowReversal1 = allowFlowReversal,
    final allowFlowReversal2 = allowFlowReversal);
  extends IDEAS.Fluid.Interfaces.LumpedVolumeDeclarations;

  parameter Boolean allowFlowReversal=true
    "= true to allow flow reversal, false restricts to design direction (port_a -> port_b)"
    annotation(Dialog(tab="Assumptions"));
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal
    "Nominal mass flow rate"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.MassFlowRate m_flow_small(min=0) = 1E-4*abs(m_flow_nominal)
    "Small mass flow rate for regularization of zero flow";

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
  FixedResistances.SplitterFixedResistanceDpM spl_supply(redeclare package
      Medium =                                                                      Medium,
    m_flow_nominal={m_flow_nominal,-m_flow_nominal,-m_flow_nominal},
    dp_nominal={0,0,0},
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial)
    annotation (Placement(transformation(extent={{-70,70},{-50,50}})));
  FixedResistances.SplitterFixedResistanceDpM spl_return(redeclare package
      Medium =                                                                      Medium,
    m_flow_nominal={-m_flow_nominal,m_flow_nominal,m_flow_nominal},
    dp_nominal={0,0,0},
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial)
    annotation (Placement(transformation(extent={{50,-50},{70,-70}})));
equation
  connect(port_a1, spl_supply.port_1) annotation (Line(
      points={{-100,60},{-70,60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(port_b3, spl_supply.port_3) annotation (Line(
      points={{-60,100},{-60,70}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(spl_supply.port_2, port_b1) annotation (Line(
      points={{-50,60},{100,60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(port_b2, spl_return.port_1) annotation (Line(
      points={{-100,-60},{50,-60}},
      color={0,127,255},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(spl_return.port_2, port_a2) annotation (Line(
      points={{70,-60},{100,-60}},
      color={0,127,255},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(port_a3, spl_return.port_3) annotation (Line(
      points={{60,100},{60,-50}},
      color={0,127,255},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Documentation(revisions="<html>
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
          color={0,0,127},
          smooth=Smooth.None,
          pattern=LinePattern.Dash),
        Line(
          points={{-100,60},{-60,60},{-60,100}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{-60,60},{100,60}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{60,100},{60,-60}},
          color={0,0,127},
          smooth=Smooth.None,
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

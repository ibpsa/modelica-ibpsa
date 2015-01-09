within IDEAS.Fluid.BaseCircuits;
model CircuitEnd "Ending circucit"
//  extends IDEAS.Fluid.Interfaces.FourPort;
  extends IDEAS.Fluid.Interfaces.LumpedVolumeDeclarations;

  // Twoport instead of fourport

  parameter Boolean allowFlowReversal1 = false
    "= true to allow flow reversal in medium 1, false restricts to design direction (port_a -> port_b)"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);

  parameter Modelica.SIunits.SpecificEnthalpy h_outflow_a1_start = Medium.h_default
    "Start value for enthalpy flowing out of port a1"
    annotation (Dialog(tab="Advanced", group="Initialization"));

  parameter Modelica.SIunits.SpecificEnthalpy h_outflow_b2_start = Medium.h_default
    "Start value for enthalpy flowing out of port b1"
    annotation (Dialog(tab="Advanced", group="Initialization"));

  Modelica.Fluid.Interfaces.FluidPort_a port_a1(
                     redeclare final package Medium = Medium,
                     m_flow(min=if allowFlowReversal1 then -Modelica.Constants.inf else 0),
                     h_outflow(start=h_outflow_a1_start))
    "Fluid connector a1 (positive design flow direction is from port_a1 to port_b1)"
    annotation (Placement(transformation(extent={{-110,50},{-90,70}},
            rotation=0)));

  Modelica.Fluid.Interfaces.FluidPort_b port_b2(
                     redeclare final package Medium = Medium,
                     m_flow(max=if allowFlowReversal1 then +Modelica.Constants.inf else 0),
                     h_outflow(start=h_outflow_b2_start))
    "Fluid connector b2 (positive design flow direction is from port_a2 to port_b2)"
    annotation (Placement(transformation(extent={{-90,-70},{-110,-50}},
                          rotation=0),
                iconTransformation(extent={{-90,-70},{-110,-50}})));

  parameter SI.Mass m=1 "Mass of medium";
  parameter Boolean dynamicBalance=true
    "Set to true to use a dynamic balance, which often leads to smaller systems of equations"
    annotation(Dialog(tab="Dynamics", group="Equations"));
  parameter Boolean allowFlowReversal=true
    "= true to allow flow reversal, false restricts to design direction (port_a -> port_b)"
    annotation(Dialog(tab="Assumptions"));

  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
    "Medium in the component"
    annotation (__Dymola_choicesAllMatching=true);
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal
    "Nominal mass flow rate"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.MassFlowRate m_flow_small(min=0) = 1E-4*abs(m_flow_nominal)
    "Small mass flow rate for regularization of zero flow";

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Documentation(revisions="<html>
<p><ul>
<li>November 2014 by Filip Jorissen:<br> 
Initial version</li>
</ul></p>
</html>", info="<html>
<p>Closed circuit end - no mass flow</p>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}),
        graphics={
        Polygon(
          points={{-20,-50},{-20,-70},{-40,-60},{-20,-50}},
          lineColor={0,0,127},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-20,70},{-20,50},{-40,60},{-20,70}},
          lineColor={0,0,127},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-40,60},{-100,60}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{-40,-60},{-100,-60}},
          color={0,0,127},
          smooth=Smooth.None,
          pattern=LinePattern.Dash),
        Polygon(
          points={{-60,-50},{-60,-70},{-40,-60},{-60,-50}},
          lineColor={0,0,127},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-60,70},{-60,50},{-40,60},{-60,70}},
          lineColor={0,0,127},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-14,70},{-14,50}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{-14,-50},{-14,-70}},
          color={0,0,127},
          smooth=Smooth.None)}));
end CircuitEnd;

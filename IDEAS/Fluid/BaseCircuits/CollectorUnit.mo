within IDEAS.Fluid.BaseCircuits;
model CollectorUnit "Collector unit"
  extends IDEAS.Fluid.Interfaces.FourPort;
  extends IDEAS.Fluid.Interfaces.LumpedVolumeDeclarations;

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

  FixedResistances.LosslessPipe pip(m_flow_nominal=m_flow_nominal,
    redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
  FixedResistances.LosslessPipe pip3(m_flow_nominal=m_flow_nominal,
    redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{60,-70},{40,-50}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a3(
                     redeclare final package Medium = Medium1,
                     m_flow(min=if allowFlowReversal1 then -Modelica.Constants.inf else 0),
                     h_outflow(start=h_outflow_a1_start))
    "Fluid connector a1 (positive design flow direction is from port_a1 to port_b1)"
    annotation (Placement(transformation(extent={{50,90},{70,110}},
            rotation=0)));
  Modelica.Fluid.Interfaces.FluidPort_b port_b3(
                     redeclare final package Medium = Medium2,
                     m_flow(max=if allowFlowReversal2 then +Modelica.Constants.inf else 0),
                     h_outflow(start=h_outflow_b2_start))
    "Fluid connector b2 (positive design flow direction is from port_a2 to port_b2)"
    annotation (Placement(transformation(extent={{-50,90},{-70,110}},
                          rotation=0),
                iconTransformation(extent={{-50,90},{-70,110}})));
equation
  connect(pip3.port_a, port_a2) annotation (Line(
      points={{60,-60},{100,-60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pip3.port_b, port_b2) annotation (Line(
      points={{40,-60},{-100,-60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(port_a1, pip.port_a) annotation (Line(
      points={{-100,60},{-60,60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(port_b3, pip.port_a) annotation (Line(
      points={{-60,100},{-60,60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pip.port_b, port_b1) annotation (Line(
      points={{-40,60},{100,60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(port_a3, pip3.port_a) annotation (Line(
      points={{60,100},{60,-60}},
      color={0,127,255},
      smooth=Smooth.None));
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
          smooth=Smooth.None),
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
          smooth=Smooth.None),
        Ellipse(
          extent={{-62,62},{-58,58}},
          lineColor={0,0,127},
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{58,-58},{62,-62}},
          lineColor={0,0,127},
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid)}));
end CollectorUnit;

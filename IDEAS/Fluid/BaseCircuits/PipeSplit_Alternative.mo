within IDEAS.Fluid.BaseCircuits;
model PipeSplit_Alternative
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

  FixedResistances.Pipe pipe_a(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    m=m/2,
    energyDynamics=energyDynamics,
    massDynamics=massDynamics,
    p_start=p_start,
    T_start=T_start,
    X_start=X_start,
    C_start=C_start,
    C_nominal=C_nominal,
    mFactor=mFactor,
    allowFlowReversal=allowFlowReversal,
    dynamicBalance=dynamicBalance,
    m_flow_small=m_flow_small,
    show_T=false) annotation (Placement(transformation(
        extent={{-10,-4},{10,4}},
        rotation=0,
        origin={-78,60})));
  FixedResistances.Pipe pipe_b(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    m=m/2,
    energyDynamics=energyDynamics,
    massDynamics=massDynamics,
    p_start=p_start,
    T_start=T_start,
    X_start=X_start,
    C_start=C_start,
    C_nominal=C_nominal,
    mFactor=mFactor,
    allowFlowReversal=allowFlowReversal,
    dynamicBalance=dynamicBalance,
    m_flow_small=m_flow_small,
    show_T=false) annotation (Placement(transformation(
        extent={{10,-4},{-10,4}},
        rotation=0,
        origin={80,-60})));

  Modelica.Fluid.Interfaces.FluidPort_a port_a3(
                     redeclare final package Medium = Medium1,
                     m_flow(min=if allowFlowReversal1 then -Modelica.Constants.inf else 0),
                     h_outflow(start=h_outflow_a1_start))
    "Fluid connector a1 (positive design flow direction is from port_a1 to port_b1)"
    annotation (Placement(transformation(extent={{50,90},{70,110}},
            rotation=0)));
  Modelica.Fluid.Interfaces.FluidPort_b port_b3(
                     redeclare final package Medium = Medium1,
                     m_flow(max=if allowFlowReversal1 then +Modelica.Constants.inf else 0),
                     h_outflow(start=h_outflow_b1_start))
    "Fluid connector b1 (positive design flow direction is from port_a1 to port_b1)"
    annotation (Placement(transformation(extent={{-50,90},{-70,110}},rotation=
             0), iconTransformation(extent={{-50,90},{-70,110}})));
equation
  connect(port_a1, pipe_a.port_a) annotation (Line(
      points={{-100,60},{-88,60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pipe_b.port_a, port_a2) annotation (Line(
      points={{90,-60},{100,-60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pipe_a.port_b, port_b1) annotation (Line(
      points={{-68,60},{100,60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(port_a3, pipe_b.port_b) annotation (Line(
      points={{60,100},{60,-60},{70,-60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pipe_b.port_b, port_b2) annotation (Line(
      points={{70,-60},{-100,-60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pipe_a.port_b, port_b3) annotation (Line(
      points={{-68,60},{-60,60},{-60,100}},
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
          points={{-102,60},{100,60}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{-60,100},{-60,60}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{60,100},{60,98},{60,-60},{-98,-60}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{60,-60},{100,-60}},
          color={0,0,255},
          smooth=Smooth.None),
        Ellipse(
          extent={{-64,64},{-56,56}},
          lineColor={0,0,255},
          fillPattern=FillPattern.Solid,
          fillColor={0,0,255}),
        Ellipse(
          extent={{56,-56},{64,-64}},
          lineColor={0,0,255},
          fillPattern=FillPattern.Solid,
          fillColor={0,0,255})}));
end PipeSplit_Alternative;

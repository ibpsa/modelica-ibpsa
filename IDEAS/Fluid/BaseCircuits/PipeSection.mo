within IDEAS.Fluid.BaseCircuits;
model PipeSection
  extends IDEAS.Fluid.BaseCircuits.BaseClasses.FourPort;
  extends IDEAS.Fluid.Interfaces.LumpedVolumeDeclarations;

  parameter SI.Mass m=1 "Mass of medium";
  parameter Boolean dynamicBalance=true
    "Set to true to use a dynamic balance, which often leads to smaller systems of equations"
    annotation(Dialog(tab="Dynamics", group="Equations"));
  parameter Boolean allowFlowReversal=true
    "= true to allow flow reversal, false restricts to design direction (port_a -> port_b)"
    annotation(Dialog(tab="Assumptions"));

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
        rotation=90,
        origin={-40,0})));
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
        rotation=90,
        origin={40,0})));

equation
  connect(pipe_a.port_a, fluidTwoPort_b.port_a) annotation (Line(
      points={{-40,-10},{-40,-100},{0,-100}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pipe_b.port_b, fluidTwoPort_b.port_b) annotation (Line(
      points={{40,-10},{40,-100},{0,-100}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pipe_a.port_b, fluidTwoPort_a.port_a) annotation (Line(
      points={{-40,10},{-40,100},{0,100}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pipe_b.port_a, fluidTwoPort_a.port_b) annotation (Line(
      points={{40,10},{40,100},{0,100}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Documentation(revisions="<html>
<p><ul>
<li>November 2014 by Filip Jorissen:<br> 
Initial version</li>
</ul></p>
</html>"));
end PipeSection;

within IDEAS.Fluid.Interfaces.Partials;
partial model PartialTwoPort
  "Partial model of two port without internal connections"
  extends IDEAS.Fluid.Interfaces.LumpedVolumeDeclarations(redeclare
      replaceable package Medium =
        IDEAS.Media.Water);
  extends IDEAS.Fluid.Interfaces.PartialTwoPortInterface(redeclare replaceable
      package Medium =
        IDEAS.Media.Water);

  parameter Modelica.SIunits.Mass m(start=1) = 1 "Mass of medium";
  parameter Boolean dynamicBalance = true
    "Set to true to use a dynamic balance, which often leads to smaller systems of equations"
    annotation (Evaluate=true, Dialog(tab="Dynamics", group="Equations"));

  IDEAS.Fluid.MixingVolumes.MixingVolume vol(
    redeclare package Medium = Medium,
    energyDynamics=if dynamicBalance then energyDynamics else Modelica.Fluid.Types.Dynamics.SteadyState,
    massDynamics=if dynamicBalance then massDynamics else Modelica.Fluid.Types.Dynamics.SteadyState,
    T_start=T_start,
    X_start=X_start,
    C_start=C_start,
    m_flow_nominal=m_flow_nominal,
    p_start=p_start,
    allowFlowReversal=allowFlowReversal,
    nPorts=1,
    final V=m/Medium.density(Medium.setState_phX(Medium.p_default, Medium.h_default, Medium.X_default)),
    C_nominal=C_nominal,
    mSenFac=mSenFac,
    m_flow_small=m_flow_small)
    annotation (Placement(transformation(extent={{-44,0},{-64,20}})));

equation
  connect(port_a, vol.ports[1]) annotation (Line(
      points={{-100,0},{-54,0}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (Documentation(info="<html>
</html>", revisions="<html>
<ul>
<li>
March 2014 by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>"), Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                         graphics));
end PartialTwoPort;

within IDEAS.Fluid.Interfaces.Partials;
model PipeTwoPort "Two port containing a volume and pressure drop"
  extends IDEAS.Fluid.Interfaces.Partials.PartialTwoPort(vol(nPorts=2));
  extends IDEAS.Fluid.Interfaces.TwoPortFlowResistanceParameters(
    dp_nominal = 0);

  IDEAS.Fluid.FixedResistances.PressureDrop res(
    redeclare package Medium = Medium,
    final m_flow_nominal=m_flow_nominal,
    final deltaM=deltaM,
    final allowFlowReversal=allowFlowReversal,
    final show_T=false,
    final from_dp=from_dp,
    final linearized=linearizeFlowResistance,
    final homotopyInitialization=homotopyInitialization,
    final dp_nominal=if computeFlowResistance then dp_nominal else 0)
    annotation (Placement(transformation(extent={{4,-10},{24,10}})));
  //Advanced settings: based on IDEAS.Fluid.Interfaces.TwoPortHeatMassExchanger
  parameter Boolean homotopyInitialization = true "= true, use homotopy method"
    annotation(Evaluate=true, Dialog(tab="Advanced"));
equation
  connect(vol.ports[2], res.port_a) annotation (Line(
      points={{-54,0},{4,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(res.port_b, port_b) annotation (Line(
      points={{24,0},{100,0}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Documentation(revisions="<html>
<ul>
<li>
March 2014 by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>"));
end PipeTwoPort;

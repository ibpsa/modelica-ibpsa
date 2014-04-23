within IDEAS.Fluid.Interfaces.Partials;
partial model PumpTwoPort
  extends PartialTwoPort(vol(nPorts=2, prescribedHeatFlowRate=true));
    Modelica.SIunits.HeatFlowRate Q_flow(start=0) "Heat exchange with ambient";
  IDEAS.Fluid.Interfaces.IdealSource idealSource(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{8,-10},{28,10}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow
    annotation (Placement(transformation(extent={{-60,80},{-40,100}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=Q_flow)
    annotation (Placement(transformation(extent={{-90,80},{-70,100}})));
equation
  connect(idealSource.port_a, vol.ports[2]) annotation (Line(
      points={{8,0},{-54,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(idealSource.port_b, port_b) annotation (Line(
      points={{28,0},{100,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(realExpression.y,prescribedHeatFlow. Q_flow) annotation (Line(
      points={{-69,90},{-60,90}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(prescribedHeatFlow.port, vol.heatPort) annotation (Line(
      points={{-40,90},{-34,90},{-34,10},{-44,10}},
      color={191,0,0},
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
end PumpTwoPort;

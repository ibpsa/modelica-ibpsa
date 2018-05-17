within IDEAS.Fluid.Interfaces.Partials;
partial model TwoPort "Partial model of two port"
  extends IDEAS.Fluid.Interfaces.Partials.PartialTwoPort(vol(nPorts=2));
  Modelica.SIunits.HeatFlowRate Q_flow(start=0) "Heat exchange with ambient";
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow
    annotation (Placement(transformation(extent={{-60,80},{-40,100}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=Q_flow)
    annotation (Placement(transformation(extent={{-90,80},{-70,100}})));
equation
  connect(vol.ports[2], port_b) annotation (Line(
      points={{-54,0},{100,0}},
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
  annotation (Documentation(info="<html>
</html>", revisions="<html>
<ul>
<li>
March 2014 by Filip Jorissen:<br/>
Annex60 compatibility
</li>
</ul>
</html>"), Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                         graphics));
end TwoPort;

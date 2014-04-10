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
<p><b>General description</b> </p>
<p><h5>Goal</h5></p>
<p>Partial model with two flowPorts.</p>
<p><h5>Description </h5></p>
<p>This model is deviated from Modelica.Thermal.FluidHeatFlow.Interfaces.Partials.TwoPort</p>
<p>Possible heat exchange with the ambient is defined by Q_flow; setting this = 0 means no energy exchange.</p>
<p>Setting parameter m (mass of medium within component) to zero leads to neglection of temperature transient cv*m*der(T).</p>
<p>Mass flow can go in both directions, the temperature T is mapped to the outlet temperature. Mixing rule is applied. </p>
<p><h5>Assumptions and limitations </h5></p>
<p><ol>
<li>This model makes assumption of mass balance: outlet flowrate = inlet flowrate</li>
<li>This model includes the energy balance equation as a first order differential equation,<b> unless m=0</b></li>
</ol></p>
<p><h4>Parameters</h4></p>
<p>Partial model, see extensions for implementation details.</p>
<p><h4>Validation </h4></p>
<p>Based on physical principles, no validation performed.</p>
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

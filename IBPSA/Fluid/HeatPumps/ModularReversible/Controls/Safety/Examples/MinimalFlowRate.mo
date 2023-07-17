within IBPSA.Fluid.HeatPumps.ModularReversible.Controls.Safety.Examples;
model MinimalFlowRate
  "Example for usage of minimal flow rate safety control"
  extends BaseClasses.PartialSafety;
  extends Modelica.Icons.Example;
  IBPSA.Fluid.HeatPumps.ModularReversible.Controls.Safety.MinimalFlowRate minFloRatSaf(
      mEvaMin_flow=0.1, mConMin_flow=0.1)
    "Safety block for minimal flow rate safety"
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
  Modelica.Blocks.Sources.Pulse ySetPul(amplitude=1, period=50)
    "Pulse signal for ySet"
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
  Modelica.Blocks.Sources.Pulse mFlowConEmu(amplitude=1, period=20)
    "Emulator for condenser mass flow rate"
    annotation (Placement(transformation(extent={{-100,-20},{-80,0}})));
  Modelica.Blocks.Sources.Pulse mFlowEvaEmu(amplitude=1, period=15)
    "Emulator for evaporator mass flow rate"
    annotation (Placement(transformation(extent={{-100,-60},{-80,-40}})));
equation
  connect(sigBus, minFloRatSaf.sigBus) annotation (Line(
      points={{-50,-52},{-54,-52},{-54,4},{-2.5,4},{-2.5,2.9}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(minFloRatSaf.yOut, hys.u) annotation (Line(points={{23,12},{46,12},{46,
          -50},{22,-50}}, color={0,0,127}));
  connect(ySetPul.y, minFloRatSaf.ySet) annotation (Line(points={{-79,30},{-50,30},
          {-50,12},{-3.6,12}}, color={0,0,127}));
  connect(mFlowConEmu.y, sigBus.m_flowConMea) annotation (Line(points={{-79,-10},
          {-50,-10},{-50,-52}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(mFlowEvaEmu.y, sigBus.m_flowEvaMea) annotation (Line(points={{-79,-50},
          {-50,-50},{-50,-52}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(minFloRatSaf.yOut, yOut) annotation (Line(points={{23,12},{46,12},{46,
          -40},{110,-40}}, color={0,0,127}));
  connect(ySetPul.y, ySet) annotation (Line(points={{-79,30},{26,30},{26,40},{110,
          40}}, color={0,0,127}));
  annotation (
      Documentation(info="<html>
<p>
  This example shows the usage of the model
  <a href=\"modelica://IBPSA.Fluid.HeatPumps.ModularReversible.Controls.Safety.MinimalFlowRate\">
  IBPSA.Fluid.HeatPumps.ModularReversible.Controls.Safety.MinimalFlowRate</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
  <i>October 2, 2022</i> by Fabian Wuellhorst:<br/>
  First implementation (see issue <a href=
  \"https://github.com/ibpsa/modelica-ibpsa/issues/1576\">#1576</a>)
</li>
</ul>
</html>"), experiment(
      StopTime=100,
      Interval=1));
end MinimalFlowRate;

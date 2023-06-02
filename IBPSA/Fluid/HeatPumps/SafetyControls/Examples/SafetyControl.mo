within IBPSA.Fluid.HeatPumps.SafetyControls.Examples;
model SafetyControl "Example for usage of all safety controls"
  extends BaseClasses.PartialSafetyControlExample;
  extends Modelica.Icons.Example;
  IBPSA.Fluid.HeatPumps.SafetyControls.SafetyControl safCtr(
    mEva_flow_nominal=0.01,
    mCon_flow_nominal=0.01,
    ySet_small=0.01,
    forHeaPum=true,
    redeclare
      IBPSA.Fluid.HeatPumps.SafetyControls.RecordsCollection.DefaultHeatPumpSafetyControl
      safCtrPar(
      minRunTime=5,
      minLocTime=5,
      use_antFre=true,
      TAntFre=276.15)) "Safety control"
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
  Modelica.Blocks.Sources.Pulse ySetPul(amplitude=1, period=50)
    "Pulse signal for ySet"
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
  Modelica.Blocks.Sources.Pulse TConInEmu(
    amplitude=-10,
    period=20,
    offset=283.15) "Emulator for condenser inlet temperature"
    annotation (Placement(transformation(extent={{-100,-20},{-80,0}})));
  Modelica.Blocks.Sources.Pulse TEvaOutEmu(
    amplitude=-10,
    period=15,
    offset=283.15) "Emulator for evaporator outlet temperature"
    annotation (Placement(transformation(extent={{-100,-60},{-80,-40}})));
  Modelica.Blocks.Sources.Pulse TConOutEmu(
    amplitude=40,
    period=20,
    offset=303.15) "Emulator for condenser outlet temperature"
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
  Modelica.Blocks.Sources.Pulse TEvaInEmu(
    amplitude=-10,
    period=15,
    offset=283.15) "Emulator for evaporator inlet temperature"
    annotation (Placement(transformation(extent={{-60,-100},{-40,-80}})));
  Modelica.Blocks.Sources.Pulse mFlowConEmu(
    amplitude=1,
    width=80,
    period=100)
    "Emulator for condenser mass flow rate"
    annotation (Placement(transformation(extent={{20,-100},{40,-80}})));
  Modelica.Blocks.Sources.Pulse mFlowEvaEmu(amplitude=1, period=100)
    "Emulator for evaporator mass flow rate"
    annotation (Placement(transformation(extent={{-20,-100},{0,-80}})));
equation
  connect(safCtr.sigBus, sigBus) annotation (Line(
      points={{-2.5,2.9},{-50,2.9},{-50,-52}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(ySetPul.y, safCtr.ySet) annotation (Line(points={{-79,30},{-8,30},{-8,
          12},{-3.6,12}}, color={0,0,127}));
  connect(TEvaOutEmu.y, sigBus.TEvaOutMea) annotation (Line(points={{-79,-50},{
          -50,-50},{-50,-52}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(TConInEmu.y, sigBus.TConInMea) annotation (Line(points={{-79,-10},{
          -50,-10},{-50,-52}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(hys.u, safCtr.yOut) annotation (Line(points={{22,-50},{44,-50},{44,12},
          {23,12}}, color={0,0,127}));
  connect(safCtr.yOut, yOut) annotation (Line(points={{23,12},{44,12},{44,-40},
          {110,-40}}, color={0,0,127}));
  connect(ySetPul.y, ySet) annotation (Line(points={{-79,30},{-8,30},{-8,40},{
          110,40}}, color={0,0,127}));
  connect(TConOutEmu.y, sigBus.TConOutMea) annotation (Line(points={{-79,-90},{
          -70,-90},{-70,-50},{-60,-50},{-60,-52},{-50,-52}}, color={0,0,127}),
      Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(TEvaInEmu.y, sigBus.TEvaInMea) annotation (Line(points={{-39,-90},{
          -34,-90},{-34,-52},{-50,-52}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(mFlowEvaEmu.y, sigBus.m_flowEvaMea) annotation (Line(points={{1,-90},
          {4,-90},{4,-64},{-50,-64},{-50,-52}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(mFlowConEmu.y, sigBus.m_flowConMea) annotation (Line(points={{41,-90},
          {50,-90},{50,-64},{-50,-64},{-50,-52}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  annotation (Documentation(info="<html>
<p>
  This example shows the usage and effect of 
  all safety controls aggregates into the model
  <a href=\"modelica://IBPSA.Fluid.HeatPumps.SafetyControls.SafetyControl\">
  IBPSA.Fluid.HeatPumps.SafetyControls.SafetyControl</a>.
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
end SafetyControl;

within IBPSA.Fluid.HeatPumps.Controls.SafetyControls.Examples;
model OperationalEnvelope "Example for usage of operational envelope model"
  extends BaseClasses.PartialSafetyControlExample;
  extends Modelica.Icons.Example;
  IBPSA.Fluid.HeatPumps.Controls.SafetyControls.OperationalEnvelope opeEnv(
    tabUppHea=[-40,60; 40,60],
    tabLowCoo=[-40,15; 40,15],
    forHeaPum=true) "Safety control for operational envelope"
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
  Modelica.Blocks.Sources.Constant
                                ySetPul(k=1) "Always on"
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
  Modelica.Blocks.Sources.Trapezoid
                                TConOutEmu(
    amplitude=60,
    rising=5,
    width=20,
    falling=5,
    period=50,
    offset=283.15) "Emulator for condenser outlet temperature"
    annotation (Placement(transformation(extent={{-100,-20},{-80,0}})));
  Modelica.Blocks.Sources.Pulse TEvaInEmu(
    amplitude=-10,
    period=15,
    offset=283.15) "Emulator for evaporator inlet temperature"
    annotation (Placement(transformation(extent={{-100,-60},{-80,-40}})));
  Modelica.Blocks.Sources.BooleanStep hea(startTime=50, startValue=true)
    "Heating mode"
    annotation (Placement(transformation(extent={{-100,60},{-80,80}})));
equation
  connect(opeEnv.sigBus, sigBus) annotation (Line(
      points={{-2.5,2.9},{-50,2.9},{-50,-52}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(ySetPul.y, opeEnv.ySet) annotation (Line(points={{-79,30},{-8,30},{-8,
          12},{-3.6,12}}, color={0,0,127}));
  connect(hys.u, opeEnv.yOut) annotation (Line(points={{22,-50},{44,-50},{44,12},
          {23,12}}, color={0,0,127}));
  connect(opeEnv.yOut, yOut) annotation (Line(points={{23,12},{44,12},{44,-40},
          {110,-40}}, color={0,0,127}));
  connect(ySetPul.y, ySet) annotation (Line(points={{-79,30},{-8,30},{-8,40},{
          110,40}}, color={0,0,127}));
  connect(TConOutEmu.y, sigBus.TConOutMea) annotation (Line(points={{-79,-10},{
          -50,-10},{-50,-52}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(TEvaInEmu.y, sigBus.TEvaInMea) annotation (Line(points={{-79,-50},{
          -52,-50},{-52,-52},{-50,-52}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(hea.y, sigBus.hea) annotation (Line(points={{-79,70},{-50,70},{-50,
          -52}}, color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  annotation (Documentation(info="<html>
<p>
  This example shows the usage of the model
  <a href=\"modelica://IBPSA.Fluid.HeatPumps.Controls.SafetyControls.OperationalEnvelope\">
  IBPSA.Fluid.HeatPumps.SafetyControls.OperationalEnvelope</a>.
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
end OperationalEnvelope;

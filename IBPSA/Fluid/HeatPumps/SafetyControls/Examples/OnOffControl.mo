within IBPSA.Fluid.HeatPumps.SafetyControls.Examples;
model OnOffControl "Example for on off controller"
  extends BaseClasses.PartialSafetyControlExample(hys(pre_y_start=true));
  extends Modelica.Icons.Example;

  IBPSA.Fluid.HeatPumps.SafetyControls.OnOffControl onOffCtr(
    maxRunPerHou=4,
    minLocTime(displayUnit="s") = 200,
    minRunTime(displayUnit="s") = 444,
    preYSet_start=false,
    use_minLocTime=true,
    use_minRunTime=false,
    use_runPerHou=true,
    ySet_small=hys.uHigh,
    ySetMin=0.5) "Example case for on off control"
    annotation (Placement(transformation(extent={{0,0},{20,20}})));

  Modelica.Blocks.Sources.Sine ySetSin(
    amplitude=0.5,
    f=1/180,
    offset=0.5) "Sinus signal for ySet"
    annotation (Placement(transformation(extent={{-100,0},{-80,20}})));
equation
  connect(onOffCtr.yOut, hys.u) annotation (Line(points={{23,12},{42,12},{42,
          -50},{22,-50}},     color={0,0,127}));
  connect(onOffCtr.sigBus, sigBus) annotation (Line(
      points={{-2.5,2.9},{-50,2.9},{-50,-52}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
  connect(ySetSin.y, onOffCtr.ySet) annotation (Line(points={{-79,10},{-4,10},{
          -4,12},{-3.6,12}}, color={0,0,127}));
  connect(ySetSin.y, ySet) annotation (Line(points={{-79,10},{-56,10},{-56,40},
          {110,40}}, color={0,0,127}));
  connect(onOffCtr.yOut, yOut) annotation (Line(points={{23,12},{42,12},{42,-40},
          {110,-40}}, color={0,0,127}));
  annotation (Documentation(info="<html>
<p>
  This example shows the usage of the model
  <a href=\"IBPSA.Fluid.HeatPumps.SafetyControls.OnOffControl\">
  IBPSA.Fluid.HeatPumps.SafetyControls.OnOffControl</a>.
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
      StopTime=1000,
      Interval=1,
      __Dymola_Algorithm="Dassl"));
end OnOffControl;

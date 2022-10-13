within IBPSA.Fluid.HeatPumps.SafetyControls.Examples;
model OnOffControl "Example for on off controller"
  extends BaseClasses.PartialSafetyControlExample;
  extends Modelica.Icons.Example;

  IBPSA.Fluid.HeatPumps.SafetyControls.OnOffControl onOffCtr(
    maxRunPerHou=4,
    minLocTime(displayUnit="s") = 200,
    minRunTime(displayUnit="s") = 444,
    preYSet_start=false,
    use_minLocTime=true,
    use_minRunTime=true,
    use_runPerHou=true,
    ySet_small=hys.uHigh,
    ySetMin=0.5) "Example case for on off control"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}})));

  Modelica.Blocks.Sources.Pulse pul(
    amplitude=1,
    period=100,
    offset=0) "Pulse signal for ySet"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Modelica.Blocks.Interfaces.RealOutput ySet
    "Relative speed of compressor. From 0 to 1"
    annotation (Placement(transformation(extent={{100,-6},{120,14}})));
equation
  connect(onOffCtr.yOut, hys.u) annotation (Line(points={{18.3333,3.33333},{60,
          3.33333},{60,-50},{22,-50}},
                              color={0,0,127}));
  connect(onOffCtr.sigBus, sigBus) annotation (Line(
      points={{-17.5,-11.8333},{-17.5,-10},{-50,-10},{-50,-52}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
  connect(pul.y, onOffCtr.ySet) annotation (Line(points={{-59,30},{-30,30},{-30,
          3.33333},{-19.3333,3.33333}}, color={0,0,127}));
  connect(onOffCtr.yOut, ySet) annotation (Line(points={{18.3333,3.33333},{
          18.3333,4},{110,4}},
                       color={0,0,127}));
  annotation (experiment(
      StopTime=7200,
      Interval=100), Documentation(info="<html>
      <p>Example for the model <a href=\"modelica://IBPSA.Fluid.HeatPumps.SafetyControls.OnOffControl\">
      IBPSA.Fluid.HeatPumps.SafetyControls.OnOffControl</a>.</p>
</html>"));
end OnOffControl;

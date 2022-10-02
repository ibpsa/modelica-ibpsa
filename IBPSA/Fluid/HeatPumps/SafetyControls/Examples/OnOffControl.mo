within IBPSA.Fluid.HeatPumps.SafetyControls.Examples;
model OnOffControl "Example for on off controller"
  extends BaseClasses.PartialSafetyControlExample;
  extends Modelica.Icons.Example;

  IBPSA.Fluid.HeatPumps.SafetyControls.OnOffControl onOffControl(
    maxRunPerHou=4,
    minLocTime(displayUnit="s") = 200,
    minRunTime(displayUnit="s") = 444,
    preYSet_start=false,
    use_minLocTime=true,
    use_minRunTime=true,
    use_runPerHou=true,
    ySet_small=hys.uHigh,
    ySetMin=0.5)
    annotation (Placement(transformation(extent={{-20,-20},{20,20}})));

  Modelica.Blocks.Sources.Pulse pulse(
    amplitude=1,
    period=100,
    offset=0)
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Modelica.Blocks.Interfaces.RealOutput ySet
    "Relative speed of compressor. From 0 to 1"
    annotation (Placement(transformation(extent={{100,-6},{120,14}})));
equation
  connect(onOffControl.modeOut, sigBus.modeSet) annotation (Line(points={{21.6667,
          -3.33333},{50,-3.33333},{50,-68},{-50,-68},{-50,-52}},
                                                       color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(onOffControl.yOut, hys.u) annotation (Line(points={{21.6667,3.33333},
          {60,3.33333},{60,-50},{22,-50}},color={0,0,127}));
  connect(booCon.y, onOffControl.modeSet) annotation (Line(points={{-79,-30},{
          -60,-30},{-60,-3.33333},{-22.6667,-3.33333}},
                                                    color={255,0,255}));
  connect(onOffControl.sigBus, sigBus) annotation (Line(
      points={{-21.5,-11.5},{-21.5,-10},{-50,-10},{-50,-52}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
  connect(pulse.y, onOffControl.ySet) annotation (Line(
    points={{-59,30},{-30,30},{-30,3.33333},{-22.6667,3.33333}},
    color={0,0,127}));
  connect(onOffControl.yOut, ySet)
    annotation (Line(points={{21.6667,3.33333},{21.6667,4},{110,4}},
                color={0,0,127}));
  annotation (experiment(
      StopTime=7200,
      Interval=100), Documentation(info="<html>
<p>Example for the model <a href=\"modelica://IBPSA.Fluid.HeatPumps.SafetyControls.OnOffControl\">IBPSA.Fluid.HeatPumps.SafetyControls.OnOffControl</a>.</p>
</html>"));
end OnOffControl;

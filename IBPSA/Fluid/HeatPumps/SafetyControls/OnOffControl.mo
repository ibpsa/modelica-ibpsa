within IBPSA.Fluid.HeatPumps.SafetyControls;
model OnOffControl
  "Controlls if the minimal runtime, stoptime and max. runs per hour are inside given boundaries"
  parameter Boolean use_minRunTime
    "False if minimal runtime of HP is not considered" annotation(choices(checkBox=true));
  parameter Modelica.Units.SI.Time minRunTime(displayUnit="min")
    "Mimimum runtime of heat pump" annotation (Dialog(enable=use_minRunTime));
  parameter Boolean use_minLocTime
    "False if minimal locktime of HP is not considered" annotation(choices(checkBox=true));
  parameter Modelica.Units.SI.Time minLocTime(displayUnit="min")
    "Minimum lock time of heat pump" annotation (Dialog(enable=use_minLocTime));
  parameter Boolean use_runPerHou
    "False if maximal runs per hour of HP are not considered" annotation(choices(checkBox=true));
  parameter Integer maxRunPerHou "Maximal number of on/off cycles in one hour"
    annotation (Dialog(enable=use_runPerHou));
  parameter Boolean pre_n_start=true "Start value of pre(n) at initial time";
  Modelica.Blocks.Logical.GreaterThreshold
                                  ySetGreaterZero(final threshold=Modelica.Constants.eps)
                                                  "True if device is set on"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Modelica.Blocks.Logical.And andRun
    annotation (Placement(transformation(extent={{60,80},{80,100}})));
  Modelica.Blocks.Logical.Pre pre1(final pre_u_start=pre_n_start)
    annotation (Placement(transformation(extent={{-80,-100},{-60,-80}})));
  BaseClasses.RunPerHouBoundary runPerHouBoundary(final maxRunPer_h=
        maxRunPerHou, final delayTime=3600) if use_runPerHou
    annotation (Placement(transformation(extent={{-40,-100},{-20,-80}})));
  BaseClasses.TimeControl locTimControl(final minRunTime=minLocTime)
    if use_minLocTime
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));
  Modelica.Blocks.Logical.Not notIsOn
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  BaseClasses.TimeControl runTimControl(final minRunTime=minRunTime)
    if use_minRunTime
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Modelica.Blocks.Logical.And andLoc
    annotation (Placement(transformation(extent={{40,-40},{60,-20}})));

  Modelica.Blocks.Sources.BooleanConstant booleanConstantRunPerHou(final k=true) if not
    use_runPerHou
    annotation (Placement(transformation(extent={{0,-100},{20,-80}})));
  Modelica.Blocks.Sources.BooleanConstant booleanConstantLocTim(final k=true) if not
    use_minLocTime
    annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));
  Modelica.Blocks.Sources.BooleanConstant booleanConstantRunTim(final k=true) if not
    use_minRunTime
    annotation (Placement(transformation(extent={{40,40},{60,60}})));
  Modelica.Blocks.Logical.Not notSetOn
    annotation (Placement(transformation(extent={{-40,80},{-20,100}})));
  Modelica.Blocks.Logical.And andTurnOff
    "Check if HP is on and is set to be turned off"
    annotation (Placement(transformation(extent={{0,80},{20,100}})));
  Modelica.Blocks.Logical.And andTurnOn
    "Check if HP is Off and is set to be turned on"
    annotation (Placement(transformation(extent={{40,-80},{60,-60}})));
  Modelica.Blocks.Logical.And andIsOn
    "Check if both set and actual value are greater zero"
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
  Modelica.Blocks.Interfaces.RealInput ySet
    "Set value relative speed of compressor. Analog from 0 to 1"
    annotation (Placement(transformation(extent={{-132,-16},{-100,16}})));
  Modelica.Blocks.Interfaces.RealOutput yOut
    "Relative speed of compressor. From 0 to 1"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Interfaces.VapourCompressionMachineControlBus                sigBusHP
    annotation (Placement(transformation(extent={{-116,-88},{-82,-58}})));
  Modelica.Blocks.Logical.Switch       swinOutySet
    "If any of the orySet conditions is true, ySet will be passed. Else nOut will stay the same"
    annotation (Placement(transformation(extent={{72,-10},{92,10}})));
  Modelica.Blocks.MathBoolean.Or orSetN(nu=4)
    "Output is true if ySet value is correct"
    annotation (Placement(transformation(extent={{40,0},{60,20}})));
  Modelica.Blocks.Logical.And andIsOff
    "Check if both set and actual value are equal to zero"
    annotation (Placement(transformation(extent={{0,40},{20,60}})));
  Modelica.Blocks.Logical.And andLocOff
    annotation (Placement(transformation(extent={{80,-60},{100,-40}})));
equation
  connect(pre1.y, runPerHouBoundary.u) annotation (Line(points={{-59,-90},{-42,-90}},
                                   color={255,0,255}));
  connect(pre1.y, notIsOn.u) annotation (Line(points={{-59,-90},{-52,-90},{-52,-54},
          {-88,-54},{-88,-30},{-82,-30}},
                                       color={255,0,255}));
  connect(notIsOn.y, locTimControl.u) annotation (Line(points={{-59,-30},{-52,-30},
          {-52,-10},{-42,-10}},      color={255,0,255}));
  connect(runTimControl.y, andRun.u2) annotation (Line(points={{-19,50},{-14,50},
          {-14,72},{52,72},{52,82},{58,82}},
                                 color={255,0,255},
      pattern=LinePattern.Dash));
  connect(runTimControl.u, pre1.y) annotation (Line(points={{-42,50},{-52,50},{-52,
          -90},{-59,-90}},             color={255,0,255}));
  connect(locTimControl.y, andLoc.u1) annotation (Line(points={{-19,-10},{22,-10},
          {22,-30},{38,-30}},          color={255,0,255},
      pattern=LinePattern.Dash));
  connect(runPerHouBoundary.y, andLoc.u2) annotation (Line(points={{-19,-90},{-4,
          -90},{-4,-68},{28,-68},{28,-38},{38,-38}},
                                        color={255,0,255},
      pattern=LinePattern.Dash));
  connect(booleanConstantRunPerHou.y, andLoc.u2) annotation (Line(
      points={{21,-90},{28,-90},{28,-38},{38,-38}},
      color={255,0,255},
      pattern=LinePattern.Dash));
  connect(booleanConstantRunTim.y, andRun.u2) annotation (Line(
      points={{61,50},{64,50},{64,72},{52,72},{52,82},{58,82}},
      color={255,0,255},
      pattern=LinePattern.Dash));

  connect(ySet,ySetGreaterZero. u) annotation (Line(points={{-116,0},{-94,0},{-94,
          34},{-88,34},{-88,70},{-82,70}},
                            color={0,0,127}));
  connect(ySetGreaterZero.y, notSetOn.u) annotation (Line(points={{-59,70},{-52,
          70},{-52,90},{-42,90}}, color={255,0,255}));
  connect(pre1.y, andIsOn.u2) annotation (Line(points={{-59,-90},{-52,-90},{-52,
          6},{-10,6},{-10,2},{-2,2}}, color={255,0,255}));
  connect(ySetGreaterZero.y, andIsOn.u1) annotation (Line(points={{-59,70},{-52,
          70},{-52,10},{-2,10}},                               color={255,0,255}));
  connect(yOut,yOut)
    annotation (Line(points={{110,0},{110,0}}, color={0,0,127}));
  connect(swinOutySet.y,yOut)
    annotation (Line(points={{93,0},{110,0}},  color={0,0,127}));
  connect(ySet, swinOutySet.u1) annotation (Line(points={{-116,0},{-94,0},{-94,34},
          {66,34},{66,8},{70,8}},       color={0,0,127}));
  connect(andTurnOff.y, andRun.u1) annotation (Line(points={{21,90},{58,90}},
                      color={255,0,255}));
  connect(orSetN.y, swinOutySet.u2)
    annotation (Line(points={{61.5,10},{61.5,0},{70,0}},
                                               color={255,0,255}));
  connect(notSetOn.y, andIsOff.u1) annotation (Line(points={{-19,90},{-12,90},{-12,
          50},{-2,50}},                        color={255,0,255}));
  connect(andIsOff.y, orSetN.u[1]) annotation (Line(points={{21,50},{30,50},{30,
          7.375},{40,7.375}},
                            color={255,0,255}));
  connect(andIsOn.y, orSetN.u[2]) annotation (Line(points={{21,10},{30,10},{30,9.125},
          {40,9.125}},      color={255,0,255}));
  connect(andRun.y, orSetN.u[3]) annotation (Line(points={{81,90},{86,90},{86,32},
          {30,32},{30,10.875},{40,10.875}},
                              color={255,0,255}));
  connect(andLoc.y, andLocOff.u1) annotation (Line(points={{61,-30},{70,-30},{70,
          -50},{78,-50}},      color={255,0,255}));
  connect(andTurnOn.y, andLocOff.u2) annotation (Line(points={{61,-70},{68,-70},
          {68,-58},{78,-58}},       color={255,0,255}));
  connect(andLocOff.y, orSetN.u[4]) annotation (Line(points={{101,-50},{104,-50},
          {104,-12},{30,-12},{30,12.625},{40,12.625}},
                                           color={255,0,255}));
  connect(notSetOn.y, andTurnOff.u2) annotation (Line(points={{-19,90},{-12,90},
          {-12,82},{-2,82}},        color={255,0,255}));
  connect(pre1.y, andTurnOff.u1) annotation (Line(points={{-59,-90},{-52,-90},{-52,
          74},{-10,74},{-10,90},{-2,90}},
                                color={255,0,255}));
  connect(ySetGreaterZero.y, andTurnOn.u2) annotation (Line(points={{-59,70},{-52,
          70},{-52,10},{-12,10},{-12,-78},{38,-78}},           color={255,0,255}));
  connect(notIsOn.y, andTurnOn.u1) annotation (Line(points={{-59,-30},{-4,-30},{
          -4,-54},{30,-54},{30,-70},{38,-70}},     color={255,0,255}));
  connect(notIsOn.y, andIsOff.u2) annotation (Line(points={{-59,-30},{-52,-30},{
          -52,22},{-8,22},{-8,42},{-2,42}},
                                   color={255,0,255}));
  connect(booleanConstantLocTim.y, andLoc.u1) annotation (Line(
      points={{-19,-50},{22,-50},{22,-30},{38,-30}},
      color={255,0,255},
      pattern=LinePattern.Dash));
  connect(pre1.u, sigBusHP.onOffMea) annotation (Line(points={{-82,-90},{-82,-72},
          {-84,-72},{-84,-74},{-86,-74},{-86,-73},{-99,-73}},
                                    color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));

  connect(swinOutySet.u3, sigBusHP.ySet) annotation (Line(points={{70,-8},{58,
          -8},{58,-14},{108,-14},{108,-114},{-99,-114},{-99,-73}}, color={0,0,
          127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  annotation (Documentation(info="<html><p>
  Checks if the ySet value is legal by checking if the device can
  either be turned on or off, depending on which state it was in.
</p>
<p>
  E.g. If it is turned on, and the new ySet value is 0, it will only
  turn off if current runtime is longer than the minimal runtime. Else
  it will keep the current rotating speed.
</p>
<ul>
  <li>
    <i>November 26, 2018&#160;</i> by Fabian Wüllhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/RWTH-EBC/AixLib/issues/577\">#577</a>)
  </li>
</ul>
</html>"),
    Diagram(coordinateSystem(extent={{-120,-120},{120,120}})),
    Icon(coordinateSystem(extent={{-120,-120},{120,120}}), graphics={
        Polygon(
          points={{-42,20},{0,62},{-42,20}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-48,-26},{48,66}},
          lineColor={0,0,0},
          fillColor={91,91,91},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-36,-14},{36,54}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-60,20},{60,-80}},
          lineColor={0,0,0},
          fillColor={91,91,91},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-10,-30},{10,-70}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-14,-40},{16,-12}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-104,100},{106,76}},
          lineColor={28,108,200},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.None,
          textString="%name"),
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={28,108,200},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.None)}));
end OnOffControl;

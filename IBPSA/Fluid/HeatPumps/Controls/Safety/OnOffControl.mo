within IBPSA.Fluid.HeatPumps.Controls.Safety;
model OnOffControl
  "Controlls if the minimal runtime, stoptime and max. runs per hour are inside given boundaries"
  extends BaseClasses.PartialSafetyControl;
  parameter Boolean use_minRunTime
    "False if minimal runtime of HP is not considered"
    annotation(choices(checkBox=true));
  parameter Modelica.Units.SI.Time minRunTime(displayUnit="min")
    "Mimimum runtime of heat pump"
    annotation (Dialog(enable=use_minRunTime));
  parameter Boolean use_minLocTime
    "False if minimal locktime of HP is not considered"
    annotation(choices(checkBox=true));
  parameter Modelica.Units.SI.Time minLocTime(displayUnit="min")
    "Minimum lock time of heat pump"
     annotation (Dialog(enable=use_minLocTime));
  parameter Boolean use_runPerHou
    "False if maximal runs per hour of HP are not considered"
    annotation(choices(checkBox=true));
  parameter Integer maxRunPerHou "Maximal number of on/off cycles in one hour"
    annotation (Dialog(enable=use_runPerHou));
  parameter Boolean preYSet_start=true
    "Start value of pre(ySet) at initial time";
  parameter Real ySet_small
    "Value of ySet at which the device is considered turned on, 
    default is 1 % as heat pumps and chillers currently invert down to 15 %";
  parameter Real ySetMin=ySet_small
    "Minimal relative compressor speed to be used if device needs to run longer";
  Modelica.Blocks.Logical.Hysteresis ySetOn(
    final pre_y_start=preYSet_start,
    final uHigh=ySet_small,
    final uLow=ySet_small/2) "True if device is set on"
    annotation (Placement(transformation(extent={{-100,60},{-80,80}})));
  Modelica.Blocks.Routing.BooleanPassThrough isAblToTurOff(
    y(start=true, fixed=true))
    "y equals true if the device is able to turn off, else false"
    annotation (Placement(transformation(extent={{40,80},{60,100}})));
  Modelica.Blocks.Logical.Pre preOnOff(final pre_u_start=preYSet_start)
    "On off signal of previous time step"
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
  IBPSA.Fluid.HeatPumps.Controls.Safety.BaseClasses.RunPerHouBoundary runPerHouBou(final
      maxRunPerHou=maxRunPerHou, final delTim=3600) if use_runPerHou
    "Check number of starts violations"
    annotation (Placement(transformation(extent={{20,-60},{40,-40}})));
  IBPSA.Fluid.HeatPumps.Controls.Safety.BaseClasses.TimeControl locTimCtr(final
      minRunTime=minLocTime) if use_minLocTime
    "Check if device should be locked"
    annotation (Placement(transformation(extent={{20,10},{40,30}})));
  Modelica.Blocks.Logical.Not notIsOn "=true if device is off"
    annotation (Placement(transformation(extent={{-100,-60},{-80,-40}})));
  IBPSA.Fluid.HeatPumps.Controls.Safety.BaseClasses.TimeControl runTimCtr(final
      minRunTime=minRunTime) if use_minRunTime "Check if device needs to run"
    annotation (Placement(transformation(extent={{0,90},{20,110}})));
  Modelica.Blocks.Logical.And andIsAblToTurOn(
    y(start=true, fixed=true))
    "If output is false, device is locked"
    annotation (Placement(transformation(extent={{60,-70},{80,-50}})));

  Modelica.Blocks.Sources.BooleanConstant booConstRunPerHou(final k=true)
    if not use_runPerHou "Constant value for disabled option"
    annotation (Placement(transformation(extent={{20,-100},{40,-80}})));
  Modelica.Blocks.Sources.BooleanConstant booConstLocTim(final k=true)
    if not use_minLocTime "Constant value for disabled option"
    annotation (Placement(transformation(extent={{20,-20},{40,0}})));
  Modelica.Blocks.Sources.BooleanConstant booConstRunTim(final k=true)
    if not use_minRunTime "Constant value for disabled option"
    annotation (Placement(transformation(extent={{0,60},{20,80}})));
  Modelica.Blocks.Logical.Not notSetOn "Device is not set to turn on"
    annotation (Placement(transformation(extent={{-100,18},{-80,38}})));
  Modelica.Blocks.Logical.And andTurOff(
    y(start=not preYSet_start, fixed=true))
    "Check if device is on and is set to be turned off"
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  Modelica.Blocks.Logical.And andTurOn(
    y(start=preYSet_start, fixed=true))
    "Check if device is Off and is set to be turned on"
    annotation (Placement(transformation(extent={{-40,-100},{-20,-80}})));

  Modelica.Blocks.Logical.And andStaOn
    "True if the device is on and wants to stay on"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Modelica.Blocks.Logical.And andStaOff
    "True if the device is off and wants to stay off"
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
  Modelica.Blocks.Nonlinear.Limiter lim(uMax=1, uMin=ySetMin) "Keep device off"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-90,110})));

protected
  Integer devRunMin(start=0, fixed=true)
    "Indicates if device needs to run at minimal limit";
  Integer devTurOff(start=0, fixed=true)
    "Indicates if device needs to turn off";
  Integer devNorOpe(start=1, fixed=true)
    "Indicates if device is at normal operation";
equation
  yOut = ySet * devNorOpe + 0 * devTurOff + ySetMin * devRunMin;
  when edge(andTurOn.y) then
    if andIsAblToTurOn.y then
      devTurOff = 0;
      devRunMin = 0;
      devNorOpe = 1;
   else
      devTurOff = 1;
      devRunMin = 0;
      devNorOpe = 0;
    end if;
  elsewhen edge(andTurOff.y) then
    if isAblToTurOff.y then
      devTurOff = 0;
      devRunMin = 0;
      devNorOpe = 1;
    else
      devTurOff = 0;
      devRunMin = 1;
      devNorOpe = 0;
    end if;
  elsewhen andIsAblToTurOn.y and andTurOn.y then
    devTurOff = 0;
    devRunMin = 0;
    devNorOpe = 1;
  elsewhen isAblToTurOff.y and andTurOff.y then
    devTurOff = 0;
    devRunMin = 0;
    devNorOpe = 1;
  elsewhen andStaOff.y then
    devTurOff = 0;
    devRunMin = 0;
    devNorOpe = 1;
  elsewhen andStaOn.y then
    devTurOff = 0;
    devRunMin = 0;
    devNorOpe = 1;
  end when;
  connect(preOnOff.y, runPerHouBou.u) annotation (Line(points={{-79,-90},{-66,-90},
          {-66,-66},{-24,-66},{-24,-50},{18,-50}},
                                     color={255,0,255}));
  connect(preOnOff.y, notIsOn.u) annotation (Line(points={{-79,-90},{-66,-90},{-66,
          -66},{-108,-66},{-108,-50},{-102,-50}},     color={255,0,255}));
  connect(notIsOn.y, locTimCtr.u) annotation (Line(points={{-79,-50},{-52,-50},{
          -52,-10},{0,-10},{0,20},{18,20}},
                                color={255,0,255}));
  connect(runTimCtr.u, preOnOff.y) annotation (Line(points={{-2,100},{-66,100},{
          -66,-90},{-79,-90}}, color={255,0,255}));
  connect(locTimCtr.y, andIsAblToTurOn.u1) annotation (Line(
      points={{41,20},{52,20},{52,-60},{58,-60}},
      color={255,0,255},
      pattern=LinePattern.Dash));
  connect(runPerHouBou.y, andIsAblToTurOn.u2) annotation (Line(
      points={{41,-50},{50,-50},{50,-68},{58,-68}},
      color={255,0,255},
      pattern=LinePattern.Dash));
  connect(booConstRunPerHou.y, andIsAblToTurOn.u2) annotation (Line(
      points={{41,-90},{50,-90},{50,-68},{58,-68}},
      color={255,0,255},
      pattern=LinePattern.Dash));

  connect(ySetOn.y, notSetOn.u) annotation (Line(points={{-79,70},{-74,70},{-74,
          52},{-110,52},{-110,28},{-102,28}},
                         color={255,0,255}));
  connect(notSetOn.y, andTurOff.u2) annotation (Line(points={{-79,28},{-70,28},{
          -70,2},{-42,2}},    color={255,0,255}));
  connect(preOnOff.y, andTurOff.u1) annotation (Line(points={{-79,-90},{-66,-90},
          {-66,10},{-42,10}},                   color={255,0,255}));
  connect(ySetOn.y, andTurOn.u2) annotation (Line(points={{-79,70},{-74,70},{-74,
          -98},{-42,-98}},                       color={255,0,255}));
  connect(notIsOn.y, andTurOn.u1) annotation (Line(points={{-79,-50},{-52,-50},{
          -52,-90},{-42,-90}},                      color={255,0,255}));
  connect(booConstLocTim.y, andIsAblToTurOn.u1) annotation (Line(
      points={{41,-10},{52,-10},{52,-60},{58,-60}},
      color={255,0,255},
      pattern=LinePattern.Dash));

  connect(preOnOff.u, sigBus.onOffMea) annotation (Line(points={{-102,-90},{
          -108,-90},{-108,-71},{-125,-71}},
                                       color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(ySetOn.u, ySet) annotation (Line(points={{-102,70},{-114,70},{-114,20},
          {-136,20}}, color={0,0,127}));
  connect(andStaOn.u1, ySetOn.y) annotation (Line(points={{-42,50},{-58,50},{-58,
          52},{-74,52},{-74,70},{-79,70}},
                         color={255,0,255}));
  connect(andStaOn.u2, preOnOff.y) annotation (Line(points={{-42,42},{-66,42},{-66,
          -90},{-79,-90}},                   color={255,0,255}));
  connect(andStaOff.u1, notIsOn.y) annotation (Line(points={{-42,-30},{-52,-30},
          {-52,-50},{-79,-50}}, color={255,0,255}));
  connect(andStaOff.u2, notSetOn.y) annotation (Line(points={{-42,-38},{-70,-38},
          {-70,28},{-79,28}}, color={255,0,255}));
  connect(lim.u, ySet) annotation (Line(points={{-102,110},{-114,110},{-114,20},
          {-136,20}},     color={0,0,127}));
  connect(isAblToTurOff.u, runTimCtr.y) annotation (Line(points={{38,90},{28,90},
          {28,100},{21,100}}, color={255,0,255}));
  connect(booConstRunTim.y, isAblToTurOff.u) annotation (Line(points={{21,70},{28,
          70},{28,90},{38,90}}, color={255,0,255}));
  annotation (Documentation(info="<html>
<p>
  Checks if the <code>ySet</code> value is legal by checking if 
  the device can either be turned on or off, 
  depending on which state it was in. </p>
<p>If the device</p>
<ul>
<li>
  is on and <code>ySet</code> is greater 
  than <code>ySet_small</code></li>
<li>
  or is off and <code>ySet</code> is 0
</li>
<li>
  or is on and should turn off, 
  and exceeds the minimal run time (if active)</li>
<li>
  or is off and should turn on, and does neither 
  exceed the maximal starts per hour (if active) 
  nor violates the minimal loc-time (off-time, if active).
</li>
</ul>
<p><code>yOut</code> equals <code>ySet</code>.
</p>
<p>
  If the device is on and should turn off, but does not exceed 
  the minimal run time (if active), <code>yOut</code> 
  equals <code>min(ySet, ySetMin)</code>.
</p>
<p>
  If the device is off and should turn on, but exceeds the maximal 
  starts per hour (if active) or violates the minimal 
  loc-time (off-time, if active), <code>yOut</code> equals 0.
</p>
</html>", revisions="<html><ul>
  <li>
    <i>October 2, 2022</i> by Fabian Wuellhorst:<br/>
    Adjusted based on the discussion in this issue <a href=
    \"https://github.com/ibpsa/modelica-ibpsa/issues/1576\">#1576</a>)
  </li>
  <li>
    <i>November 26, 2018</i> by Fabian Wuellhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/RWTH-EBC/AixLib/issues/577\">AixLib #577</a>)
  </li>
</ul>
</html>"),
    Diagram(coordinateSystem(extent={{-120,-120},{120,120}}), graphics={
          Rectangle(
          extent={{120,60},{60,-10}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid), Text(
          extent={{60,60},{120,-6}},
          textColor={0,0,127},
          textString="See 
equations")}));
end OnOffControl;

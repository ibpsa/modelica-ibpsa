within IBPSA.Fluid.HeatPumps.SafetyControls;
model AntiLegionella "Control to avoid Legionella in the DHW"

  parameter Modelica.Units.SI.ThermodynamicTemperature TLegMin=333.15
    "Temperature at which the legionella in DWH dies";

  parameter Modelica.Units.SI.Time minTimeAntLeg
    "Minimal duration of antilegionella control";
  parameter Boolean weekly=true
    "Switch between a daily or weekly trigger approach" annotation(Dialog(descriptionLabel=true), choices(choice=true "Weekly",
      choice=false "Daily",
      radioButtons=true));
  parameter Integer trigWeekDay "Day of the week at which control is triggered"
    annotation (Dialog(enable=weekly));
  parameter Integer trigHour "Hour of the day at which control is triggered";
  parameter IBPSA.Utilities.Time.Types.ZeroTime zerTim
    "Enumeration for choosing how reference time (time = 0) should be defined";
  parameter Integer yearRef=2016 "Year when time = 0, used if zerTim=Custom";
  Modelica.Blocks.Logical.GreaterEqual
                               TConLessTLegMin
    "Compare if current TCon is smaller than the minimal TLeg"
    annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));
  Modelica.Blocks.Logical.Switch       switchTLeg
    "Switch to Legionalla control if needed"
    annotation (Placement(transformation(extent={{60,70},{80,90}})));
  Modelica.Blocks.Interfaces.RealOutput TSet_out
    "Set value for the condenser outlet temperature"
    annotation (Placement(transformation(extent={{100,66},{128,94}})));

  Modelica.Blocks.Sources.Constant constTLegMin(final k=TLegMin)
    "Temperature at which the legionella in DWH dies"
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
  Modelica.Blocks.Logical.Timer timeAntiLeg "Time in which legionella will die"
    annotation (Placement(transformation(extent={{20,-80},{40,-60}})));
  Modelica.Blocks.Logical.GreaterThreshold
                               greaterThreshold(final threshold=minTimeAntLeg)
    annotation (Placement(transformation(extent={{60,-80},{80,-60}})));
  Modelica.Blocks.Interfaces.RealInput TSet_in "Input of TSet"
    annotation (Placement(transformation(extent={{-140,64},{-100,104}})));
  Modelica.Blocks.Logical.Pre pre1
    annotation (Placement(transformation(extent={{-20,-80},{0,-60}})));
  IBPSA.Utilities.Time.DaytimeSwitch daytimeSwitch(
    final hourDay=trigHour,
    final zerTim=zerTim,
    final yearRef=yearRef,
    final weekDay=trigWeekDay)
    "If given day and hour match the current daytime, output will be true"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-90,30})));
  Modelica.Blocks.MathInteger.TriggeredAdd triggeredAdd(use_reset=true, use_set=
       false,
    y_start=0)
              "See info of model for description"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Modelica.Blocks.Sources.IntegerConstant intConPluOne(final k=1)
    "Value for counting"
    annotation (Placement(transformation(extent={{-100,60},{-80,80}})));
  Modelica.Blocks.Logical.LessThreshold    lessThreshold(final threshold=1)
    "Checks if value is less than one"
    annotation (Placement(transformation(extent={{20,40},{40,60}})));
  Modelica.Blocks.Math.IntegerToReal intToReal "Converts Integer to Real"
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));
  Modelica.Blocks.Interfaces.RealInput TSupAct
    "Input of actual supply temperature"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
equation
  connect(constTLegMin.y, TConLessTLegMin.u2) annotation (Line(points={{-79,-90},
          {-74,-90},{-74,-78},{-62,-78}},   color={0,0,127}));
  connect(switchTLeg.y, TSet_out)
    annotation (Line(points={{81,80},{114,80}},             color={0,0,127}));
  connect(TSet_in, switchTLeg.u1) annotation (Line(points={{-120,84},{-30,84},{
          -30,88},{58,88}},   color={0,0,127}));
  connect(switchTLeg.u3, constTLegMin.y) annotation (Line(points={{58,72},{-72,
          72},{-72,-78},{-74,-78},{-74,-90},{-79,-90}},
                                      color={0,0,127}));
  connect(timeAntiLeg.u, pre1.y)
    annotation (Line(points={{18,-70},{1,-70}},  color={255,0,255}));
  connect(TConLessTLegMin.y, pre1.u)
    annotation (Line(points={{-39,-70},{-22,-70}},
                                                 color={255,0,255}));
  connect(lessThreshold.y, switchTLeg.u2) annotation (Line(points={{41,50},{48,
          50},{48,80},{58,80}},   color={255,0,255}));
  connect(intToReal.y, lessThreshold.u) annotation (Line(points={{1,50},{18,50}},
                                color={0,0,127}));
  connect(intConPluOne.y, triggeredAdd.u)
    annotation (Line(points={{-79,70},{-74,70},{-74,50},{-64,50}},
                                                     color={255,127,0}));
  connect(intToReal.u, triggeredAdd.y)
    annotation (Line(points={{-22,50},{-38,50}},  color={255,127,0}));
  connect(greaterThreshold.y, triggeredAdd.reset) annotation (Line(points={{81,-70},
          {86,-70},{86,32},{-44,32},{-44,38}},           color={255,0,255}));
  connect(TSupAct, TConLessTLegMin.u1)
    annotation (Line(points={{-120,0},{-70,0},{-70,-70},{-62,-70}},
                                                color={0,0,127}));
  connect(daytimeSwitch.isDaytime, triggeredAdd.trigger) annotation (Line(
        points={{-79,30},{-56,30},{-56,38}},               color={255,0,255}));
  connect(timeAntiLeg.y, greaterThreshold.u)
    annotation (Line(points={{41,-70},{58,-70}},
                                              color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                            Rectangle(
          extent={{-100,99.5},{100,-100}},
          lineColor={175,175,175},
          lineThickness=0.5,
          fillPattern=FillPattern.Solid,
          fillColor={255,255,170}),
        Ellipse(extent={{-80,98},{80,-62}}, lineColor={160,160,164},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Line(points={{0,98},{0,78}}, color={160,160,164}),
        Line(points={{80,18},{60,18}},
                                     color={160,160,164}),
        Line(points={{0,-62},{0,-42}}, color={160,160,164}),
        Line(points={{-80,18},{-60,18}},
                                       color={160,160,164}),
        Line(points={{37,88},{26,68}}, color={160,160,164}),
        Line(points={{70,56},{49,44}}, color={160,160,164}),
        Line(points={{71,-19},{52,-9}},  color={160,160,164}),
        Line(points={{39,-52},{29,-33}}, color={160,160,164}),
        Line(points={{-39,-52},{-29,-34}}, color={160,160,164}),
        Line(points={{-71,-19},{-50,-8}},  color={160,160,164}),
        Line(points={{-71,55},{-54,46}}, color={160,160,164}),
        Line(points={{-38,88},{-28,69}}, color={160,160,164}),
        Line(
          points={{0,18},{-50,68}},
          thickness=0.5),
        Line(
          points={{0,18},{40,18}},
          thickness=0.5),
        Line(
          points={{0,18},{0,86}},
          thickness=0.5,
          color={238,46,47}),
        Line(
          points={{0,18},{-18,-14}},
          thickness=0.5,
          color={238,46,47}),
        Text(
          extent={{-14,0},{72,-36}},
          textColor={238,46,47},
          pattern=LinePattern.Dash,
          lineThickness=0.5,
          textString=DynamicSelect("%TLegMin K", String(TLegMin-273.15)+ "degC")),
        Text(
          extent={{-94,0},{56,-154}},
          textColor={28,108,200},
          fillColor={215,215,215},
          fillPattern=FillPattern.HorizontalCylinder,
          textString="Day of week: %trigWeekDay
Hour of Day: %trigHour",
          horizontalAlignment=TextAlignment.Left),
        Text(
          extent={{-151,147},{149,107}},
          textColor={0,0,255},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255},
          textString="%name")}),                                                           Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html><p>
  This model represents the anti legionella control of a real heat
  pump. Based on a daily or weekly approach, the given supply
  temperature is raised above the minimal temperature required for the
  thermal desinfection (at least 60 degC) for a given duration
  minTimeAntLeg.
</p>
<ul>
  <li>
    <i>November 26, 2018</i> by Fabian Wuellhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/RWTH-EBC/AixLib/issues/577\">AixLib #577</a>)
  </li>
</ul>
</html>"));
end AntiLegionella;

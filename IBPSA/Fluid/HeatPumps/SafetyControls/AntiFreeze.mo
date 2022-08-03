within IBPSA.Fluid.HeatPumps.SafetyControls;
model AntiFreeze "Model to prevent source from freezing"
  extends BaseClasses.PartialSafetyControlWithErrors;

  parameter Boolean use_antFre=true
    "True if anti freeze control is part of safety control" annotation(choices(checkBox=true));
  parameter Modelica.Units.SI.ThermodynamicTemperature TAntFre=276.15
    "Limit temperature for anti freeze control"
    annotation (Dialog(enable=use_antFre));
  parameter Real dTHys=2
    "Hysteresis interval width";
  Modelica.Blocks.Sources.BooleanConstant booConAntFre(final k=true) if not
    use_antFre
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));
  Modelica.Blocks.Logical.Hysteresis       hysteresis(
    final uLow=TAntFre,
    final pre_y_start=true,
    final uHigh=TAntFre + dTHys)
    if use_antFre
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
                           //assume that the initial temperature is high enough.
  Modelica.Blocks.Math.Min min if use_antFre
    annotation (Placement(transformation(extent={{-100,-20},{-80,0}})));

equation
  connect(ySet,swiErr.u1)  annotation (Line(points={{-136,20},{32,20},{32,8},{
          78,8}}, color={0,0,127}));
  connect(modeSet, modeOut) annotation (Line(points={{-136,-20},{-114,-20},{
          -114,-64},{96,-64},{96,-20},{130,-20}}, color={255,0,255}));
  connect(min.y, hysteresis.u) annotation (Line(points={{-79,-10},{-62,-10}},
                           color={0,0,127}));
  connect(sigBusHP.TConInMea, min.u1) annotation (Line(
      points={{-129,-69},{-129,-38},{-112,-38},{-112,-4},{-102,-4}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));

  connect(sigBusHP.TEvaOutMea, min.u2) annotation (Line(
      points={{-129,-69},{-129,-38},{-112,-38},{-112,-16},{-102,-16}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));

  connect(booConAntFre.y, booleanPassThrough.u) annotation (Line(
      points={{21,-30},{28,-30},{28,0},{38,0}},
      color={255,0,255},
      pattern=LinePattern.Dash));
  connect(hysteresis.y, booleanPassThrough.u) annotation (Line(
      points={{-39,-10},{0,-10},{0,0},{38,0}},
      color={255,0,255},
      pattern=LinePattern.Dash));
  annotation (Documentation(revisions="<html><ul>
  <li>
    <i>November 26, 2018&#160;</i> by Fabian Wüllhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/RWTH-EBC/AixLib/issues/577\">#577</a>)
  </li>
</ul>
</html>", info="<html>
<p>
  This models takes the minimum of the two temperatures evaporator
  outlet and condenser inlet. If this minimal temperature falls below
  the given lower boundary, the hystereses will trigger an error and
  cause the device to switch off.
</p>
<h4>
  Assumptions
</h4>
<p>
  Assuming that the outlet temperature of an evaporator is always lower
  than the inlet temperature(for the condenser vice versa).
</p>
</html>"));
end AntiFreeze;

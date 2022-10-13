within IBPSA.Fluid.HeatPumps.SafetyControls;
model AntiFreeze "Model to prevent source from freezing"
  extends BaseClasses.PartialSafetyControlWithErrors;

  parameter Boolean use_antFre=true
    "True if anti freeze control is part of safety control"
    annotation(choices(checkBox=true));
  parameter Modelica.Units.SI.ThermodynamicTemperature TAntFre=276.15
    "Limit temperature for anti freeze control"
    annotation (Dialog(enable=use_antFre));
  parameter Real dTHys=2
    "Hysteresis interval width";
  Modelica.Blocks.Sources.BooleanConstant booConAntFre(final k=true) if not
    use_antFre
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));
  Modelica.Blocks.Logical.Hysteresis hys(
    final uLow=TAntFre,
    final pre_y_start=true,
    final uHigh=TAntFre + dTHys) if use_antFre
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));

  Modelica.Blocks.Math.Min min if use_antFre
    annotation (Placement(transformation(extent={{-100,-20},{-80,0}})));

equation
  connect(ySet,swiErr.u1)  annotation (Line(points={{-116,20},{32,20},{32,8},{
          78,8}}, color={0,0,127}));
  connect(min.y, hys.u)
    annotation (Line(points={{-79,-10},{-62,-10}}, color={0,0,127}));
  connect(sigBus.TConInMea, min.u1) annotation (Line(
      points={{-105,-71},{-105,-38},{-112,-38},{-112,-4},{-102,-4}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));

  connect(sigBus.TEvaOutMea, min.u2) annotation (Line(
      points={{-105,-71},{-105,-38},{-112,-38},{-112,-16},{-102,-16}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));

  connect(booConAntFre.y, booPasThr.u) annotation (Line(
      points={{21,-30},{28,-30},{28,0},{38,0}},
      color={255,0,255},
      pattern=LinePattern.Dash));
  connect(hys.y, booPasThr.u) annotation (Line(
      points={{-39,-10},{0,-10},{0,0},{38,0}},
      color={255,0,255},
      pattern=LinePattern.Dash));
  annotation (Documentation(revisions="<html><ul>
  <li>
    <i>November 26, 2018</i> by Fabian Wuellhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/RWTH-EBC/AixLib/issues/577\">AixLib #577</a>)
  </li>
</ul>
</html>", info="<html>
This models takes the minimum of the two temperatures evaporator outlet and 
condenser inlet. If this minimal temperature falls below the given lower 
boundary, the hystereses will trigger an error and cause 
the device to switch off.

<p>Used to prevent freezing of condenser or evaporator side. 
A real device would shut off as well.</p>

<h4>Assumptions </h4>

Assuming that the outlet temperature of an evaporator is always lower 
than the inlet temperature (for the condenser vice versa).
</html>"));
end AntiFreeze;

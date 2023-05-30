within IBPSA.Fluid.HeatPumps.SafetyControls;
model AntiFreeze "Model to prevent source from freezing"
  extends BaseClasses.PartialSafetyControlWithErrors;

  parameter Modelica.Units.SI.ThermodynamicTemperature TAntFre=276.15
    "Limit temperature for anti freeze control"
    annotation (Dialog(enable=use_antFre));
  parameter Real dTHys=2
    "Hysteresis interval width";
  Modelica.Blocks.Logical.Hysteresis hys(
    final uLow=TAntFre,
    final pre_y_start=true,
    final uHigh=TAntFre + dTHys) "Hysteresis to indicate if freezing occurs"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));

  Modelica.Blocks.Math.Min min "The minimum of both sides indicates freezing"
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));

equation
  connect(ySet,swiErr.u1)  annotation (Line(points={{-136,20},{66,20},{66,8},{
          78,8}}, color={0,0,127}));
  connect(min.y, hys.u)
    annotation (Line(points={{-39,-10},{-28,-10},{-28,0},{-22,0}},
                                                   color={0,0,127}));
  connect(sigBus.TConInMea, min.u1) annotation (Line(
      points={{-125,-71},{-125,-14},{-104,-14},{-104,-4},{-62,-4}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));

  connect(sigBus.TEvaOutMea, min.u2) annotation (Line(
      points={{-125,-71},{-125,-16},{-62,-16}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));

  connect(hys.y, booPasThr.u) annotation (Line(
      points={{1,0},{38,0}},
      color={255,0,255}));
  annotation (Documentation(revisions="<html><ul>
<li>
  <i>October 2, 2022</i> by Fabian Wuellhorst:<br/>
  Adapted based on IBPSA implementation (see issue <a href=
  \"https://github.com/ibpsa/modelica-ibpsa/issues/1576\">#1576</a>)
</li>
<li>
  <i>November 26, 2018</i> by Fabian Wuellhorst:<br/>
  First implementation (see issue <a href=
  \"https://github.com/RWTH-EBC/AixLib/issues/577\">AixLib #577</a>)
</li>
</ul>
</html>", info="<html>
<p>
  This model is used to prevent freezing of 
  the condenser or evaporator side. 
  A real device would shut off as well.
</p>
<p>
This models takes the minimum of the two temperatures evaporator 
outlet and condenser inlet. If this minimal temperature falls below 
the given lower boundary, the hystereses will trigger an error and cause 
the device to switch off.
</p>
<h4>Assumptions </h4>

Assuming that the outlet temperature of an evaporator is always lower 
than the inlet temperature (for the condenser vice versa).
</html>"));
end AntiFreeze;

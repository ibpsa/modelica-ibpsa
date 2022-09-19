within IBPSA.Fluid.HeatPumps.SafetyControls;
block DefrostControl
  "Control block to ensure no frost limits heat flow at the evaporator"
  extends IBPSA.Fluid.HeatPumps.SafetyControls.BaseClasses.PartialSafetyControlWithErrors;
  parameter Real minIceFac "Minimal value above which no defrost is necessary";
  parameter Boolean use_chiller=true
    "True if defrost operates by changing mode to cooling. False to use an electrical heater" annotation(choices(checkBox=true));
  parameter Modelica.Units.SI.Power calcPel_deFro
    "Calculate how much eletrical energy is used to melt ice"
    annotation (Dialog(enable=not use_chiller));
  parameter Real deltaIceFac = 0.1 "Bandwitdth for hystereses. If the icing factor is based on the duration of defrost, this value is necessary to avoid state-events.";
  Modelica.Blocks.Logical.Hysteresis iceFacGreMinHea(
    final uLow=minIceFac,
    final uHigh=minIceFac + deltaIceFac,
    final pre_y_start=true)
                  if not use_chiller
    "Check if icing factor is greater than a boundary" annotation (Placement(
        transformation(
        extent={{-10.5,-10.5},{10.5,10.5}},
        rotation=0,
        origin={-29.5,-69.5})));
 Modelica.Blocks.Interfaces.RealOutput Pel_deFro if not use_chiller
    "Relative speed of compressor. From 0 to 1" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={0,128})));
  Modelica.Blocks.Sources.BooleanConstant conTrueNotUseChi(final k=true)
 if not use_chiller
    "If ice is melted with an additional heater, HP can continue running"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Modelica.Blocks.Sources.Constant constPel_deFro(final k=calcPel_deFro)
                                                                        if not
    use_chiller "Calculate how much eletrical energy is used to melt ice"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={30,50})));

  Modelica.Blocks.Logical.Switch       swiPel if not use_chiller
    "If defrost is on, output will be positive" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,90})));
  Modelica.Blocks.Sources.Constant conZero(final k=0) if not use_chiller
    "If Defrost is enabled, HP runs at full power"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-30,50})));
  Modelica.Blocks.Logical.Hysteresis iceFacGreMinChi(
    final uLow=minIceFac,
    final uHigh=minIceFac + deltaIceFac,
    final pre_y_start=true)
                  if use_chiller
    "Check if icing factor is greater than a boundary" annotation (Placement(
        transformation(
        extent={{-10.5,-10.5},{10.5,10.5}},
        rotation=0,
        origin={-29.5,-29.5})));
  Modelica.Blocks.Logical.LogicalSwitch logicalSwitch
    "If a chiller is used to defrost, mode will be false"
    annotation (Placement(transformation(extent={{80,-60},{100,-40}})));
  Modelica.Blocks.Sources.BooleanConstant conFalseNotUseChi(final k=true)
                                                                       if not
    use_chiller "Just to omit warnings"
    annotation (Placement(transformation(extent={{20,-80},{40,-60}})));
  Modelica.Blocks.Sources.BooleanConstant conTrueUseChi(final k=not use_chiller)
 if use_chiller "Set mode to false to simulate the defrost cycle"
    annotation (Placement(transformation(extent={{20,-80},{40,-60}})));
equation
  connect(ySet, swiErr.u1) annotation (Line(points={{-136,20},{74,20},{74,8},{
          78,8}},
               color={0,0,127}));
  connect(sigBusHP.iceFacMea, iceFacGreMinHea.u) annotation (Line(
      points={{-129,-69},{-82.8,-69},{-82.8,-69.5},{-42.1,-69.5}},
      color={255,204,51},
      thickness=0.5,
      pattern=LinePattern.Dash), Text(
      string="%first",
      index=-1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
  connect(Pel_deFro, swiPel.y)
    annotation (Line(points={{0,128},{0,111.5},{8.88178e-16,111.5},{8.88178e-16,
          101}},                              color={0,0,127}));
  connect(iceFacGreMinHea.y, swiPel.u2) annotation (Line(
      points={{-17.95,-69.5},{0,-69.5},{0,4},{-6.66134e-16,4},{-6.66134e-16,78}},
      color={255,0,255},
      pattern=LinePattern.Dash));

  connect(constPel_deFro.y, swiPel.u3) annotation (Line(
      points={{30,61},{30,70},{8,70},{8,78}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(swiPel.u1, conZero.y) annotation (Line(
      points={{-8,78},{-8,70},{-30,70},{-30,61}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(sigBusHP.iceFacMea, iceFacGreMinChi.u) annotation (Line(
      points={{-129,-69},{-50,-69},{-50,-29.5},{-42.1,-29.5}},
      color={255,204,51},
      thickness=0.5,
      pattern=LinePattern.Dash), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(logicalSwitch.y, modeOut) annotation (Line(points={{101,-50},{116,-50},
          {116,-20},{130,-20}},color={255,0,255}));
  connect(modeSet, logicalSwitch.u1) annotation (Line(points={{-136,-20},{-110,
          -20},{-110,18},{12,18},{12,-42},{78,-42}},
                                    color={255,0,255}));
  connect(conFalseNotUseChi.y, logicalSwitch.u3) annotation (Line(
      points={{41,-70},{66,-70},{66,-58},{78,-58}},
      color={255,0,255},
      pattern=LinePattern.Dash));
  connect(conTrueUseChi.y, logicalSwitch.u3) annotation (Line(
      points={{41,-70},{66,-70},{66,-58},{78,-58}},
      color={255,0,255},
      pattern=LinePattern.Dash));
  connect(conTrueNotUseChi.y, booleanPassThrough.u) annotation (Line(
      points={{-19,0},{38,0}},
      color={255,0,255},
      pattern=LinePattern.Dash));
  connect(iceFacGreMinChi.y, booleanPassThrough.u) annotation (Line(
      points={{-17.95,-29.5},{20,-29.5},{20,0},{38,0}},
      color={255,0,255},
      pattern=LinePattern.Dash));
  connect(booleanPassThrough.y, logicalSwitch.u2) annotation (Line(points={{61,0},
          {66,0},{66,-50},{78,-50}}, color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-120,
            -120},{120,120}}),                                  graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={28,108,200},
          fillColor={255,255,170},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-36,34},{-36,-6}},
          color={28,108,200}),
        Line(
          points={{0,20},{0,-20}},
          color={28,108,200},
          origin={-36,14},
          rotation=90),
        Line(
          points={{-14,14},{14,-14}},
          color={28,108,200},
          origin={-36,14},
          rotation=90),
        Line(
          points={{14,14},{-14,-14}},
          color={28,108,200},
          origin={-36,14},
          rotation=90),
        Line(
          points={{8,64},{8,24}},
          color={28,108,200}),
        Line(
          points={{0,20},{0,-20}},
          color={28,108,200},
          origin={8,44},
          rotation=90),
        Line(
          points={{-14,14},{14,-14}},
          color={28,108,200},
          origin={8,44},
          rotation=90),
        Line(
          points={{14,14},{-14,-14}},
          color={28,108,200},
          origin={8,44},
          rotation=90),
        Line(
          points={{-34,-22},{-34,-62}},
          color={28,108,200}),
        Line(
          points={{0,20},{0,-20}},
          color={28,108,200},
          origin={-34,-42},
          rotation=90),
        Line(
          points={{-14,14},{14,-14}},
          color={28,108,200},
          origin={-34,-42},
          rotation=90),
        Line(
          points={{14,14},{-14,-14}},
          color={28,108,200},
          origin={-34,-42},
          rotation=90),
        Line(
          points={{14,6},{14,-34}},
          color={28,108,200}),
        Line(
          points={{0,20},{0,-20}},
          color={28,108,200},
          origin={14,-14},
          rotation=90),
        Line(
          points={{-14,14},{14,-14}},
          color={28,108,200},
          origin={14,-14},
          rotation=90),
        Line(
          points={{14,14},{-14,-14}},
          color={28,108,200},
          origin={14,-14},
          rotation=90),
        Text(
          extent={{-151,147},{149,107}},
          textColor={0,0,255},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255},
          textString="%name")}),                                 Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-120,-120},{120,
            120}})),
    Documentation(info="<html><p>
  Basic model for a defrost control. The icing factor is calculated in
  the heat pump based on functions or other models.
</p>
<p>
  If a given lower boundary is surpassed, the mode of the heat pump
  will be set to false(eq. Chilling) and the compressor speed is set to
  1 to make the defrost process as fast as possible.
</p>
<ul>
  <li>
    <i>November 26, 2018&#160;</i> by Fabian Wuellhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/RWTH-EBC/AixLib/issues/577\">AixLib #577</a>)
  </li>
</ul>
</html>"));
end DefrostControl;

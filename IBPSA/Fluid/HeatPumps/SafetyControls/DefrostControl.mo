within IBPSA.Fluid.HeatPumps.SafetyControls;
block DefrostControl
  "Control block to ensure no frost limits heat flow at the evaporator"
  extends IBPSA.Fluid.HeatPumps.SafetyControls.BaseClasses.PartialSafetyControl;
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
        extent={{-8,-9},{8,9}},
        rotation=0,
        origin={-31,-78})));
 Modelica.Blocks.Interfaces.RealOutput Pel_deFro if not use_chiller
    "Relative speed of compressor. From 0 to 1" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={0,110})));
  Modelica.Blocks.Sources.BooleanConstant conTrueNotUseChi(final k=true)
 if not use_chiller
    "If ice is melted with an additional heater, HP can continue running"
    annotation (Placement(transformation(extent={{-36,-6},{-24,6}})));
  Modelica.Blocks.Sources.Constant constPel_deFro(final k=calcPel_deFro)
                                                                        if not
    use_chiller "Calculate how much eletrical energy is used to melt ice"
    annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=90,
        origin={10,52})));

  Modelica.Blocks.Logical.Switch       swiPel if not use_chiller
    "If defrost is on, output will be positive" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,84})));
  Modelica.Blocks.Sources.Constant conZero(final k=0) if not use_chiller
    "If Defrost is enabled, HP runs at full power"
    annotation (Placement(transformation(extent={{-6,-6},{6,6}},
        rotation=90,
        origin={-12,52})));
  Modelica.Blocks.Logical.Hysteresis iceFacGreMinChi(
    final uLow=minIceFac,
    final uHigh=minIceFac + deltaIceFac,
    final pre_y_start=true)
                  if use_chiller
    "Check if icing factor is greater than a boundary" annotation (Placement(
        transformation(
        extent={{-8,-9},{8,9}},
        rotation=0,
        origin={-31,-46})));
  Modelica.Blocks.Logical.LogicalSwitch logicalSwitch
    "If a chiller is used to defrost, mode will be false"
    annotation (Placement(transformation(extent={{64,-54},{84,-34}})));
  Modelica.Blocks.Sources.BooleanConstant conFalseNotUseChi(final k=true)
                                                                       if not
    use_chiller "Just to omit warnings"
    annotation (Placement(transformation(extent={{30,-100},{40,-90}})));
  Modelica.Blocks.Sources.BooleanConstant conTrueUseChi(final k=false)
 if use_chiller "Set mode to false to simulate the defrost cycle"
    annotation (Placement(transformation(extent={{30,-88},{40,-78}})));
equation
  connect(swiErr.y, nOut) annotation (Line(points={{107,0},{96,0},{96,20},{130,
          20}}, color={0,0,127}));
  connect(nSet, swiErr.u1) annotation (Line(points={{-136,20},{-26,20},{-26,8},
          {84,8}},
               color={0,0,127}));
  connect(sigBusHP.iceFacMea, iceFacGreMinHea.u) annotation (Line(
      points={{-129,-69},{-68,-69},{-68,-78},{-40.6,-78}},
      color={255,204,51},
      thickness=0.5,
      pattern=LinePattern.Dash), Text(
      string="%first",
      index=-1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
  connect(Pel_deFro, swiPel.y)
    annotation (Line(points={{0,110},{0,95}}, color={0,0,127}));
  connect(conTrueNotUseChi.y, swiErr.u2) annotation (Line(
      points={{-23.4,0},{0,0},{0,0},{84,0}},
      color={255,0,255},
      pattern=LinePattern.Dash));
  connect(iceFacGreMinHea.y, swiPel.u2) annotation (Line(
      points={{-22.2,-78},{-10,-78},{-10,34},{-6.66134e-16,34},{-6.66134e-16,72}},
      color={255,0,255},
      pattern=LinePattern.Dash));

  connect(constPel_deFro.y, swiPel.u3) annotation (Line(
      points={{10,58.6},{10,68},{8,68},{8,72}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(swiPel.u1, conZero.y) annotation (Line(
      points={{-8,72},{-8,58.6},{-12,58.6}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(sigBusHP.iceFacMea, iceFacGreMinChi.u) annotation (Line(
      points={{-129,-69},{-68,-69},{-68,-46},{-40.6,-46}},
      color={255,204,51},
      thickness=0.5,
      pattern=LinePattern.Dash), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(iceFacGreMinChi.y, swiErr.u2) annotation (Line(
      points={{-22.2,-46},{8,-46},{8,0},{84,0}},
      color={255,0,255},
      pattern=LinePattern.Dash));
  connect(logicalSwitch.y, modeOut) annotation (Line(points={{85,-44},{98,-44},
          {98,-20},{130,-20}}, color={255,0,255}));
  connect(modeSet, logicalSwitch.u1) annotation (Line(points={{-136,-20},{52,
          -20},{52,-36},{62,-36}},  color={255,0,255}));
  connect(conTrueNotUseChi.y, logicalSwitch.u2) annotation (Line(
      points={{-23.4,0},{8,0},{8,-32},{50,-32},{50,-44},{62,-44}},
      color={255,0,255},
      pattern=LinePattern.Dash));
  connect(conFalseNotUseChi.y, logicalSwitch.u3) annotation (Line(
      points={{40.5,-95},{50,-95},{50,-52},{62,-52}},
      color={255,0,255},
      pattern=LinePattern.Dash));
  connect(iceFacGreMinChi.y, logicalSwitch.u2) annotation (Line(
      points={{-22.2,-46},{8,-46},{8,-32},{50,-32},{50,-44},{62,-44}},
      color={255,0,255},
      pattern=LinePattern.Dash));
  connect(conTrueUseChi.y, logicalSwitch.u3) annotation (Line(
      points={{40.5,-83},{50,-83},{50,-52},{62,-52}},
      color={255,0,255},
      pattern=LinePattern.Dash));
  connect(not1.u, logicalSwitch.y) annotation (Line(points={{-21,-63},{-21,-56},
          {98,-56},{98,-44},{85,-44}}, color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-120,
            -100},{120,100}}),                                  graphics={
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
          extent={{-104,100},{106,76}},
          lineColor={28,108,200},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.None,
          textString="%name")}),                                 Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-120,-100},{120,
            100}})),
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
    <i>November 26, 2018&#160;</i> by Fabian Wüllhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/RWTH-EBC/AixLib/issues/577\">#577</a>)
  </li>
</ul>
</html>"));
end DefrostControl;

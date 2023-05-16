within IBPSA.Fluid.HeatPumps.SafetyControls;
model DefrostControl
  "Control model to ensure no frost limits heat flow at the evaporator"
  extends
    IBPSA.Fluid.HeatPumps.SafetyControls.BaseClasses.PartialSafetyControlWithErrors;
  parameter Real minIceFac "Minimal value above which no defrost is necessary";
  parameter Boolean use_chiller=true
    "True if defrost by reverse cycle, false if by heater" annotation(choices(checkBox=true));
  parameter Modelica.Units.SI.Power conPelDeFro
    "Constant eletrical energy demand to melt ice"
    annotation (Dialog(enable=not use_chiller));
  parameter Real deaIciFac=0.1 "Icing factor deadband";
  Modelica.Blocks.Logical.Hysteresis iceFacGreMinHea(
    final uLow=minIceFac,
    final uHigh=minIceFac + deaIciFac,
    final pre_y_start=true) if not use_chiller
    "Check if icing factor is greater than a boundary" annotation (Placement(
        transformation(
        extent={{-10.5,-10.5},{10.5,10.5}},
        rotation=0,
        origin={-29.5,-69.5})));
  Modelica.Blocks.Interfaces.RealOutput PelDeFro if not use_chiller
    "Relative speed of compressor. From 0 to 1" annotation (Placement(
        transformation(extent={{10,-10},{-10,10}}, rotation=180,
        origin={130,92}), iconTransformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={110,80})));
  Modelica.Blocks.Sources.BooleanConstant conTrueNotUseChi(final k=true)
 if not use_chiller
    "If ice is melted with an additional heater, HP can continue running"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Modelica.Blocks.Sources.Constant constPelDeFro(final k=conPelDeFro)
    if not use_chiller
    "Calculate how much eletrical energy is used to melt ice" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-10,70})));

  Modelica.Blocks.Logical.Switch swiPel if not use_chiller
    "If defrost is on, output will be positive" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={70,90})));
  Modelica.Blocks.Sources.Constant conZero(final k=0) if not use_chiller
    "If Defrost is enabled, HP runs at full power"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-10,110})));
  Modelica.Blocks.Logical.Hysteresis iceFacGreMinChi(
    final uLow=minIceFac,
    final uHigh=minIceFac + deaIciFac,
    final pre_y_start=true) if use_chiller
    "Check if icing factor is greater than a boundary" annotation (Placement(
        transformation(
        extent={{-10.5,-10.5},{10.5,10.5}},
        rotation=0,
        origin={-29.5,-29.5})));
  Modelica.Blocks.Logical.LogicalSwitch logicalSwitch
    "If a chiller is used to defrost, maiModOut will be false"
    annotation (Placement(transformation(extent={{80,-60},{100,-40}})));
  Modelica.Blocks.Sources.BooleanConstant conFalseNotUseChi(final k=true)
                                                                       if not
    use_chiller "Just to omit warnings"
    annotation (Placement(transformation(extent={{20,-80},{40,-60}})));
  Modelica.Blocks.Sources.BooleanConstant conTrueUseChi(final k=not use_chiller)
 if use_chiller "Set maiModOut to false to simulate the defrost cycle"
    annotation (Placement(transformation(extent={{20,-80},{40,-60}})));
  Modelica.Blocks.Interfaces.BooleanInput maiModSet
    "Set value of main operation mode" annotation (Placement(transformation(
          extent={{-152,-36},{-120,-4}}), iconTransformation(extent={{-152,-36},
            {-120,-4}})));
  Modelica.Blocks.Interfaces.BooleanOutput maiModOut
    "Set value of main operation mode" annotation (Placement(transformation(
          extent={{120,-32},{144,-8}}), iconTransformation(extent={{100,-34},{120,
            -14}})));
equation
  connect(ySet, swiErr.u1) annotation (Line(points={{-136,20},{74,20},{74,8},{78,
          8}}, color={0,0,127}));
  connect(sigBus.iceFacMea, iceFacGreMinHea.u) annotation (Line(
      points={{-125,-71},{-82.8,-71},{-82.8,-69.5},{-42.1,-69.5}},
      color={255,204,51},
      thickness=0.5,
      pattern=LinePattern.Dash), Text(
      string="%first",
      index=-1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
  connect(PelDeFro, swiPel.y) annotation (Line(points={{130,92},{128,92},{128,
          90},{81,90}},   color={0,0,127}));
  connect(iceFacGreMinHea.y, swiPel.u2) annotation (Line(
      points={{-17.95,-69.5},{14,-69.5},{14,90},{58,90}},
      color={255,0,255},
      pattern=LinePattern.Dash));

  connect(constPelDeFro.y, swiPel.u3) annotation (Line(
      points={{1,70},{10,70},{10,82},{58,82}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(swiPel.u1, conZero.y) annotation (Line(
      points={{58,98},{6,98},{6,110},{1,110}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(sigBus.iceFacMea, iceFacGreMinChi.u) annotation (Line(
      points={{-125,-71},{-50,-71},{-50,-29.5},{-42.1,-29.5}},
      color={255,204,51},
      thickness=0.5,
      pattern=LinePattern.Dash), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(conFalseNotUseChi.y, logicalSwitch.u3) annotation (Line(
      points={{41,-70},{66,-70},{66,-58},{78,-58}},
      color={255,0,255},
      pattern=LinePattern.Dash));
  connect(conTrueUseChi.y, logicalSwitch.u3) annotation (Line(
      points={{41,-70},{66,-70},{66,-58},{78,-58}},
      color={255,0,255},
      pattern=LinePattern.Dash));
  connect(conTrueNotUseChi.y, booPasThr.u) annotation (Line(
      points={{-19,0},{38,0}},
      color={255,0,255},
      pattern=LinePattern.Dash));
  connect(iceFacGreMinChi.y, booPasThr.u) annotation (Line(
      points={{-17.95,-29.5},{20,-29.5},{20,0},{38,0}},
      color={255,0,255},
      pattern=LinePattern.Dash));
  connect(booPasThr.y, logicalSwitch.u2) annotation (Line(points={{61,0},{66,0},
          {66,-50},{78,-50}}, color={255,0,255}));
  connect(logicalSwitch.u1, maiModSet) annotation (Line(points={{78,-42},{72,-42},
          {72,-44},{-114,-44},{-114,-20},{-136,-20}}, color={255,0,255}));
  connect(logicalSwitch.y, maiModOut) annotation (Line(points={{101,-50},{114,-50},
          {114,-20},{132,-20}}, color={255,0,255}));
  annotation (Icon(graphics={
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
          rotation=90)}), Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-120,-120},{120,
            120}})),
    Documentation(info="<html>
<p>Simple example of a defrost controller. The icing factor is calculated in the heat pump based on functions or other models. </p>
<p>If a given lower boundary is surpassed, the mode of the heat pump will be set to false (eq. Chilling) and the compressor speed is set to 1 to realize the defrost process as fast as possible. </p>
</html>", revisions="<html><ul>
  <li>
    <i>November 26, 2018</i> by Fabian Wuellhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/RWTH-EBC/AixLib/issues/577\">AixLib #577</a>)
  </li>
</ul>
</html>"));
end DefrostControl;

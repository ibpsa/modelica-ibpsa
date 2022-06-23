within IBPSA.Fluid.HeatPumps.SafetyControls;
block SafetyControl "Block including all safety levels"
  extends BaseClasses.PartialSafetyControl;
  replaceable parameter RecordsCollection.DefaultSafetyControl
    safetyControlParameters constrainedby RecordsCollection.HeatPumpSafetyControlBaseDataDefinition
    annotation (choicesAllMatching=true, Placement(transformation(extent={{-118,102},{-104,118}})));
  IBPSA.Fluid.HeatPumps.SafetyControls.OperationalEnvelope
    operationalEnvelope(
    final use_opeEnv=safetyControlParameters.use_opeEnv,
    final tableUpp=safetyControlParameters.tableUpp,
    final use_opeEnvFroRec=safetyControlParameters.use_opeEnvFroRec,
    final dataTable=safetyControlParameters.dataTable,
    final dTHyst=safetyControlParameters.dTHystOperEnv)
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));
  IBPSA.Fluid.HeatPumps.SafetyControls.OnOffControl onOffController(
    final minRunTime=safetyControlParameters.minRunTime,
    final minLocTime=safetyControlParameters.minLocTime,
    final use_minRunTime=safetyControlParameters.use_minRunTime,
    final use_minLocTime=safetyControlParameters.use_minLocTime,
    final use_runPerHou=safetyControlParameters.use_runPerHou,
    final maxRunPerHou=safetyControlParameters.maxRunPerHou,
    final pre_n_start=safetyControlParameters.pre_n_start)
    annotation (Placement(transformation(extent={{-62,18},{-38,42}})));

  IBPSA.Fluid.HeatPumps.SafetyControls.DefrostControl defrostControl(
    final minIceFac=safetyControlParameters.minIceFac,
    final deltaIceFac=safetyControlParameters.deltaIceFac,
    final use_chiller=safetyControlParameters.use_chiller,
    final calcPel_deFro=safetyControlParameters.calcPel_deFro) if safetyControlParameters.use_deFro
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
  Modelica.Blocks.Routing.RealPassThrough realPasThrDef if not safetyControlParameters.use_deFro
    "No 2. Layer"
    annotation (Placement(transformation(extent={{-100,60},{-80,80}})),
      choicesAllMatching=true);
  Modelica.Blocks.Sources.BooleanConstant conTru(final k=true)
    "Always true as the two blocks OperationalEnvelope and OnOffControl deal with whether the ySet value is correct or not"
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));
  Modelica.Blocks.Interfaces.RealOutput Pel_deFro if not safetyControlParameters.use_chiller and
    safetyControlParameters.use_deFro
    "Relative speed of compressor. From 0 to 1" annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={130,80})));
  IBPSA.Fluid.HeatPumps.SafetyControls.AntiFreeze antiFreeze(final TAntFre=safetyControlParameters.TantFre, final use_antFre=safetyControlParameters.use_antFre)
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
  Modelica.Blocks.Routing.BooleanPassThrough boolPasThrDef
                                                        if not safetyControlParameters.use_deFro
    "No 2. Layer" annotation (Placement(transformation(extent={{-100,-60},{-80,-40}})),
                     choicesAllMatching=true);
  Modelica.Blocks.Interfaces.IntegerOutput ERR_opeEnv
                                                  if safetyControlParameters.use_opeEnv annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={60,-130})));
  Modelica.Blocks.Interfaces.IntegerOutput ERR_antFre
                                                  if safetyControlParameters.use_antFre annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={100,-130})));

equation
  connect(conTru.y,swiErr.u2)
    annotation (Line(points={{21,-30},{34,-30},{34,0},{78,0}},
                                               color={255,0,255}));
  connect(onOffController.yOut, operationalEnvelope.ySet) annotation (Line(
        points={{-39,30},{-39,31.6667},{-21.3333,31.6667}},               color=
         {0,0,127}));

  connect(sigBusHP, onOffController.sigBusHP) annotation (Line(
      points={{-129,-69},{-112,-69},{-112,-24},{-106,-24},{-106,-10},{-66,-10},
          {-66,22.7},{-59.9,22.7}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
  connect(sigBusHP, operationalEnvelope.sigBusHP) annotation (Line(
      points={{-129,-69},{-112,-69},{-112,-24},{-106,-24},{-106,-10},{-28,-10},{
          -28,24.25},{-20.75,24.25}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
  connect(sigBusHP, defrostControl.sigBusHP) annotation (Line(
      points={{-129,-69},{-112,-69},{-112,-24},{-106,-24},{-106,24.25},{-100.75,
          24.25}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
  connect(ySet, defrostControl.ySet) annotation (Line(
      points={{-136,20},{-124,20},{-124,2},{-118,2},{-118,8},{-116,8},{-116,
          31.6667},{-101.333,31.6667}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(ySet, realPasThrDef.u) annotation (Line(
      points={{-136,20},{-124,20},{-124,2},{-118,2},{-118,8},{-116,8},{-116,30},
          {-110,30},{-110,70},{-102,70}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(realPasThrDef.y, onOffController.ySet) annotation (Line(
      points={{-79,70},{-74,70},{-74,30},{-61.6,30}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(modeSet, defrostControl.modeSet) annotation (Line(
      points={{-136,-20},{-114,-20},{-114,28.3333},{-101.333,28.3333}},
      color={255,0,255},
      pattern=LinePattern.Dash));
  connect(defrostControl.yOut, onOffController.ySet) annotation (Line(
      points={{-79.1667,31.6667},{-72,31.6667},{-72,30},{-61.6,30}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(defrostControl.modeOut, operationalEnvelope.modeSet) annotation (
      Line(
      points={{-79.1667,28.3333},{-74,28.3333},{-74,12},{-34,12},{-34,28.3333},
          {-21.3333,28.3333}},
      color={255,0,255},
      pattern=LinePattern.Dash));
  connect(modeSet, boolPasThrDef.u) annotation (Line(
      points={{-136,-20},{-114,-20},{-114,-50},{-102,-50}},
      color={255,0,255},
      pattern=LinePattern.Dash));
  connect(boolPasThrDef.y, operationalEnvelope.modeSet) annotation (Line(
      points={{-79,-50},{-72,-50},{-72,12},{-34,12},{-34,28.3333},{-21.3333,
          28.3333}},
      color={255,0,255},
      pattern=LinePattern.Dash));
  connect(defrostControl.Pel_deFro, Pel_deFro) annotation (Line(
      points={{-90,40.6667},{-90,48},{116,48},{116,80},{130,80}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(antiFreeze.ySet,operationalEnvelope.yOut)
    annotation (Line(points={{18.6667,31.6667},{14,31.6667},{14,32},{10,32},{10,
          31.6667},{0.833333,31.6667}},        color={0,0,127}));
  connect(antiFreeze.modeSet, operationalEnvelope.modeOut)
    annotation (Line(points={{18.6667,28.3333},{14,28.3333},{14,28},{10,28},{10,
          28.3333},{0.833333,28.3333}},        color={255,0,255}));
  connect(antiFreeze.yOut, swiErr.u1) annotation (Line(points={{40.8333,31.6667},
          {78,31.6667},{78,8}},       color={0,0,127}));
  connect(antiFreeze.modeOut, modeOut) annotation (Line(points={{40.8333,
          28.3333},{114,28.3333},{114,-20},{130,-20}},
                                               color={255,0,255}));
  connect(sigBusHP, antiFreeze.sigBusHP) annotation (Line(
      points={{-129,-69},{-112,-69},{-112,-24},{-106,-24},{-106,-10},{14,-10},{14,
          24.25},{19.25,24.25}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(conTru.y, not1.u) annotation (Line(points={{21,-30},{30,-30},{30,-54},
          {-48,-54},{-48,-100},{-42,-100}},
                               color={255,0,255}));
  connect(antiFreeze.ERR, ERR_antFre) annotation (Line(points={{30,19.1667},{30,
          -32},{36,-32},{36,-74},{100,-74},{100,-130}},
                                 color={255,127,0}));
  connect(operationalEnvelope.ERR, ERR_opeEnv) annotation (Line(points={{-10,
          19.1667},{-10,-76},{64,-76},{64,-116},{60,-116},{60,-130}},
                                       color={255,127,0}));
  annotation (Documentation(revisions="<html><ul>
  <li>
    <i>November 26, 2018&#160;</i> by Fabian Wüllhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/RWTH-EBC/AixLib/issues/577\">#577</a>)
  </li>
</ul>
</html>", info="<html>
<p>
  Aggregation of the four main safety measurements of a heat pump. The
  order is based on the relevance to the real system. Only the
  AntiFreeze-Control is put last because of the relevance for the
  simulation. If the medium temperature falls below the critical value,
  the simulation will fail.
</p>
<p>
  All used functions are optional. See the used models for more info on
  each safety function:
</p>
<ul>
  <li>
    <a href=
    \"modelica://IBPSA.Controls.HeatPump.SafetyControls.DefrostControl\">
    DefrostControl</a>
  </li>
  <li>
    <a href=
    \"modelica://IBPSA.Controls.HeatPump.SafetyControls.OnOffControl+\">OnOffControl</a>
  </li>
  <li>
    <a href=
    \"modelica://IBPSA.Controls.HeatPump.SafetyControls.OperationalEnvelope\">
    OperationalEnvelope</a>
  </li>
  <li>
    <a href=
    \"modelica://IBPSA.Controls.HeatPump.SafetyControls.AntiFreeze\">AntiFreeze</a>
  </li>
</ul>
<p>
  The safety function for the anti legionella control is placed inside
  the model <a href=
  \"modelica://IBPSA.Controls.HeatPump.HPControl\">HPControl</a>
</p>
</html>"));
end SafetyControl;

within IBPSA.Fluid.HeatPumps.SafetyControls;
block SafetyControl "Block including all safety levels"
  extends BaseClasses.PartialSafetyControl;
  parameter Modelica.Units.SI.MassFlowRate mEva_flow_nominal
    "Minimal mass flow rate in evaporator required to operate the device"
    annotation (Dialog(group="Mass flow rates"));
  parameter Modelica.Units.SI.MassFlowRate mCon_flow_nominal
    "Minimal mass flow rate in condenser required to operate the device"
    annotation (Dialog(group="Mass flow rates"));
  parameter Real ySet_small
    "Value of ySet at which the device is considered turned on. 
    Default is 1 % as heat pumps and chillers currently invert down to 15 %";

  replaceable parameter
    RecordsCollection.HeatPumpSafetyControlBaseDataDefinition safCtrlPar
    constrainedby RecordsCollection.HeatPumpSafetyControlBaseDataDefinition
    "Safety control parameters"
    annotation (choicesAllMatching=true, Placement(transformation(extent={{-118,
            102},{-104,118}})));
  IBPSA.Fluid.HeatPumps.SafetyControls.OperationalEnvelope operationalEnvelope(
    final use_opeEnv=safCtrlPar.use_opeEnv,
    final tabUpp=safCtrlPar.tabUpp,
    final use_opeEnvFroRec=safCtrlPar.use_opeEnvFroRec,
    final datTab=safCtrlPar.datTab,
    final dTHyst=safCtrlPar.dTHystOperEnv) "Block for operational envelope"
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));
  IBPSA.Fluid.HeatPumps.SafetyControls.OnOffControl onOffController(
    final minRunTime=safCtrlPar.minRunTime,
    final minLocTime=safCtrlPar.minLocTime,
    final use_minRunTime=safCtrlPar.use_minRunTime,
    final use_minLocTime=safCtrlPar.use_minLocTime,
    final use_runPerHou=safCtrlPar.use_runPerHou,
    final maxRunPerHou=safCtrlPar.maxRunPerHou,
    final preYSet_start=safCtrlPar.preYSet_start,
    final ySet_small=ySet_small,
    final ySetMin=safCtrlPar.ySetMin) "On off control block"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));

  IBPSA.Fluid.HeatPumps.SafetyControls.DefrostControl defrostControl(
    final minIceFac=safCtrlPar.minIceFac,
    final deaIciFac=safCtrlPar.deltaIceFac,
    final use_chiller=safCtrlPar.use_chiller,
    final conPelDeFro=safCtrlPar.calcPel_deFro) if safCtrlPar.use_deFro
    "Defrost control"
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
  Modelica.Blocks.Routing.RealPassThrough realPasThrDef
    if not safCtrlPar.use_deFro
    "No 2. Layer"
    annotation (Placement(transformation(extent={{-100,60},{-80,80}})),
      choicesAllMatching=true);
  Modelica.Blocks.Interfaces.RealOutput Pel_deFro
    if not safCtrlPar.use_chiller and safCtrlPar.use_deFro
    "Relative speed of compressor. From 0 to 1" annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={130,80})));
  IBPSA.Fluid.HeatPumps.SafetyControls.AntiFreeze antiFreeze(final TAntFre=
        safCtrlPar.TAntFre, final use_antFre=safCtrlPar.use_antFre)
    "Block for anti freezing in simulation"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
  Modelica.Blocks.Routing.BooleanPassThrough boolPasThrDef
    if not safCtrlPar.use_deFro
    "No 2. Layer" annotation (
      Placement(transformation(extent={{-100,-60},{-80,-40}})),
      choicesAllMatching=true);
  Modelica.Blocks.Interfaces.IntegerOutput opeEnvErr if safCtrlPar.use_opeEnv
    "Number off errors due to operational envelope"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-10,-130})));
  Modelica.Blocks.Interfaces.IntegerOutput antFreErr if safCtrlPar.use_antFre
    "Number off errors due to anti freezing"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={30,-130})));

  MinimalVolumeFlowRateSafety minimalVolumeFlowRateSafety(
    final use_minFloCon=safCtrlPar.use_minFlowCtrl,
    final mEvaMin_flow=safCtrlPar.m_flowEvaMinPer*mEva_flow_nominal,
    final mConMin_flow=safCtrlPar.m_flowConMinPer*mCon_flow_nominal)
    "Block to ensure minimal flow rates"
    annotation (Placement(transformation(extent={{60,20},{80,40}})));

  Modelica.Blocks.Interfaces.IntegerOutput minFlowErr
    "Number off errors due to minimal flow rates"                annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={70,-130})));
equation
  connect(onOffController.yOut, operationalEnvelope.ySet) annotation (Line(
        points={{-39.1667,31.6667},{-34,31.6667},{-34,32},{-30,32},{-30,31.6667},
          {-21.3333,31.6667}}, color=
         {0,0,127}));

  connect(sigBus, onOffController.sigBus) annotation (Line(
      points={{-129,-69},{-112,-69},{-112,-10},{-66,-10},{-66,24.25},{-60.75,24.25}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));

  connect(sigBus, operationalEnvelope.sigBus) annotation (Line(
      points={{-129,-69},{-112,-69},{-112,-10},{-28,-10},{-28,24.25},{-20.75,24.25}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));

  connect(sigBus, defrostControl.sigBus) annotation (Line(
      points={{-129,-69},{-112,-69},{-112,24.25},{-100.75,24.25}},
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
      points={{-79,70},{-74,70},{-74,31.6667},{-61.3333,31.6667}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(modeSet, defrostControl.modeSet) annotation (Line(
      points={{-136,-20},{-114,-20},{-114,28.3333},{-101.333,28.3333}},
      color={255,0,255},
      pattern=LinePattern.Dash));
  connect(defrostControl.yOut, onOffController.ySet) annotation (Line(
      points={{-79.1667,31.6667},{-74,31.6667},{-74,32},{-70,32},{-70,31.6667},
          {-61.3333,31.6667}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(modeSet, boolPasThrDef.u) annotation (Line(
      points={{-136,-20},{-114,-20},{-114,-50},{-102,-50}},
      color={255,0,255},
      pattern=LinePattern.Dash));
  connect(defrostControl.PelDeFro, Pel_deFro) annotation (Line(
      points={{-90,40.8333},{-90,48},{116,48},{116,80},{130,80}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(antiFreeze.ySet,operationalEnvelope.yOut)
    annotation (Line(points={{18.6667,31.6667},{14,31.6667},{14,32},{10,32},{10,
          31.6667},{0.833333,31.6667}},        color={0,0,127}));
  connect(antiFreeze.modeSet, operationalEnvelope.modeOut)
    annotation (Line(points={{18.6667,28.3333},{14,28.3333},{14,28},{10,28},{10,
          28.3333},{0.833333,28.3333}},        color={255,0,255}));
  connect(sigBus, antiFreeze.sigBus) annotation (Line(
      points={{-129,-69},{-112,-69},{-112,-10},{14,-10},{14,24.25},{19.25,24.25}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));

  connect(antiFreeze.err, antFreErr)
    annotation (Line(points={{30,19.1667},{30,-130}}, color={255,127,0}));
  connect(operationalEnvelope.err, opeEnvErr)
    annotation (Line(points={{-10,19.1667},{-10,-130}}, color={255,127,0}));
  connect(antiFreeze.yOut, minimalVolumeFlowRateSafety.ySet)
    annotation (Line(points={{40.8333,31.6667},{46,31.6667},{46,32},{50,32},{50,
          31.6667},{58.6667,31.6667}},          color={0,0,127}));
  connect(antiFreeze.modeOut, minimalVolumeFlowRateSafety.modeSet)
    annotation (
      Line(points={{40.8333,28.3333},{46,28.3333},{46,28},{50,28},{50,28.3333},
          {58.6667,28.3333}},
                          color={255,0,255}));
  connect(minimalVolumeFlowRateSafety.modeOut, modeOut)
    annotation (Line(points={{80.8333,28.3333},{112,28.3333},{112,-20},{130,-20}},
                                                       color={255,0,255}));
  connect(minimalVolumeFlowRateSafety.yOut, yOut)
    annotation (Line(points={{80.8333,31.6667},{116,31.6667},{116,20},{130,20}},
                                                     color={0,0,127}));
  connect(sigBus, minimalVolumeFlowRateSafety.sigBus)
    annotation (Line(
      points={{-129,-69},{-112,-69},{-112,-10},{56,-10},{56,24.25},{59.25,24.25}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));

  connect(minimalVolumeFlowRateSafety.err, minFlowErr)
    annotation (Line(points={{70,19.1667},{70,-130}}, color={255,127,0}));
  connect(defrostControl.modeOut, onOffController.modeSet) annotation (Line(
        points={{-79.1667,28.3333},{-74,28.3333},{-74,28},{-70,28},{-70,28.3333},
          {-61.3333,28.3333}}, color={255,0,255}));
  connect(onOffController.modeOut, operationalEnvelope.modeSet) annotation (
      Line(points={{-39.1667,28.3333},{-34,28.3333},{-34,28},{-30,28},{-30,
          28.3333},{-21.3333,28.3333}}, color={255,0,255}));
  connect(onOffController.modeSet, boolPasThrDef.y)
  annotation (Line(points={{-61.3333,28.3333},{-74,28.3333},{-74,-50},{-79,-50}},
                                                       color={255,0,
          255}));
  annotation (Documentation(revisions="<html><ul>
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
</html>", info="<html>
<p>Aggregation of the four main safety measurements of a heat pump. 
The order is based on the relevance to the real system. 
Anti freeze control and mininmal volume flow rate control is put last 
because of the relevance for the simulation. If the medium temperature 
falls below or rises above the critical value, the simulation will fail. </p>
<p>All used functions are optional. 
See the used models for more info on each safety function: </p>
<ul>
<li><a href=\"modelica://IBPSA.Fluid.HeatPumps.SafetyControls.DefrostControl\">
IBPSA.Fluid.HeatPumps.SafetyControls.DefrostControl</a> </li>
<li><a href=\"modelica://IBPSA.Fluid.HeatPumps.SafetyControls.OnOffControl+\">
IBPSA.Fluid.HeatPumps.SafetyControls.OnOffControl</a> </li>
<li><a href=\"modelica://IBPSA.Fluid.HeatPumps.SafetyControls.OperationalEnvelope\">
IBPSA.Fluid.HeatPumps.SafetyControls.OperationalEnvelope</a> </li>
<li><a href=\"modelica://IBPSA.Fluid.HeatPumps.SafetyControls.AntiFreeze\">
IBPSA.Fluid.HeatPumps.SafetyControls.AntiFreeze</a> </li>
<li><a href=\"modelica://IBPSA.Fluid.HeatPumps.SafetyControls.MinimalVolumeFlowRateSafety\">
IBPSA.Fluid.HeatPumps.SafetyControls.MinimalVolumeFlowRateSafety</a> </li>
</ul>
</html>"));
end SafetyControl;

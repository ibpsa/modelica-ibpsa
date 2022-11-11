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
  IBPSA.Fluid.HeatPumps.SafetyControls.OperationalEnvelope opeEnv(
    final tabUpp=safCtrlPar.tabUpp,
    final use_opeEnvFroRec=safCtrlPar.use_opeEnvFroRec,
    final datTab=safCtrlPar.datTab,
    final dTHyst=safCtrlPar.dTHystOperEnv) if safCtrlPar.use_opeEnv
    "Block for operational envelope"
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));
  IBPSA.Fluid.HeatPumps.SafetyControls.OnOffControl onOffCtrl(
    final minRunTime=safCtrlPar.minRunTime,
    final minLocTime=safCtrlPar.minLocTime,
    final use_minRunTime=safCtrlPar.use_minRunTime,
    final use_minLocTime=safCtrlPar.use_minLocTime,
    final use_runPerHou=safCtrlPar.use_runPerHou,
    final maxRunPerHou=safCtrlPar.maxRunPerHou,
    final preYSet_start=safCtrlPar.preYSet_start,
    final ySet_small=ySet_small,
    final ySetMin=safCtrlPar.ySetMin) if safCtrlPar.use_minRunTime or
    safCtrlPar.use_minLocTime or safCtrlPar.use_runPerHou "On off control block"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));

  IBPSA.Fluid.HeatPumps.SafetyControls.DefrostControl defCtrl(
    final minIceFac=safCtrlPar.minIceFac,
    final deaIciFac=safCtrlPar.deltaIceFac,
    final use_chiller=safCtrlPar.use_chiller,
    final conPelDeFro=safCtrlPar.calcPel_deFro) if safCtrlPar.use_deFro
    "Defrost control"
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
  Modelica.Blocks.Routing.RealPassThrough realPasThrDef
    if not safCtrlPar.use_deFro "No defrost control"
    annotation (Placement(transformation(extent={{-100,60},{-80,80}})),
      choicesAllMatching=true);
  Modelica.Blocks.Interfaces.RealOutput Pel_deFro
    if not safCtrlPar.use_chiller and safCtrlPar.use_deFro
    "Relative speed of compressor. From 0 to 1" annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={130,80})));
  IBPSA.Fluid.HeatPumps.SafetyControls.AntiFreeze antFre(final TAntFre=
        safCtrlPar.TAntFre) if safCtrlPar.use_antFre
    "Block for anti freezing in simulation"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
  Modelica.Blocks.Routing.BooleanPassThrough boolPasThrDef
    if not safCtrlPar.use_deFro "No defrost control"
                  annotation (
      Placement(transformation(extent={{-80,-40},{-60,-20}})),
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

  MinimalVolumeFlowRateSafety minVolFloRatSaf(final mEvaMin_flow=safCtrlPar.m_flowEvaMinPer
        *mEva_flow_nominal, final mConMin_flow=safCtrlPar.m_flowConMinPer*
        mCon_flow_nominal) if safCtrlPar.use_minFlowCtrl
    "Block to ensure minimal flow rates"
    annotation (Placement(transformation(extent={{60,20},{80,40}})));

  Modelica.Blocks.Interfaces.IntegerOutput minFlowErr
    if safCtrlPar.use_minFlowCtrl
    "Number off errors due to minimal flow rates"                annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={70,-130})));
  Modelica.Blocks.Interfaces.BooleanInput revSet "Set value of operation mode"
    annotation (Placement(transformation(extent={{-132,-36},{-100,-4}}),
        iconTransformation(extent={{-132,-36},{-100,-4}})));
  Modelica.Blocks.Interfaces.BooleanOutput revOut
    "Set value of operation mode" annotation (Placement(transformation(extent={{
            100,-36},{132,-4}}), iconTransformation(extent={{100,-40},{132,-8}})));
  Modelica.Blocks.Routing.RealPassThrough realPasThrOnOff if not (safCtrlPar.use_minRunTime
     or safCtrlPar.use_minLocTime or safCtrlPar.use_runPerHou)
    "No on off controllers" annotation (Placement(transformation(extent={{-60,60},
            {-40,80}})), choicesAllMatching=true);
  Modelica.Blocks.Routing.RealPassThrough realPasThrOpeEnv
    if not safCtrlPar.use_opeEnv "No oeprational envelope control" annotation (
      Placement(transformation(extent={{-20,60},{0,80}})), choicesAllMatching=true);
  Modelica.Blocks.Routing.RealPassThrough realPasThrAntFre
    if not safCtrlPar.use_antFre "No anti freeze control" annotation (Placement(
        transformation(extent={{20,60},{40,80}})), choicesAllMatching=true);
  Modelica.Blocks.Routing.RealPassThrough realPasThrMinVolRat
    if not safCtrlPar.use_minFlowCtrl "No minimale volumen flow rate control"
    annotation (Placement(transformation(extent={{60,60},{80,80}})),
      choicesAllMatching=true);
  Modelica.Blocks.Interfaces.IntegerOutput defErr if safCtrlPar.use_deFro
    "Number off defrost cycles" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-40,-130})));
equation

  connect(sigBus, onOffCtrl.sigBus) annotation (Line(
      points={{-105,-71},{-112,-71},{-112,-10},{-66,-10},{-66,22.9},{-60.5,22.9}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));

  connect(sigBus, opeEnv.sigBus) annotation (Line(
      points={{-105,-71},{-112,-71},{-112,-10},{-28,-10},{-28,22.9},{-20.5,22.9}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));

  connect(sigBus, defCtrl.sigBus) annotation (Line(
      points={{-105,-71},{-112,-71},{-112,22.9},{-100.5,22.9}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
  connect(ySet, defCtrl.ySet) annotation (Line(
      points={{-116,20},{-116,18},{-110,18},{-110,24},{-108,24},{-108,32},{
          -101.6,32}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(ySet, realPasThrDef.u) annotation (Line(
      points={{-116,20},{-110,20},{-110,70},{-102,70}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(revSet, defCtrl.revSet) annotation (Line(
      points={{-116,-20},{-114,-20},{-114,28},{-101.6,28}},
      color={255,0,255},
      pattern=LinePattern.Dash));
  connect(revSet, boolPasThrDef.u) annotation (Line(
      points={{-116,-20},{-92,-20},{-92,-30},{-82,-30}},
      color={255,0,255},
      pattern=LinePattern.Dash));
  connect(defCtrl.PelDeFro, Pel_deFro) annotation (Line(
      points={{-79,38},{-79,48},{116,48},{116,80},{130,80}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(sigBus, antFre.sigBus) annotation (Line(
      points={{-105,-71},{-112,-71},{-112,-10},{14,-10},{14,22.9},{19.5,22.9}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));

  connect(antFre.err, antFreErr) annotation (Line(points={{43,20},{43,-54},{30,
          -54},{30,-130}},          color={255,127,0}));
  connect(opeEnv.err, opeEnvErr) annotation (Line(points={{3,20},{3,-54},{-10,
          -54},{-10,-130}},           color={255,127,0}));
  connect(minVolFloRatSaf.yOut, yOut) annotation (Line(
      points={{81,32},{88,32},{88,20},{110,20}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(sigBus, minVolFloRatSaf.sigBus) annotation (Line(
      points={{-105,-71},{-112,-71},{-112,-10},{56,-10},{56,22.9},{59.5,22.9}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));

  connect(minVolFloRatSaf.err, minFlowErr) annotation (Line(points={{83,20},{83,
          -54},{70,-54},{70,-130}},          color={255,127,0}));
  connect(boolPasThrDef.y, revOut) annotation (Line(points={{-59,-30},{-48,-30},
          {-48,-20},{116,-20}},color={255,0,255},
      pattern=LinePattern.Dash));
  connect(realPasThrDef.y, realPasThrOnOff.u)
    annotation (Line(points={{-79,70},{-62,70}}, color={0,0,127}));
  connect(realPasThrOnOff.y, realPasThrOpeEnv.u)
    annotation (Line(points={{-39,70},{-22,70}}, color={0,0,127}));
  connect(realPasThrOpeEnv.y, realPasThrAntFre.u)
    annotation (Line(points={{1,70},{18,70}}, color={0,0,127}));
  connect(realPasThrAntFre.y, realPasThrMinVolRat.u)
    annotation (Line(points={{41,70},{58,70}}, color={0,0,127}));
  connect(realPasThrMinVolRat.y, yOut) annotation (Line(
      points={{81,70},{92,70},{92,20},{110,20}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(defCtrl.yOut, onOffCtrl.ySet) annotation (Line(points={{-79,32},{-76,
          32},{-76,32},{-70,32},{-70,32},{-61.6,32}}, color={0,0,127}));
  connect(onOffCtrl.yOut, opeEnv.ySet) annotation (Line(points={{-39,32},{-36,
          32},{-36,32},{-30,32},{-30,32},{-21.6,32}},
        color={0,0,127}));
  connect(opeEnv.yOut, antFre.ySet) annotation (Line(points={{1,32},{4,32},{4,
          32},{10,32},{10,32},{18.4,32}},                             color={0,0,
          127}));
  connect(antFre.yOut, minVolFloRatSaf.ySet) annotation (Line(points={{41,32},{
          44,32},{44,32},{50,32},{50,32},{58.4,32}},                    color={0,
          0,127}));
  connect(antFre.yOut, realPasThrMinVolRat.u) annotation (Line(
      points={{41,32},{41,32},{52,32},{52,70},{58,70}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(realPasThrAntFre.y, minVolFloRatSaf.ySet) annotation (Line(
      points={{41,70},{52,70},{52,32},{58.4,32}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(opeEnv.yOut, realPasThrAntFre.u) annotation (Line(
      points={{1,32},{1,32},{12,32},{12,70},{18,70}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(realPasThrOpeEnv.y, antFre.ySet) annotation (Line(
      points={{1,70},{12,70},{12,32},{18.4,32}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(onOffCtrl.yOut, realPasThrOpeEnv.u) annotation (Line(
      points={{-39,32},{-39,32},{-32,32},{-32,70},{-22,70}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(realPasThrOnOff.y, opeEnv.ySet) annotation (Line(
      points={{-39,70},{-32,70},{-32,32},{-26,32},{-26,32},{-21.6,32}},
      color={0,0,127},
      pattern=LinePattern.Dash));

  connect(defCtrl.yOut, realPasThrOnOff.u) annotation (Line(
      points={{-79,32},{-79,32},{-68,32},{-68,70},{-62,70}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(realPasThrDef.y, onOffCtrl.ySet) annotation (Line(
      points={{-79,70},{-68,70},{-68,32},{-61.6,32}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(defCtrl.err, defErr) annotation (Line(points={{-77,20},{-78,20},{-78,
          -2},{-40,-2},{-40,-130}}, color={255,127,0}));
  connect(defCtrl.revOut, revOut) annotation (Line(
      points={{-79,27.6},{-72,27.6},{-72,-14},{-48,-14},{-48,-20},{116,-20}},
      color={255,0,255},
      pattern=LinePattern.Dash));
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

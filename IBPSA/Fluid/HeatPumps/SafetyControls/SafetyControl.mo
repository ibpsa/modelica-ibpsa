within IBPSA.Fluid.HeatPumps.SafetyControls;
model SafetyControl "Model including all safety levels"
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
    RecordsCollection.PartialRefrigerantMachineSafetyControlBaseDataDefinition
    safCtrlPar constrainedby
    RecordsCollection.PartialRefrigerantMachineSafetyControlBaseDataDefinition
    "Safety control parameters" annotation (choicesAllMatching=true, Placement(
        transformation(extent={{-118,102},{-104,118}})));
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

  IBPSA.Fluid.HeatPumps.SafetyControls.AntiFreeze antFre(final TAntFre=
        safCtrlPar.TAntFre, final dTHys=safCtrlPar.dTHysAntFre)
                            if safCtrlPar.use_antFre
    "Block for anti freezing in simulation"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
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
equation

  connect(sigBus, onOffCtrl.sigBus) annotation (Line(
      points={{-125,-71},{-112,-71},{-112,-10},{-66,-10},{-66,22.9},{-62.5,22.9}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));

  connect(sigBus, opeEnv.sigBus) annotation (Line(
      points={{-125,-71},{-112,-71},{-112,-10},{-28,-10},{-28,22.9},{-22.5,22.9}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));

  connect(sigBus, antFre.sigBus) annotation (Line(
      points={{-125,-71},{-112,-71},{-112,-10},{14,-10},{14,22.9},{17.5,22.9}},
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
      points={{83,32},{88,32},{88,20},{130,20}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(sigBus, minVolFloRatSaf.sigBus) annotation (Line(
      points={{-125,-71},{-112,-71},{-112,-10},{56,-10},{56,22.9},{57.5,22.9}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));

  connect(minVolFloRatSaf.err, minFlowErr) annotation (Line(points={{83,20},{83,
          -54},{70,-54},{70,-130}},          color={255,127,0}));
  connect(realPasThrOnOff.y, realPasThrOpeEnv.u)
    annotation (Line(points={{-39,70},{-22,70}}, color={0,0,127}));
  connect(realPasThrOpeEnv.y, realPasThrAntFre.u)
    annotation (Line(points={{1,70},{18,70}}, color={0,0,127}));
  connect(realPasThrAntFre.y, realPasThrMinVolRat.u)
    annotation (Line(points={{41,70},{58,70}}, color={0,0,127}));
  connect(realPasThrMinVolRat.y, yOut) annotation (Line(
      points={{81,70},{92,70},{92,20},{130,20}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(onOffCtrl.yOut, opeEnv.ySet) annotation (Line(points={{-37,32},{-36,
          32},{-36,32},{-30,32},{-30,32},{-23.6,32}},
        color={0,0,127}));
  connect(opeEnv.yOut, antFre.ySet) annotation (Line(points={{3,32},{4,32},{4,
          32},{10,32},{10,32},{16.4,32}},                             color={0,0,
          127}));
  connect(antFre.yOut, minVolFloRatSaf.ySet) annotation (Line(points={{43,32},{
          44,32},{44,32},{50,32},{50,32},{56.4,32}},                    color={0,
          0,127}));
  connect(antFre.yOut, realPasThrMinVolRat.u) annotation (Line(
      points={{43,32},{43,32},{52,32},{52,70},{58,70}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(realPasThrAntFre.y, minVolFloRatSaf.ySet) annotation (Line(
      points={{41,70},{52,70},{52,32},{56.4,32}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(opeEnv.yOut, realPasThrAntFre.u) annotation (Line(
      points={{3,32},{3,32},{12,32},{12,70},{18,70}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(realPasThrOpeEnv.y, antFre.ySet) annotation (Line(
      points={{1,70},{12,70},{12,32},{16.4,32}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(onOffCtrl.yOut, realPasThrOpeEnv.u) annotation (Line(
      points={{-37,32},{-37,32},{-32,32},{-32,70},{-22,70}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(realPasThrOnOff.y, opeEnv.ySet) annotation (Line(
      points={{-39,70},{-32,70},{-32,32},{-26,32},{-26,32},{-23.6,32}},
      color={0,0,127},
      pattern=LinePattern.Dash));

  connect(ySet, onOffCtrl.ySet) annotation (Line(
      points={{-136,20},{-82,20},{-82,32},{-63.6,32}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(ySet, realPasThrOnOff.u) annotation (Line(
      points={{-136,20},{-82,20},{-82,70},{-62,70}},
      color={0,0,127},
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
<p>Aggregation of the four main safety measurements of a refrigerant machine (heat pump or chiller). </p>
<p>The order is based on the relevance to the real system. Anti freeze control and mininmal volume flow rate control is put last because of the relevance for the simulation. If the medium temperature falls below or rises above the critical value, the simulation will fail. </p>
<p>All used functions are optional. See the used models for more info on each safety function: </p>
<ul>
<li><a href=\"modelica://IBPSA.Fluid.HeatPumps.SafetyControls.OnOffControl+\">IBPSA.Fluid.HeatPumps.SafetyControls.OnOffControl</a> </li>
<li><a href=\"modelica://IBPSA.Fluid.HeatPumps.SafetyControls.OperationalEnvelope\">IBPSA.Fluid.HeatPumps.SafetyControls.OperationalEnvelope</a> </li>
<li><a href=\"modelica://IBPSA.Fluid.HeatPumps.SafetyControls.AntiFreeze\">IBPSA.Fluid.HeatPumps.SafetyControls.AntiFreeze</a> </li>
<li><a href=\"modelica://IBPSA.Fluid.HeatPumps.SafetyControls.MinimalVolumeFlowRateSafety\">IBPSA.Fluid.HeatPumps.SafetyControls.MinimalVolumeFlowRateSafety</a> </li>
</ul>
</html>"));
end SafetyControl;

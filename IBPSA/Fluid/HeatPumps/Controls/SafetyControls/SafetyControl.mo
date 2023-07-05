within IBPSA.Fluid.HeatPumps.Controls.SafetyControls;
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
  parameter Boolean forHeaPum
    "=true if model is for heat pump, false for chillers";

  replaceable parameter
    IBPSA.Fluid.HeatPumps.Controls.SafetyControls.RecordsCollection.PartialRefrigerantMachineSafetyControlBaseDataDefinition
    safCtrPar constrainedby
    IBPSA.Fluid.HeatPumps.Controls.SafetyControls.RecordsCollection.PartialRefrigerantMachineSafetyControlBaseDataDefinition
    "Safety control parameters" annotation (choicesAllMatching=true, Placement(
        transformation(extent={{-118,102},{-104,118}})));
  IBPSA.Fluid.HeatPumps.Controls.SafetyControls.OperationalEnvelope opeEnv(
    final tabUppHea=safCtrPar.tabUppHea,
    final tabLowCoo=safCtrPar.tabLowCoo,
    final forHeaPum=forHeaPum,
    final use_TUseOut=safCtrPar.use_TUseOut,
    final use_TNotUseOut=safCtrPar.use_TNotUseOut,
    final dTHys=safCtrPar.dTHysOpeEnv) if safCtrPar.use_opeEnv
    "Block for operational envelope"
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));
  IBPSA.Fluid.HeatPumps.Controls.SafetyControls.OnOffControl onOffCtr(
    final minRunTime=safCtrPar.minRunTime,
    final minLocTime=safCtrPar.minLocTime,
    final use_minRunTime=safCtrPar.use_minRunTime,
    final use_minLocTime=safCtrPar.use_minLocTime,
    final use_runPerHou=safCtrPar.use_runPerHou,
    final maxRunPerHou=safCtrPar.maxRunPerHou,
    final preYSet_start=safCtrPar.preYSet_start,
    final ySet_small=ySet_small,
    final ySetMin=safCtrPar.ySetMin) if safCtrPar.use_minRunTime or safCtrPar.use_minLocTime
     or safCtrPar.use_runPerHou "On off control block"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));

  IBPSA.Fluid.HeatPumps.Controls.SafetyControls.AntiFreeze antFre(final TAntFre
      =safCtrPar.TAntFre, final dTHys=safCtrPar.dTHysAntFre)
    if safCtrPar.use_antFre "Block for anti freezing in simulation"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
  Modelica.Blocks.Interfaces.IntegerOutput opeEnvErr if safCtrPar.use_opeEnv
    "Number off errors due to operational envelope"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-10,-130})));
  Modelica.Blocks.Interfaces.IntegerOutput antFreErr if safCtrPar.use_antFre
    "Number off errors due to anti freezing"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={30,-130})));

  IBPSA.Fluid.HeatPumps.Controls.SafetyControls.MinimalVolumeFlowRateSafety minVolFloRatSaf(final
      mEvaMin_flow=safCtrPar.m_flowEvaMinPer*mEva_flow_nominal, final
      mConMin_flow=safCtrPar.m_flowConMinPer*mCon_flow_nominal)
    if safCtrPar.use_minFlowCtr "Block to ensure minimal flow rates"
    annotation (Placement(transformation(extent={{60,20},{80,40}})));

  Modelica.Blocks.Interfaces.IntegerOutput minFlowErr
    if safCtrPar.use_minFlowCtr
    "Number off errors due to minimal flow rates"                annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={70,-130})));
  Modelica.Blocks.Routing.RealPassThrough reaPasThrOnOff if not (
    safCtrPar.use_minRunTime or safCtrPar.use_minLocTime or
    safCtrPar.use_runPerHou)
    "No on off controllers" annotation (
                         choicesAllMatching=true, Placement(transformation(
          extent={{-60,60},{-40,80}})));
  Modelica.Blocks.Routing.RealPassThrough reaPasThrOpeEnv
    if not safCtrPar.use_opeEnv "No oeprational envelope control"  annotation (
                                                           choicesAllMatching=true,
      Placement(transformation(extent={{-20,60},{0,80}})));
  Modelica.Blocks.Routing.RealPassThrough reaPasThrAntFre
    if not safCtrPar.use_antFre "No anti freeze control"  annotation (
                                                   choicesAllMatching=true,
      Placement(transformation(extent={{20,60},{40,80}})));
  Modelica.Blocks.Routing.RealPassThrough reaPasThrMinVolRat
    if not safCtrPar.use_minFlowCtr  "No minimale volumen flow rate control"
    annotation (
      choicesAllMatching=true, Placement(transformation(extent={{60,60},{80,80}})));
equation

  connect(sigBus, onOffCtr.sigBus) annotation (Line(
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
  connect(reaPasThrOnOff.y, reaPasThrOpeEnv.u)
    annotation (Line(points={{-39,70},{-22,70}}, color={0,0,127}));
  connect(reaPasThrOpeEnv.y, reaPasThrAntFre.u)
    annotation (Line(points={{1,70},{18,70}}, color={0,0,127}));
  connect(reaPasThrAntFre.y, reaPasThrMinVolRat.u)
    annotation (Line(points={{41,70},{58,70}}, color={0,0,127}));
  connect(reaPasThrMinVolRat.y, yOut) annotation (Line(
      points={{81,70},{92,70},{92,20},{130,20}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(onOffCtr.yOut, opeEnv.ySet) annotation (Line(points={{-37,32},{-36,32},
          {-36,32},{-30,32},{-30,32},{-23.6,32}}, color={0,0,127}));
  connect(opeEnv.yOut, antFre.ySet) annotation (Line(points={{3,32},{4,32},{4,
          32},{10,32},{10,32},{16.4,32}},                             color={0,0,
          127}));
  connect(antFre.yOut, minVolFloRatSaf.ySet) annotation (Line(points={{43,32},{
          44,32},{44,32},{50,32},{50,32},{56.4,32}},                    color={0,
          0,127}));
  connect(antFre.yOut, reaPasThrMinVolRat.u) annotation (Line(
      points={{43,32},{43,32},{52,32},{52,70},{58,70}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(reaPasThrAntFre.y, minVolFloRatSaf.ySet) annotation (Line(
      points={{41,70},{52,70},{52,32},{56.4,32}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(opeEnv.yOut, reaPasThrAntFre.u) annotation (Line(
      points={{3,32},{3,32},{12,32},{12,70},{18,70}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(reaPasThrOpeEnv.y, antFre.ySet) annotation (Line(
      points={{1,70},{12,70},{12,32},{16.4,32}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(onOffCtr.yOut, reaPasThrOpeEnv.u) annotation (Line(
      points={{-37,32},{-37,32},{-32,32},{-32,70},{-22,70}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(reaPasThrOnOff.y, opeEnv.ySet) annotation (Line(
      points={{-39,70},{-32,70},{-32,32},{-26,32},{-26,32},{-23.6,32}},
      color={0,0,127},
      pattern=LinePattern.Dash));

  connect(ySet, onOffCtr.ySet) annotation (Line(
      points={{-136,20},{-82,20},{-82,32},{-63.6,32}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(ySet, reaPasThrOnOff.u) annotation (Line(
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
<p>
  Aggregation of the four main safety measurements 
  of a refrigerant machine (heat pump or chiller).
</p>
<p>
  The order is based on the relevance to the real system. 
  Anti freeze control and mininmal volume flow rate control is put 
  last because of the relevance for the simulation. 
  If the medium temperature falls below or rises above the 
  critical value, the simulation will fail.
</p>
<p>
All used functions are optional. See the used models for more 
info on each safety function:
</p>
<ul>
<li><a href=\"modelica://IBPSA.Fluid.HeatPumps.Controls.SafetyControls.OnOffControl+\">
IBPSA.Fluid.HeatPumps.SafetyControls.OnOffControl</a> </li>
<li><a href=\"modelica://IBPSA.Fluid.HeatPumps.Controls.SafetyControls.OperationalEnvelope\">
IBPSA.Fluid.HeatPumps.SafetyControls.OperationalEnvelope</a> </li>
<li><a href=\"modelica://IBPSA.Fluid.HeatPumps.Controls.SafetyControls.AntiFreeze\">
IBPSA.Fluid.HeatPumps.SafetyControls.AntiFreeze</a> </li>
<li><a href=\"modelica://IBPSA.Fluid.HeatPumps.Controls.SafetyControls.MinimalVolumeFlowRateSafety\">
IBPSA.Fluid.HeatPumps.SafetyControls.MinimalVolumeFlowRateSafety</a> </li>
</ul>
</html>"));
end SafetyControl;

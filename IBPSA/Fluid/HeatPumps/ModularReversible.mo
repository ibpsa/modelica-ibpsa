within IBPSA.Fluid.HeatPumps;
model ModularReversible
  "Grey-box model for reversible heat pumps using a black-box to simulate the refrigeration cycle"
  extends
    IBPSA.Fluid.HeatPumps.BaseClasses.PartialReversibleVapourCompressionMachine(
    mCon_flow_nominal=QUse_flow_nominal/(dTCon_nominal*cpCon),
    final scaFac=vapComCyc.blaBoxHeaPumHea.scaFac,
    use_rev=true,
    redeclare IBPSA.Fluid.HeatPumps.BaseClasses.BlackBoxVapourCompressionCycle
      vapComCyc(redeclare model BlackBoxHeatPumpHeating =
          BlackBoxHeatPumpHeating, redeclare model BlackBoxHeatPumpCooling =
          BlackBoxHeatPumpCooling));
  replaceable model BlackBoxHeatPumpHeating =
      IBPSA.Fluid.HeatPumps.BlackBoxData.BaseClasses.PartialHeatPumpBlackBox
     constrainedby
    IBPSA.Fluid.HeatPumps.BlackBoxData.BaseClasses.PartialHeatPumpBlackBox(
       final QUse_flow_nominal=QUse_flow_nominal,
       final TCon_nominal=TCon_nominal,
       final TEva_nominal=TEva_nominal,
       final dTCon_nominal=dTCon_nominal,
       final dTEva_nominal=dTEva_nominal,
       final mCon_flow_nominal=mCon_flow_nominal,
       final mEva_flow_nominal=mEva_flow_nominal,
       final y_nominal=y_nominal)
  "Black-box data of a heat pump in heating mode"
    annotation (choicesAllMatching=true);
  replaceable model BlackBoxHeatPumpCooling =
      IBPSA.Fluid.Chillers.BlackBoxData.BaseClasses.NoCooling
      constrainedby
    IBPSA.Fluid.Chillers.BlackBoxData.BaseClasses.PartialChillerBlackBox(
       final QUse_flow_nominal=vapComCyc.blaBoxHeaPumCoo.QUseBlaBox_flow_nominal,
       final scaFac=scaFac,
       final TCon_nominal=TCon_nominal,
       final TEva_nominal=TEva_nominal,
       final dTCon_nominal=dTCon_nominal,
       final dTEva_nominal=dTEva_nominal,
       final mCon_flow_nominal=mCon_flow_nominal,
       final mEva_flow_nominal=mEva_flow_nominal,
       final y_nominal=y_nominal)
  "Black-box data of a heat pump in cooling operation mode"
    annotation (Dialog(enable=use_rev),choicesAllMatching=true);
  replaceable parameter SafetyControls.RecordsCollection.DefaultSafetyControl
    safCtrlPar
    constrainedby
    IBPSA.Fluid.HeatPumps.SafetyControls.RecordsCollection.HeatPumpSafetyControlBaseDataDefinition
    "Safety control parameters"
    annotation (Dialog(enable=use_internalSafetyControl, group="Safety Control"),
    choicesAllMatching=true);
  IBPSA.Fluid.HeatPumps.SafetyControls.SafetyControl safetyControl(
    final mEva_flow_nominal=mEva_flow_nominal,
    final mCon_flow_nominal=mCon_flow_nominal,
    safCtrlPar=safCtrlPar,
    final ySet_small=ySet_small) if use_internalSafetyControl
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));

  Modelica.Blocks.Sources.BooleanConstant conHea(final k=true) if not
    use_busConnectorOnly and not use_rev and not use_internalSafetyControl
    "Set heating mode to true if device is not reversible" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-90,-110})));
  Modelica.Blocks.Interfaces.BooleanInput hea
    if not use_busConnectorOnly and use_rev
    "=true for heating, =false for cooling"
    annotation (Placement(transformation(extent={{-132,-106},{-100,-74}})));
equation
  connect(safetyControl.sigBus, sigBus) annotation (Line(
        points={{-62.5,-17.1},{-62.5,-16},{-76,-16},{-76,-43},{-105,-43}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%second",
        index=1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
  connect(safetyControl.yOut, sigBus.ySet) annotation (Line(points={{-37,-8},{-30,
          -8},{-30,-66},{-76,-66},{-76,-43},{-105,-43}},            color={0,0,127}),
      Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(ySet, safetyControl.ySet) annotation (Line(points={{-116,20},{-80,20},
          {-80,-8},{-63.6,-8}},                color={0,0,127}));
  connect(conHea.y, sigBus.hea)
    annotation (Line(points={{-79,-110},{-80,-110},{
          -80,-43},{-105,-43}}, color={255,0,255}));
  connect(hea, sigBus.hea)
    annotation (Line(points={{-116,-90},{-80,-90},{-80,-43},
          {-105,-43}}, color={255,0,255}));
  annotation (Icon(coordinateSystem(extent={{-100,-120},{100,120}}), graphics={
        Rectangle(
          extent={{-16,83},{16,-83}},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0},
          origin={1,-64},
          rotation=90),
        Rectangle(
          extent={{-17,83},{17,-83}},
          fillColor={255,0,128},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0},
          origin={1,61},
          rotation=90),
        Line(
          points={{-9,40},{9,40},{-5,-2},{9,-40},{-9,-40}},
          color={0,0,0},
          smooth=Smooth.None,
          origin={-3,-60},
          rotation=-90),
        Line(
          points={{9,40},{-9,40},{5,-2},{-9,-40},{9,-40}},
          color={0,0,0},
          smooth=Smooth.None,
          origin={-5,56},
          rotation=-90),
        Rectangle(
          extent={{-82,42},{84,-46}},
          lineColor={238,46,47},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Line(points={{-88,60},{88,60}}, color={28,108,200}),
        Line(points={{-88,-60},{88,-60}}, color={28,108,200}),
    Line(
    origin={-75.5,-80.333},
    points={{43.5,8.3333},{37.5,0.3333},{25.5,-1.667},{33.5,-9.667},{17.5,-11.667},{27.5,-21.667},{13.5,-23.667},
              {11.5,-31.667}},
      smooth=Smooth.Bezier,
      visible=use_evaCap),
        Polygon(
          points={{-70,-122},{-68,-108},{-58,-114},{-70,-122}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid,
          fillColor={0,0,0},
          visible=use_evaCap),
    Line( origin={40.5,93.667},
          points={{39.5,6.333},{37.5,0.3333},{25.5,-1.667},{33.5,-9.667},{17.5,
              -11.667},{27.5,-21.667},{13.5,-23.667},{11.5,-27.667}},
          smooth=Smooth.Bezier,
          visible=use_conCap),
        Polygon(
          points={{86,110},{84,96},{74,102},{86,110}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid,
          fillColor={0,0,0},
          visible=use_conCap),
        Line(
          points={{-42,72},{34,72}},
          color={0,0,0},
          arrow={Arrow.None,Arrow.Filled},
          thickness=0.5),
        Line(
          points={{-38,0},{38,0}},
          color={0,0,0},
          arrow={Arrow.None,Arrow.Filled},
          thickness=0.5,
          origin={0,-74},
          rotation=180)}),                Diagram(coordinateSystem(extent={{-100,
            -120},{100,120}})),
    Documentation(revisions="<html><ul>
  <li>
    <i>October 2, 2022</i> by Fabian Wuellhorst:<br/>
    Adjusted based on the discussion in this issue <a href=
    \"https://github.com/ibpsa/modelica-ibpsa/issues/1576\">#1576</a>)
  </li>
  <li>
    <i>May 22, 2019</i> by Julian Matthes:<br/>
    Rebuild due to the introducion of the thermal machine partial model
    (see issue <a href=
    \"https://github.com/RWTH-EBC/AixLib/issues/715\">AixLib #715</a>)
  </li>
  <li>
    <i>November 26, 2018&#160;</i> by Fabian Wuellhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/RWTH-EBC/AixLib/issues/577\">AixLib #577</a>)
  </li>
</ul>
</html>", info="<html>
<p>Adding to the concept described in <a href=\"modelica://IBPSA.Fluid.HeatPumps.BaseClasses.PartialReversibleVapourCompressionMachine\">IBPSA.Fluid.HeatPumps.BaseClasses.PartialReversibleVapourCompressionMachine</a>, this heat pump model for a reversible, modular heat pump adds safety controls of real devices.</p>
<p>As with all options, the safety controls are optional.</p>
<p><br>Using a signal bus as a connector, all relevant data is aggregated. In order to control both chillers and heat pumps, both flow and return temperature are aggregated. The <code>hea<\\code> signal chooses the operation type of the vapour compression machine: </p>
<p>hea = true: Main operation mode (heat pump: heating) </p>
<p>hea = false: Reversible operation mode (heat pump: cooling) </p>
</html>"));
end ModularReversible;

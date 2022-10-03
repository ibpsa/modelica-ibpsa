within IBPSA.Fluid.HeatPumps;
model HeatPump
  "Grey-box model for reversible heat pumps using a black-box to simulate the refrigeration cycle"
  extends
    IBPSA.Fluid.HeatPumps.BaseClasses.PartialReversibleVapourCompressionMachine(
    final autCalMCon_flow=max(4E-5*QUse_flow_nominal - 0.6162, autCalMMin_flow),
    final autCalMEva_flow=max(4E-5*QUse_flow_nominal - 0.3177, autCalMMin_flow),
    final autCalVCon=max(1E-7*QUse_flow_nominal - 94E-4, autCalVMin),
    final autCalVEva=max(1E-7*QUse_flow_nominal - 75E-4, autCalVMin),
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
       final mCon_flow_nominal=mCon_flow_nominal_final,
       final mEva_flow_nominal=mEva_flow_nominal_final,
       final y_nominal=y_nominal)
  "Black-box data of a heat pump in heating mode"
    annotation (choicesAllMatching=true);
  replaceable model BlackBoxHeatPumpCooling =
      IBPSA.Fluid.Chillers.BlackBoxData.BaseClasses.NoCooling
      constrainedby
      IBPSA.Fluid.Chillers.BlackBoxData.BaseClasses.PartialChillerBlackBox(
       final QUse_flow_nominal=0,
       final scaFac=scaFac,
       final TCon_nominal=TEva_nominal,
       final TEva_nominal=TCon_nominal,
       final dTCon_nominal=dTEva_nominal,
       final dTEva_nominal=dTCon_nominal,
       final mCon_flow_nominal=mEva_flow_nominal_final,
       final mEva_flow_nominal=mCon_flow_nominal_final,
       final y_nominal=y_nominal)
  "Black-box data of a heat pump in cooling operation mode"
    annotation (Dialog(enable=use_rev),choicesAllMatching=true);
  replaceable parameter SafetyControls.RecordsCollection.DefaultSafetyControl
    safCtrlPar
    constrainedby IBPSA.Fluid.HeatPumps.SafetyControls.RecordsCollection.HeatPumpSafetyControlBaseDataDefinition
    "Safety control parameters"
    annotation (Dialog(enable=use_safetyControl, group="Safety Control"),
    choicesAllMatching=true);
  IBPSA.Fluid.HeatPumps.SafetyControls.SafetyControl safetyControl(
    final mEva_flow_nominal=mEva_flow_nominal_final,
    final mCon_flow_nominal=mCon_flow_nominal_final,
    safCtrlPar=safCtrlPar,
    final ySet_small=ySet_small) if use_safetyControl
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));

protected
  Modelica.Blocks.Math.BooleanToReal boolToReal
    if use_safetyControl and use_TSet "Use default ySet value";
  Modelica.Blocks.Math.RealToBoolean realToBool
    if use_safetyControl and use_TSet "Use default ySet value";
equation
  connect(TSet, sigBus.TConOutSet) annotation (Line(points={{-116,40},{-80,40},{
          -80,-43},{-105,-43}},  color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  if use_safetyControl then
    connect(safetyControl.sigBus, sigBus) annotation (Line(
        points={{-60.75,-15.75},{-60.75,-16},{-76,-16},{-76,-43},{-105,-43}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%second",
        index=1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(modeSet, safetyControl.modeSet) annotation (Line(points={{-116,-90},
            {-76,-90},{-76,-11.6667},{-61.3333,-11.6667}},
                                                    color={255,0,255}));
    connect(safetyControl.modeOut, sigBus.modeSet) annotation (Line(points={{
            -39.1667,-11.6667},{-30,-11.6667},{-30,-66},{-76,-66},{-76,-43},{
            -105,-43}},
        color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
    if use_TSet then
      connect(realToBool.u, safetyControl.yOut);
      connect(boolToReal.u, onOffSet);
      connect(realToBool.y, sigBus.onOffSet);
      connect(boolToReal.y, safetyControl.ySet);
    else
      connect(safetyControl.yOut, sigBus.ySet) annotation (Line(points={{
              -39.1667,-8.33333},{-30,-8.33333},{-30,-66},{-76,-66},{-76,-43},{
              -105,-43}},                                             color={0,0,127}),
        Text(
        string="%second",
        index=1,
        extent={{6,3},{6,3}},
        horizontalAlignment=TextAlignment.Left));
      connect(ySet, safetyControl.ySet) annotation (Line(points={{-116,20},{-80,
              20},{-80,-8.33333},{-61.3333,-8.33333}},
                                                 color={0,0,127}));
    end if;
  else
    connect(ySet, sigBus.ySet) annotation (Line(points={{-116,20},{-80,20},{-80,-43},
          {-105,-43}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
    connect(modeSet, sigBus.modeSet) annotation (Line(points={{-116,-90},{-76,-90},
          {-76,-43},{-105,-43}}, color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  end if;


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
        Text(
          extent={{-151,147},{149,107}},
          textColor={0,0,255},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255},
          textString="%name"),
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
<p>Adding to the concept described in 
<a href=\"modelica://IBPSA.Fluid.HeatPumps.BaseClasses.PartialReversibleVapourCompressionMachine\">
IBPSA.Fluid.HeatPumps.BaseClasses.PartialReversibleVapourCompressionMachine</a>, 
this heat pump model for a reversible, modular heat pump adds 
safety controls of real devices.</p>
<p>As with all options, the safety controls are optional.</p>
</html>"));
end HeatPump;

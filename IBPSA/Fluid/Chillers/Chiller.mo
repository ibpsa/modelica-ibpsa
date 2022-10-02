within IBPSA.Fluid.Chillers;
model Chiller
  "Grey-box model for reversible chillers using a black-box to simulate the refrigeration cycle"
  extends
    IBPSA.Fluid.HeatPumps.BaseClasses.PartialReversibleVapourCompressionMachine(
    final autCalMCon_flow=max(5E-5*QUse_flow_nominal + 0.3161, autCalMMin_flow),
    final autCalMEva_flow=max(5E-5*QUse_flow_nominal - 0.5662, autCalMMin_flow),
    final autCalVCon=max(2E-7*QUse_flow_nominal - 84E-4, autCalVMin),
    final autCalVEva=max(1E-7*QUse_flow_nominal - 66E-4, autCalVMin),
    mEva_flow_nominal=QUse_flow_nominal/(dTEva_nominal*cpEva),
    final scaFac=vapComCyc.blaBoxChiCoo.scaFac,
    final use_safetyControl=false,
    use_rev=true,
    redeclare IBPSA.Fluid.Chillers.BaseClasses.BlackBoxVapourCompressionCycle
      vapComCyc(redeclare model BlackBoxChillerCooling = BlackBoxChillerCooling,
        redeclare model BlackBoxChillerHeating = BlackBoxChillerHeating));

  replaceable model BlackBoxChillerCooling =
      IBPSA.Fluid.Chillers.BlackBoxData.BaseClasses.PartialChillerBlackBox
      constrainedby
      IBPSA.Fluid.Chillers.BlackBoxData.BaseClasses.PartialChillerBlackBox(
       final QUse_flow_nominal=QUse_flow_nominal,
       final TCon_nominal=TCon_nominal,
       final TEva_nominal=TEva_nominal,
       final dTCon_nominal=dTCon_nominal,
       final dTEva_nominal=dTEva_nominal,
       final mCon_flow_nominal=mCon_flow_nominal_final,
       final mEva_flow_nominal=mEva_flow_nominal_final,
       final y_nominal=y_nominal)
  "Performance data of a chiller in main operation mode"
    annotation (choicesAllMatching=true);
  replaceable model BlackBoxChillerHeating =
      IBPSA.Fluid.HeatPumps.BlackBoxData.BaseClasses.NoHeating
       constrainedby
      IBPSA.Fluid.HeatPumps.BlackBoxData.BaseClasses.PartialHeatPumpBlackBox(
       final QUse_flow_nominal=0,
       final scaFac=scaFac,
       final TCon_nominal=TEva_nominal,
       final TEva_nominal=TCon_nominal,
       final dTCon_nominal=dTEva_nominal,
       final dTEva_nominal=dTCon_nominal,
       final mCon_flow_nominal=mEva_flow_nominal_final,
       final mEva_flow_nominal=mCon_flow_nominal_final,
       final y_nominal=y_nominal)
  "Performance data of a chiller in reversible operation mode"
    annotation (Dialog(enable=use_rev),choicesAllMatching=true);

equation
  connect(TSet, sigBus.TEvaOutSet) annotation (Line(points={{-116,40},{-76,40},
          {-76,-42},{-106,-42},{-106,-43},{-105,-43}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(modeSet, sigBus.modeSet) annotation (Line(points={{-116,-90},{-80,-90},
          {-80,-43},{-105,-43}}, color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(onOffSet, sigBus.onOffSet) annotation (Line(points={{-116,-20},{-80,-20},
          {-80,-43},{-105,-43}}, color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(ySet, sigBus.ySet) annotation (Line(points={{-116,20},{-80,20},{-80,-43},
          {-105,-43}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(onOffSet, sigBus.onOffMea) annotation (Line(points={{-116,-20},{-80,-20},
          {-80,-43},{-105,-43}}, color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
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
    <i>May 22, 2019&#160;</i> by Julian Matthes:<br/>
    First implementation (see issue <a href=
    \"https://github.com/RWTH-EBC/AixLib/issues/715\">AixLib #715</a>)
  </li>
</ul>
</html>", info="<html>
<p>Model of a reversible, modular chiller.</p>
<p><br>See the documentation of 
<a href=\"IBPSA.Fluid.HeatPumps.BaseClasses.PartialReversibleVapourCompressionMachine\">
IBPSA.Fluid.HeatPumps.BaseClasses.PartialReversibleVapourCompressionMachine</a> 
for information on the concept.</p>
</html>"));
end Chiller;

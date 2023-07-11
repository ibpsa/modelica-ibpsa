within IBPSA.Fluid.HeatPumps;
model ModularReversible
  "Grey-box model for reversible heat pumps using performance data or functional approaches to simulate the refrigeration cycle"
  extends IBPSA.Fluid.HeatPumps.BaseClasses.PartialReversibleRefrigerantMachine(
    safCtr(final forHeaPum=true),
    final PEle_nominal=refCyc.refCycHeaPumHea.PEle_nominal,
    mCon_flow_nominal=QUse_flow_nominal/(dTCon_nominal*cpCon),
    mEva_flow_nominal=(QUse_flow_nominal - PEle_nominal)/(dTEva_nominal*cpEva),
    final scaFac=refCyc.refCycHeaPumHea.scaFac,
    use_rev=true,
    redeclare IBPSA.Fluid.HeatPumps.BaseClasses.RefrigerantCycle refCyc(
        redeclare model RefrigerantCycleHeatPumpHeating =
          RefrigerantCycleHeatPumpHeating, redeclare model
        RefrigerantCycleHeatPumpCooling = RefrigerantCycleHeatPumpCooling));
  replaceable model RefrigerantCycleHeatPumpHeating =
      IBPSA.Fluid.HeatPumps.RefrigerantCycle.BaseClasses.PartialHeatPumpCycle
      (QUseNoSca_flow_nominal=0)
     constrainedby
    IBPSA.Fluid.HeatPumps.RefrigerantCycle.BaseClasses.PartialHeatPumpCycle(
       final QUse_flow_nominal=QUse_flow_nominal,
       final TCon_nominal=TCon_nominal,
       final TEva_nominal=TEva_nominal,
       final dTCon_nominal=dTCon_nominal,
       final dTEva_nominal=dTEva_nominal,
       final mCon_flow_nominal=mCon_flow_nominal,
       final mEva_flow_nominal=mEva_flow_nominal,
       final y_nominal=y_nominal)
  "Model approach of the refrigerant cycle in heating mode"
    annotation (choicesAllMatching=true);
  replaceable model RefrigerantCycleHeatPumpCooling =
      IBPSA.Fluid.Chillers.RefrigerantCycle.BaseClasses.NoCooling
      constrainedby
    IBPSA.Fluid.Chillers.RefrigerantCycle.BaseClasses.PartialChillerCycle(
       final QUse_flow_nominal=refCyc.refCycHeaPumCoo.QUseNoSca_flow_nominal,
       final scaFac=scaFac,
       final TCon_nominal=TCon_nominal,
       final TEva_nominal=TEva_nominal,
       final dTCon_nominal=dTCon_nominal,
       final dTEva_nominal=dTEva_nominal,
       final mCon_flow_nominal=mCon_flow_nominal,
       final mEva_flow_nominal=mEva_flow_nominal,
       final y_nominal=y_nominal)
  "Model approach of the refrigerant cycle in cooling mode"
    annotation (Dialog(enable=use_rev),choicesAllMatching=true);
  parameter Modelica.Units.SI.HeatFlowRate QCoo_flow_nominal=
    refCyc.refCycHeaPumCoo.QUseNoSca_flow_nominal*scaFac
    "Nominal heat flow rate of cooling operation"
      annotation(Dialog(group="Nominal Design", enable=use_rev));
  Modelica.Blocks.Sources.BooleanConstant conHea(final k=true)
    if not use_busConOnl and not use_rev
    "Set heating mode to true if device is not reversible" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-90,-110})));
  Modelica.Blocks.Interfaces.BooleanInput hea if not use_busConOnl and use_rev
    "=true for heating, =false for cooling"
    annotation (Placement(transformation(extent={{-132,-106},{-100,-74}})));
equation
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
<p>
  Model of a reversible, modular heat pump. 
  You can combine any of the avaiable model approaches 
  for refrigerant for heating and cooling, add inertias, 
  heat losses, and safety controls. 
  All features are optional.
</p>
<p>
  Adding to the partial model (
  <a href=\"modelica://IBPSA.Fluid.HeatPumps.BaseClasses.PartialReversibleRefrigerantMachine\">
  IBPSA.Fluid.HeatPumps.BaseClasses.PartialReversibleRefrigerantMachine</a>), 
  this model adds the <code>hea</code> signal to choose 
  the operation type of the heat pump:
</p>
<ul>
<li><code>hea = true</code>: Main operation mode (heat pump: heating) </li>
<li><code>hea = false</code>: Reversible operation mode (heat pump: cooling) </li>
</ul>
<p>
  For more information on the approach, please read the 
  <a href=\"modelica://IBPSA.Fluid.HeatPumps.ModularReversibleUsersGuide\">
  UsersGuide</a>.
</p>
</html>"));
end ModularReversible;

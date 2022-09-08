within IBPSA.Fluid.Chillers;
model Chiller
  "Grey-box model for reversible chillers using a black-box to simulate the refrigeration cycle"
  extends
    IBPSA.Fluid.HeatPumps.BaseClasses.PartialReversibleVapourCompressionMachine(
      final autoCalc_mCon_flow=max(0.00005*QUse_flow_nominal + 0.3161, autoCalc_mMin_flow),
      final autoCalc_mEva_flow= max(0.00005*QUse_flow_nominal - 0.5662, autoCalc_mMin_flow),
      final autoCalc_VCon=max(0.0000002*QUse_flow_nominal - 0.0084, autoCalc_VMin),
      final autoCalc_VEva=max(0.0000001*QUse_flow_nominal - 0.0066, autoCalc_VMin),
      mEva_flow_nominal=QUse_flow_nominal/(dTEva_nominal*cpEva),
      final scalingFactor=innerCycle.BlackBoxChillerCooling.finalScalingFactor,
      final use_safetyControl=false,
      use_rev=true,
      redeclare IBPSA.Fluid.Chillers.BaseClasses.InnerCycle_Chiller innerCycle(
          redeclare model BlaBoxChiCooling = BlaBoxChiCooling,
          redeclare model BlaBoxChiHeating = BlaBoxChiHeating));

  replaceable model BlaBoxChiCooling =
      IBPSA.Fluid.Chillers.BlackBoxData.BaseClasses.PartialChillerBlackBox
      constrainedby
      IBPSA.Fluid.Chillers.BlackBoxData.BaseClasses.PartialChillerBlackBox(
       final QUse_flow_nominal=QUse_flow_nominal,
       final scalingFactor=0,
       final primaryOperation=true,
       final TCon_nominal=TCon_nominal,
       final TEva_nominal=TEva_nominal,
       final dTCon_nominal=dTCon_nominal,
       final dTEva_nominal=dTEva_nominal,
       final mCon_flow_nominal=mCon_flow_nominal,
       final mEva_flow_nominal=mEva_flow_nominal,
       final y_nominal=y_nominal)
  "Performance data of a chiller in main operation mode"
    annotation (choicesAllMatching=true);
  replaceable model BlaBoxChiHeating =
      IBPSA.Fluid.HeatPumps.BlackBoxData.BaseClasses.NoHeating
       constrainedby
      IBPSA.Fluid.HeatPumps.BlackBoxData.BaseClasses.PartialHeatPumpBlackBox(
       final QUse_flow_nominal=0,
       final scalingFactor=scalingFactor,
       final primaryOperation=false,
       final TCon_nominal=TEva_nominal,
       final TEva_nominal=TCon_nominal,
       final dTCon_nominal=dTEva_nominal,
       final dTEva_nominal=dTCon_nominal,
       final mCon_flow_nominal=mEva_flow_nominal,
       final mEva_flow_nominal=mCon_flow_nominal,
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
    \"https://github.com/RWTH-EBC/AixLib/issues/715\">#715</a>)
  </li>
</ul>
</html>", info="<html>
<p>
  This generic grey-box chiller model uses empirical data to model the
  refrigerant cycle. The modelling of system inertias and heat losses
  allow the simulation of transient states.
</p>
<p>
  Resulting in the choosen model structure, several configurations are
  possible:
</p>
<ol>
  <li>Compressor type: on/off or inverter controlled
  </li>
  <li>Reversible chiller / only cooling
  </li>
  <li>Source/Sink: Any combination of mediums is possible
  </li>
  <li>Generik: Losses and inertias can be switched on or off.
  </li>
</ol>
<h4>
  Concept
</h4>
<p>
  Using a signal bus as a connector, this chiller model can be easily
  combined within a chiller system model including several control or
  safety blocks analogous to <a href=
  \"modelica://IBPSA.Controls.HeatPump\">IBPSA.Controls.HeatPump</a>.
  The relevant data is aggregated. The mode signal chooses the type of
  the chiller operation. As a result, this model can also be used as a
  heat pump:
</p>
<ul>
  <li>mode = true: Chilling
  </li>
  <li>mode = false: Heating
  </li>
</ul>
<p>
  To model both on/off and inverter controlled chillers, the compressor
  speed is normalizd to a relative value between 0 and 1.
</p>
<p>
  Possible icing of the evaporator is modelled with an input value
  between 0 and 1.
</p>
<p>
  The model structure is as follows. To understand each submodel,
  please have a look at the corresponding model information:
</p>
<ol>
  <li>
    <a href=
    \"IBPSA.Fluid.HeatPumps.BaseClasses.InnerCycle\">InnerCycle</a>
    (Black Box): Here, the user can use between several input models or
    just easily create his own, modular black box model. Please look at
    the model description for more info.
  </li>
  <li>Inertia: A n-order element is used to model system inertias (mass
  and thermal) of components inside the refrigerant cycle (compressor,
  pipes, expansion valve)
  </li>
  <li>
    <a href=
    \"modelica://IBPSA.Fluid.HeatExchangers.EvaporatorCondenserWithCapacity\">
    HeatExchanger</a>: This new model also enable modelling of thermal
    interias and heat losses in a heat exchanger. Please look at the
    model description for more info.
  </li>
</ol>
<h4>
  Parametrization
</h4>
<p>
  To simplify the parametrization of the evaporator and condenser
  volumes and nominal mass flows there exists an option of automatic
  estimation based on the nominal usable cooling power of the Chiller.
  This function uses a linear correlation of these parameters, which
  was established from the linear regression of more than 20 data sets
  of water-to-water chillers from different manufacturers (e.g.
  Carrier, Trane, Lennox) ranging from about 25kW to 1MW nominal power.
  The linear regressions with coefficients of determination above 91%
  give a good approximation of these parameters. Nevertheless,
  estimates for machines outside the given range should be checked for
  plausibility during simulation.
</p>
<h4>
  Assumptions
</h4>
<p>
  Several assumptions where made in order to model the chiller. For a
  detailed description see the corresponding model.
</p>
<ol>
  <li>
    <a href=
    \"modelica://IBPSA.Fluid.HeatPumps.BaseClasses.PerformanceData.EuropeanNorm2D\">
    Performance data 2D</a>: In order to model inverter controlled
    chillers, the compressor speed is scaled <b>linearly</b>
  </li>
  <li>
    <a href=
    \"modelica://IBPSA.Fluid.HeatPumps.BaseClasses.PerformanceData.EuropeanNorm2D\">
    Performance data 2D</a>: Reduced evaporator power as a result of
    icing. The icing factor is multiplied with the evaporator power.
  </li>
  <li>
    <b>Inertia</b>: The default value of the n-th order element is set
    to 3. This follows comparisons with experimental data.
  </li>
  <li>
    <b>Scaling factor</b>: A scaling facor is implemented for scaling
    of the chiller power and capacity. The factor scales the parameters
    V, m_flow_nominal, C, GIns, GOut and dp_nominal. As a result, the
    chiller can supply more heat with the COP staying nearly constant.
    However, one has to make sure that the supplied pressure difference
    or mass flow is also scaled with this factor, as the nominal values
    do not increase said mass flow.
  </li>
</ol>
<h4>
  Known Limitations
</h4>
<ul>
  <li>The n-th order element has a big influence on computational time.
  Reducing the order or disabling it completly will decrease
  computational time.
  </li>
  <li>Reversing the mode: A normal 4-way-exchange valve suffers from
  heat losses and irreversibilities due to switching from one mode to
  another. Theses losses are not taken into account.
  </li>
</ul>
</html>"));
end Chiller;

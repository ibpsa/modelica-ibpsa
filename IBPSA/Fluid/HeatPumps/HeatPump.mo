within IBPSA.Fluid.HeatPumps;
model HeatPump
  "Grey-box model for reversible heat pumps using a black-box to simulate the refrigeration cycle"
  extends
    IBPSA.Fluid.HeatPumps.BaseClasses.PartialReversibleVapourCompressionMachine(
    final autoCalc_mCon_flow=max(0.00004*QUse_flow_nominal - 0.6162, autoCalc_mMin_flow),
    final autoCalc_mEva_flow=max(0.00004*QUse_flow_nominal - 0.3177, autoCalc_mMin_flow),
    final autoCalc_VCon=max(0.0000001*QUse_flow_nominal - 0.0094,autoCalc_VMin),
    final autoCalc_VEva=max(0.0000001*QUse_flow_nominal - 0.0075,autoCalc_VMin),
    mCon_flow_nominal=QUse_flow_nominal/(dTCon_nominal*cpCon),
    final scalingFactor=innerCycle.BlackBoxHeaPumHeating.finalScalingFactor,
    use_rev=true,
    redeclare IBPSA.Fluid.HeatPumps.BaseClasses.InnerCycle_HeatPump innerCycle(
        redeclare model BlaBoxHPHeating = BlaBoxHPHeating,
        redeclare model BlaBoxHPCooling = BlaBoxHPCooling));
  replaceable model BlaBoxHPHeating =
      IBPSA.Fluid.HeatPumps.BlackBoxData.BaseClasses.PartialHeatPumpBlackBox
     constrainedby
    IBPSA.Fluid.HeatPumps.BlackBoxData.BaseClasses.PartialHeatPumpBlackBox(
       final QUse_flow_nominal=QUse_flow_nominal,
       final scalingFactor=0,
       final TCon_nominal=TCon_nominal,
       final TEva_nominal=TEva_nominal,
       final dTCon_nominal=dTCon_nominal,
       final dTEva_nominal=dTEva_nominal,
       final primaryOperation=true,
       final mCon_flow_nominal=mCon_flow_nominal,
       final mEva_flow_nominal=mEva_flow_nominal,
       final y_nominal=y_nominal)
  "Black box data of a heat pump in heating mode"
    annotation (choicesAllMatching=true);
  replaceable model BlaBoxHPCooling =
      IBPSA.Fluid.Chillers.BlackBoxData.BaseClasses.PartialChillerBlackBox
      constrainedby
      IBPSA.Fluid.Chillers.BlackBoxData.BaseClasses.PartialChillerBlackBox(
       final QUse_flow_nominal=0,
       final scalingFactor=scalingFactor,
       final TCon_nominal=TEva_nominal,
       final TEva_nominal=TCon_nominal,
       final dTCon_nominal=dTEva_nominal,
       final dTEva_nominal=dTCon_nominal,
       final mCon_flow_nominal=mEva_flow_nominal,
       final mEva_flow_nominal=mCon_flow_nominal,
       final primaryOperation=false,
       final y_nominal=y_nominal)
  "Black box data of a heat pump in cooling operation mode"
    annotation (Dialog(enable=use_rev),choicesAllMatching=true);
  replaceable parameter
    IBPSA.Fluid.HeatPumps.SafetyControls.RecordsCollection.DefaultSafetyControl
    safetyControlParameters
    constrainedby IBPSA.Fluid.HeatPumps.SafetyControls.RecordsCollection.HeatPumpSafetyControlBaseDataDefinition
    "Safety control parameters"
    annotation (Dialog(enable=use_safetyControl, group="Safety Control"), choicesAllMatching=true);
  IBPSA.Fluid.HeatPumps.SafetyControls.SafetyControl safetyControl(
    final mEva_flow_nominal=mEva_flow_nominal_final*scalingFactor,
    final mCon_flow_nominal=mCon_flow_nominal_final*scalingFactor,
      safetyControlParameters=safetyControlParameters)             if use_safetyControl
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));

protected
  Modelica.Blocks.Math.BooleanToReal booleanToReal if use_safetyControl and use_TSet
                             "Use default ySet value";
  Modelica.Blocks.Math.RealToBoolean realToBoolean if use_safetyControl and use_TSet
                             "Use default ySet value";
equation
  connect(TSet, sigBus.TConOutSet) annotation (Line(points={{-116,40},{-80,40},{
          -80,-43},{-105,-43}},  color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  if use_safetyControl then
    connect(safetyControl.sigBusHP, sigBus) annotation (Line(
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
      connect(realToBoolean.u, safetyControl.yOut);
      connect(booleanToReal.u, onOffSet);
      connect(realToBoolean.y, sigBus.onOffSet);
      connect(booleanToReal.y, safetyControl.ySet);
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
    <i>May 22, 2019</i> by Julian Matthes:<br/>
    Rebuild due to the introducion of the thermal machine partial model
    (see issue <a href=
    \"https://github.com/RWTH-EBC/AixLib/issues/715\">#715</a>)
  </li>
  <li>
    <i>November 26, 2018&#160;</i> by Fabian Wuellhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/RWTH-EBC/AixLib/issues/577\">#577</a>)
  </li>
</ul>
</html>", info="<html>
<p>
  This generic grey-box heat pump model uses empirical data to model
  the refrigerant cycle. The modelling of system inertias and heat
  losses allow the simulation of transient states.
</p>
<p>
  Resulting in the choosen model structure, several configurations are
  possible:
</p>
<ol>
  <li>Compressor type: on/off or inverter controlled
  </li>
  <li>Reversible heat pump / only heating
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
  Using a signal bus as a connector, this heat pump model can be easily
  combined with the new <a href=
  \"modelica://IBPSA.Systems.HeatPumpSystems.HeatPumpSystem\">HeatPumpSystem</a>
  or several control or safety blocks from <a href=
  \"modelica://IBPSA.Controls.HeatPump\">IBPSA.Controls.HeatPump</a>.
  The relevant data is aggregated. In order to control both chillers
  and heat pumps, both flow and return temperature are aggregated. The
  mode signal chooses the type of the heat pump operation. As a result,
  this model can also be used as a chiller:
</p>
<ul>
  <li>mode = true: Heating
  </li>
  <li>mode = false: Chilling
  </li>
</ul>
<p>
  To model both on/off and inverter controlled heat pumps, the
  compressor speed is normalizd to a relative value between 0 and 1.
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
  estimation based on the nominal usable heating power of the HeatPump.
  This function uses a linear correlation of these parameters, which
  was established from the linear regression of more than 20 data sets
  of water-to-water heat pumps from different manufacturers (e.g.
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
  Several assumptions where made in order to model the heat pump. For a
  detailed description see the corresponding model.
</p>
<ol>
  <li>
    <a href=
    \"modelica://IBPSA.Fluid.HeatPumps.BaseClasses.PerformanceData.LookUpTable2D\">
    Performance data 2D</a>: In order to model inverter controlled heat
    pumps, the compressor speed is scaled <b>linearly</b>
  </li>
  <li>
    <a href=
    \"modelica://IBPSA.Fluid.HeatPumps.BaseClasses.PerformanceData.LookUpTable2D\">
    Performance data 2D</a>: Reduced evaporator power as a result of
    icing. The icing factor is multiplied with the evaporator power.
  </li>
  <li>
    <b>Inertia</b>: The default value of the n-th order element is set
    to 3. This follows comparisons with experimental data. Previous
    heat pump models are using n = 1 as a default. However, it was
    pointed out that a higher order element fits a real heat pump
    better in.
  </li>
  <li>
    <b>Scaling factor</b>: A scaling facor is implemented for scaling
    of the heat pump power and capacity. The factor scales the
    parameters V, m_flow_nominal, C, GIns, GOut and dp_nominal. As a
    result, the heat pump can supply more heat with the COP staying
    nearly constant. However, one has to make sure that the supplied
    pressure difference or mass flow is also scaled with this factor,
    as the nominal values do not increase said mass flow.
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
end HeatPump;

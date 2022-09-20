within IBPSA.Fluid.Chillers.BaseClasses;
model InnerCycle "Blackbox model of refrigerant cycle of a chiller"
  extends IBPSA.Fluid.HeatPumps.BaseClasses.PartialInnerCycle;
  // Setting all values to zero avoids errors when checking this model.
  // The values are correctly propagated by the heat pump / chiller model anyway
  replaceable model BlackBoxChillerCooling =
      IBPSA.Fluid.Chillers.BlackBoxData.BaseClasses.PartialChillerBlackBox (
       QUse_flow_nominal=0,
       QUseBlackBox_flow_nominal=0,
       scalingFactor=0,
       TCon_nominal=0,
       TEva_nominal=0,
       dTCon_nominal=0,
       dTEva_nominal=0,
       primaryOperation=true,
       mCon_flow_nominal=0,
       mEva_flow_nominal=0,
       y_nominal=0)
    constrainedby
    IBPSA.Fluid.Chillers.BlackBoxData.BaseClasses.PartialChillerBlackBox
    "Replaceable model for performance data of a chiller in main operation mode"
    annotation (choicesAllMatching=true);

  replaceable model BlackBoxChillerHeating =
      IBPSA.Fluid.HeatPumps.BlackBoxData.BaseClasses.NoHeating(primaryOperation=false)
    constrainedby
    IBPSA.Fluid.HeatPumps.BlackBoxData.BaseClasses.PartialHeatPumpBlackBox
    "Replaceable model for performance data of a chiller in reversible operation mode"
    annotation (Dialog(enable=use_rev),choicesAllMatching=true);

  BlackBoxChillerCooling blaBoxChiCoo
    annotation (Placement(transformation(extent={{7,20},{61,76}}, rotation=0)));
  BlackBoxChillerHeating blaBoxChiHea
    annotation (Placement(transformation(extent={{-27,-28},{27,28}}, rotation=0)));

  Modelica.Blocks.Math.Gain gainEva(final k=-1)
    "Negate QEva to match definition of heat flow direction" annotation (Placement(
        transformation(extent={{-4,-4},{4,4}}, rotation=180)));
  Modelica.Blocks.Math.Gain gainCon(final k=-1) if use_rev
    "Negate QCon to match definition of heat flow direction" annotation (
      Placement(transformation(
        extent={{-4,-4},{4,4}},
        rotation=0,
        origin={50,-20})));
protected
  IBPSA.Utilities.IO.Strings.StringPassThrough strPasThr
    "String pass through to enable conditional string data";
  IBPSA.Utilities.IO.Strings.ConstStringSource conStrSou(
    final k=blaBoxChiCoo.datSou) if not use_rev
   "Constant String data source";
initial equation
  assert(
    strPasThr.y == blaBoxChiCoo.datSou,
    "Data sources for reversible operation are not equal! 
    Only continue if this is intended",
    AssertionLevel.warning);
equation
  connect(conStrSou.y, strPasThr.u);
  connect(blaBoxChiHea.datSouOut, strPasThr.u);
  connect(blaBoxChiCoo.Pel, switchPel.u1) annotation (Line(points={{34,17.2},{34,
          -30},{8,-30},{8,-58}}, color={0,0,127}));
  connect(blaBoxChiHea.Pel, switchPel.u3) annotation (Line(
      points={{0,-30.8},{0,-30},{-8,-30},{-8,-58}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(constZero.y, switchPel.u3) annotation (Line(points={{-59,-70},{-34,-70},
          {-34,-58},{-8,-58}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(constZero.y, switchQEva.u3) annotation (Line(
      points={{-59,-70},{-52,-70},{-52,-8},{-58,-8}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(constZero.y, switchQCon.u3) annotation (Line(points={{-59,-70},{-52,-70},
          {-52,-38},{58,-38},{58,-8}},       color={0,0,127},
      pattern=LinePattern.Dash));
  connect(sigBus, blaBoxChiHea.sigBus) annotation (Line(
      points={{0,102},{0,86},{0.27,86},{0.27,29.12}},
      color={255,204,51},
      thickness=0.5));
  connect(sigBus, blaBoxChiCoo.sigBus) annotation (Line(
      points={{0,102},{0,86},{34.27,86},{34.27,77.12}},
      color={255,204,51},
      thickness=0.5));

  connect(blaBoxChiCoo.QEva_flow, gainEva.u) annotation (Line(points={{55.6,
          17.2},{55.6,-8.88178e-16},{4.8,-8.88178e-16}}, color={0,0,127}));
  connect(gainEva.y, switchQEva.u1) annotation (Line(points={{-4.4,8.88178e-16},
          {-56,8.88178e-16},{-56,8},{-58,8}}, color={0,0,127}));
  connect(blaBoxChiHea.QEva_flow, switchQEva.u3) annotation (Line(
      points={{21.6,-30.8},{21.6,-8},{-58,-8}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(blaBoxChiHea.QCon_flow, gainCon.u) annotation (Line(
      points={{-21.6,-30.8},{-21.6,2},{-24,2},{-24,-20},{45.2,-20}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(gainCon.y, switchQCon.u3)
    annotation (Line(points={{54.4,-20},{56,-20},{56,-8},{58,-8}},
                                                   color={0,0,127},
        pattern=LinePattern.Dash));
  connect(blaBoxChiCoo.QCon_flow, switchQCon.u1) annotation (Line(points={{12.4,
          17.2},{12.4,4},{62,4},{62,8},{58,8}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={238,46,47},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-24,88},{22,44}},
          lineColor={28,108,200},
          lineThickness=0.5),
        Line(
          points={{-16,82},{20,74}},
          color={28,108,200},
          thickness=0.5),
        Line(
          points={{-18,52},{20,58}},
          color={28,108,200},
          thickness=0.5),
        Rectangle(
          extent={{-98,40},{-60,-28}},
          lineColor={28,108,200},
          lineThickness=0.5),
        Line(
          points={{-20,-60},{-20,-70},{-20,-80},{20,-60},{20,-80},{-20,-60}},
          color={28,108,200},
          thickness=0.5),
        Line(
          points={{-122,34},{-66,34},{-82,10},{-66,-22},{-120,-22}},
          color={28,108,200},
          thickness=0.5),
        Rectangle(
          extent={{60,40},{98,-28}},
          lineColor={28,108,200},
          lineThickness=0.5),
        Line(
          points={{120,34},{64,34},{80,10},{64,-22},{118,-22}},
          color={28,108,200},
          thickness=0.5),
        Line(
          points={{-80,40},{-80,68},{-24,68}},
          color={28,108,200},
          thickness=0.5),
        Line(
          points={{22,66},{80,66},{80,40}},
          color={28,108,200},
          thickness=0.5),
        Line(
          points={{78,-28},{78,-70}},
          color={28,108,200},
          thickness=0.5),
        Line(
          points={{78,-70},{62,-70},{20,-70}},
          color={28,108,200},
          thickness=0.5),
        Line(
          points={{-80,-26},{-80,-68},{-20,-68}},
          color={28,108,200},
          thickness=0.5),
        Text(
          extent={{-151,147},{149,107}},
          textColor={0,0,255},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255},
          textString="%name")}), Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html><ul>
  <li>
    <i>May 22, 2019&#160;</i> by Julian Matthes:<br/>
    First implementation (see issue <a href=
    \"https://github.com/RWTH-EBC/AixLib/issues/715\">AixLib #715</a>)
  </li>
</ul>
</html>", info="<html>
<p>
  This black box model represents the refrigerant cycle of a chiller.
  Used in IBPSA.Fluid.Chillers.Chiller, this model serves the
  simulation of a reversible chiller. Thus, data both of chillers and
  heat pumps can be used to calculate the three relevant values
  <code>P_el</code>, <code>QCon</code> and <code>QEva</code>. The <code>mode</code> of the chiller is used to
  switch between the performance data of the chiller and the heat pump.
</p>
<p>
  The user can choose between different types of performance data or
  implement a new black-box model by extending from <a href=
  \"modelica://IBPSA.Fluid.Chillers.BlackBoxData.BaseClasses.PartialChillerBlackBox\">
  IBPSA.Fluid.Chillers.BlackBoxData.BaseClasses.PartialChillerBlackBox</a>.
</p>
<ul>
  <li>
    <a href=
    \"modelica://IBPSA.Fluid.Chillers.BlackBoxData.EuropeanNorm2D\">
    IBPSA.Fluid.Chillers.BlackBoxData.EuropeanNorm2D</a>: Use 2D-data based on the DIN EN 14511
  </li>
  <li>
    <a href=
    \"modelica://IBPSA.Fluid.Chillers.BlackBoxData.EuropeanNorm3D\">
    IBPSA.Fluid.Chillers.BlackBoxData.EuropeanNorm3D</a>: Use SDF-data tables to model invertercontroller
    chillers or include other dependencies (ambient temperature etc.)
  </li>
</ul>
</html>"));
end InnerCycle;

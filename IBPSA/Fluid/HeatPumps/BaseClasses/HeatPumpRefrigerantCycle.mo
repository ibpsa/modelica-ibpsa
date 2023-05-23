within IBPSA.Fluid.HeatPumps.BaseClasses;
model HeatPumpRefrigerantCycle
  "Refrigerant cycle model of a heat pump"
  extends IBPSA.Fluid.HeatPumps.BaseClasses.PartialModularRefrigerantCycle;
  // These models will be replaced by the heat pump model anyway.
  // Using the NoHeating and NoCooling option disabled warnings
  // about missing parameters in this model
  replaceable model RefrigerantCycleHeatPumpHeating =
      IBPSA.Fluid.HeatPumps.RefrigerantCycleModels.BaseClasses.PartialHeatPumpRefrigerantCycle
     constrainedby
    IBPSA.Fluid.HeatPumps.RefrigerantCycleModels.BaseClasses.PartialHeatPumpRefrigerantCycle
    "Replaceable model for refrigerant cycle of a heat pump in main operation mode"
    annotation (choicesAllMatching=true);

  replaceable model RefrigerantCycleHeatPumpCooling =
      IBPSA.Fluid.Chillers.RefrigerantCycleModels.BaseClasses.NoCooling
      constrainedby
    IBPSA.Fluid.Chillers.RefrigerantCycleModels.BaseClasses.PartialChillerRefrigerantCycle
    "Replaceable model for refrigerant cycle of 
    a heat pump in reversible operation mode"
    annotation (Dialog(enable=use_rev),choicesAllMatching=true);

  RefrigerantCycleHeatPumpHeating refCycHeaPumHea
    "Refrigerant cycle instance for heating"
  annotation (Placement(transformation(extent={{60,40},{20,80}}, rotation=0)));
  RefrigerantCycleHeatPumpCooling refCycHeaPumCoo if use_rev
    "Refrigerant cycle instance for cooling"
  annotation (Placement(transformation(extent={{-19,42},{-60,82}}, rotation=0)));
  Modelica.Blocks.Math.Gain gainEva(final k=-1)
    "Negate QEva to match definition of heat flow direction" annotation (
      Placement(transformation(
        extent={{-8,-8},{8,8}},
        rotation=180,
        origin={-32,8})));
  Modelica.Blocks.Math.Gain gainCon(final k=-1) if use_rev
    "Negate QCon to match definition of heat flow direction" annotation (
      Placement(transformation(
        extent={{-8,-8},{8,8}},
        rotation=0,
        origin={30,-8})));
protected
  IBPSA.Utilities.IO.Strings.StringPassThrough strPasThr
    "String pass through to enable conditional string data";
  IBPSA.Utilities.IO.Strings.ConstStringSource conStrSou(
    final k=refCycHeaPumHea.datSou) if not use_rev
    "Constant String data source";
initial equation
  assert(
    strPasThr.y ==refCycHeaPumHea.datSou,
    "Data sources for reversible operation are not equal! 
    Only continue if this is intended",
    AssertionLevel.warning);
equation
  connect(conStrSou.y, strPasThr.u);
  connect(refCycHeaPumCoo.datSouOut,  strPasThr.u);
  connect(pasTrhModSet.u, sigBus.hea);
  connect(refCycHeaPumHea.QCon_flow, swiQCon.u1)
    annotation (Line(points={{56,38},{56,8},{58,8}}, color={0,0,127}));
  connect(refCycHeaPumHea.PEle, swiPEle.u1) annotation (Line(points={{40,38},{
          40,30},{86,30},{86,-52},{8,-52},{8,-58}}, color={0,0,127}));
  connect(refCycHeaPumCoo.PEle, swiPEle.u3) annotation (Line(
      points={{-39.5,40},{-40,40},{-40,30},{-90,30},{-90,-50},{-8,-50},{-8,-58}},
      color={0,0,127},
      pattern=LinePattern.Dash));

  connect(refCycHeaPumCoo.QEva_flow, swiQEva.u3) annotation (Line(
      points={{-55.9,40},{-56,40},{-56,24},{-52,24},{-52,-8},{-58,-8}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(constZer.y, swiPEle.u3) annotation (Line(points={{-59,-70},{-40,-70},{
          -40,-50},{-8,-50},{-8,-58}}, color={0,0,127}));
  connect(constZer.y, swiQEva.u3) annotation (Line(
      points={{-59,-70},{-52,-70},{-52,-8},{-58,-8}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(constZer.y, swiQCon.u3) annotation (Line(
      points={{-59,-70},{-20,-70},{-20,-20},{50,-20},{50,-8},{58,-8}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(gainEva.y, swiQEva.u1)
    annotation (Line(points={{-40.8,8},{-58,8}}, color={0,0,127}));
  connect(swiQCon.u3, gainCon.y) annotation (Line(
      points={{58,-8},{38.8,-8}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(refCycHeaPumCoo.QCon_flow, gainCon.u) annotation (Line(
      points={{-23.1,40},{-24,40},{-24,32},{10,32},{10,-8},{20.4,-8}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(refCycHeaPumHea.QEva_flow, gainEva.u) annotation (Line(points={{24,38},
          {24,8},{-22.4,8}},                color={0,0,127}));
  connect(sigBus,refCycHeaPumCoo.sigBus)  annotation (Line(
      points={{0,102},{0,90},{-40,90},{-40,86},{-39.705,86},{-39.705,82.8}},
      color={255,204,51},
      thickness=0.5));
  connect(sigBus,refCycHeaPumHea.sigBus)  annotation (Line(
      points={{0,102},{0,90},{39.8,90},{39.8,80.8}},
      color={255,204,51},
      thickness=0.5));
  connect(swiQCon.u2, sigBus.hea) annotation (Line(points={{58,0},{0,0},{0,102}},
        color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(swiPEle.u2, sigBus.hea) annotation (Line(points={{2.22045e-15,-58},{2.22045e-15,
          22},{0,22},{0,102}}, color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(swiQEva.u2, sigBus.hea) annotation (Line(points={{-58,0},{0,0},{0,102},
          {0,102}}, color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
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
          textString="%name")}),
          Diagram(coordinateSystem(preserveAspectRatio=false)),
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
<p>Modular refrigerant cycle model for heat pump applications used in the model <a href=\"IBPSA.Fluid.HeatPumps.ModularReversible\">IBPSA.Fluid.HeatPumps.ModularReversible</a> and extending models of the modular approach.</p>
<p>This model adds the replaceable model approaches for heating and cooling data. </p>
<p>Further, an asseration warns if the data-sources or model approaches differ for heating and cooling.</p>
</html>"));
end HeatPumpRefrigerantCycle;

within IBPSA.Fluid.HeatPumps.ModularReversible.BaseClasses;
model RefrigerantCycle
  "Refrigerant cycle model of a heat pump"
  extends IBPSA.Fluid.HeatPumps.ModularReversible.BaseClasses.PartialModularRefrigerantCycle;
  replaceable model RefrigerantCycleHeatPumpHeating =
      IBPSA.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.NoHeating(
        useInHeaPum=true)
     constrainedby
    IBPSA.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.PartialHeatPumpCycle
    "Replaceable model for refrigerant cycle of a heat pump in main operation mode"
    annotation (choicesAllMatching=true);

  replaceable model RefrigerantCycleHeatPumpCooling =
      IBPSA.Fluid.Chillers.ModularReversible.RefrigerantCycle.BaseClasses.NoCooling(
        useInChi=true)
      constrainedby
    IBPSA.Fluid.Chillers.ModularReversible.RefrigerantCycle.BaseClasses.PartialChillerCycle
    "Replaceable model for refrigerant cycle of a heat pump in reversed operation mode"
    annotation (Dialog(enable=use_rev),choicesAllMatching=true);

  RefrigerantCycleHeatPumpHeating refCycHeaPumHea
    "Refrigerant cycle instance for heating"
  annotation (Placement(transformation(extent={{60,40},{20,80}}, rotation=0)));
  RefrigerantCycleHeatPumpCooling refCycHeaPumCoo
    "Refrigerant cycle instance for cooling"
  annotation (Placement(transformation(extent={{-19,40},{-60,80}}, rotation=0)));
  Modelica.Blocks.Math.Gain gainEva(final k=-1)
    "Negate QEva to match definition of heat flow direction" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-30,10})));
  Modelica.Blocks.Math.Gain gainCon(final k=-1)
    "Negate QCon to match definition of heat flow direction" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={30,-10})));
protected
  IBPSA.Utilities.IO.Strings.StringPassThrough strPasThr
    "String pass through to enable conditional string data";
  IBPSA.Utilities.IO.Strings.Constant conStrSou(
    final k=refCycHeaPumHea.datSou)
    "Constant String data source";
initial algorithm
  assert(
    strPasThr.y == refCycHeaPumHea.datSou,
    "In " + getInstanceName() + ": Data sources for reversible operation are not equal.
    Only continue if this is intended.",
    AssertionLevel.warning);
equation
 if use_rev then
  connect(refCycHeaPumCoo.datSouOut,  strPasThr.u);
 else
  connect(conStrSou.y, strPasThr.u);
 end if;
  connect(pasTrhModSet.u, sigBus.hea);
  connect(refCycHeaPumHea.QCon_flow, swiQCon.u1)
    annotation (Line(points={{53.3333,38.3333},{53.3333,8},{58,8}},
                                                     color={0,0,127}));
  connect(refCycHeaPumHea.PEle, swiPEle.u1) annotation (Line(points={{40,38.3333},
          {40,30},{86,30},{86,-52},{8,-52},{8,-58}},color={0,0,127}));
  connect(refCycHeaPumCoo.PEle, swiPEle.u3) annotation (Line(
      points={{-39.5,38.3333},{-40,38.3333},{-40,30},{-90,30},{-90,-50},{-8,-50},
          {-8,-58}},
      color={0,0,127},
      pattern=LinePattern.Dash));

  connect(refCycHeaPumCoo.QEva_flow, swiQEva.u3) annotation (Line(
      points={{-53.1667,38.3333},{-52,38.3333},{-52,-8},{-58,-8}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(gainEva.y, swiQEva.u1)
    annotation (Line(points={{-41,10},{-50,10},{-50,8},{-58,8}},
                                                 color={0,0,127}));
  connect(swiQCon.u3, gainCon.y) annotation (Line(
      points={{58,-8},{50,-8},{50,-10},{41,-10}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(refCycHeaPumCoo.QCon_flow, gainCon.u) annotation (Line(
      points={{-25.8333,38.3333},{-26,38.3333},{-26,30},{10,30},{10,-10},{18,-10}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(refCycHeaPumHea.QEva_flow, gainEva.u) annotation (Line(points={{26.6667,
          38.3333},{26.6667,10},{-18,10}},  color={0,0,127}));
  connect(sigBus,refCycHeaPumCoo.sigBus)  annotation (Line(
      points={{0,100},{0,90},{-40,90},{-40,86},{-39.6708,86},{-39.6708,80}},
      color={255,204,51},
      thickness=0.5));
  connect(sigBus,refCycHeaPumHea.sigBus)  annotation (Line(
      points={{0,100},{0,90},{39.8333,90},{39.8333,80}},
      color={255,204,51},
      thickness=0.5));
  connect(swiQCon.u2, sigBus.hea) annotation (Line(points={{58,0},{0,0},{0,100}},
        color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(swiPEle.u2, sigBus.hea) annotation (Line(points={{2.22045e-15,-58},{2.22045e-15,
          22},{0,22},{0,100}}, color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(swiQEva.u2, sigBus.hea) annotation (Line(points={{-58,0},{0,0},{0,100},
          {0,100}}, color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
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
    <i>November 26, 2018,</i> by Fabian Wuellhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/RWTH-EBC/AixLib/issues/577\">AixLib #577</a>)
  </li>
</ul>
</html>", info="<html>
<p>
  Modular refrigerant cycle model for heat pump applications used in
  the model <a href=\"modelica://IBPSA.Fluid.HeatPumps.ModularReversible.ModularReversible\">
  IBPSA.Fluid.HeatPumps.ModularReversible.ModularReversible</a> and extending models
  of the modular approach.
</p>
<p>
  This model adds the replaceable model approaches for cooling and heating data
  to the partial refrigerant cylce.
</p>
<p>
  Further, an asseration warning is raised if the model approaches or
  sources for performance data differ. This indicates that they are not
  for the same device.
</p>
<p>
  For more information on the approach, please read the
  <a href=\"modelica://IBPSA.Fluid.HeatPumps.ModularReversible.UsersGuide\">
  UsersGuide</a>.
</p>
</html>"));
end RefrigerantCycle;
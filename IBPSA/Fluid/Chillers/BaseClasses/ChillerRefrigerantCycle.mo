within IBPSA.Fluid.Chillers.BaseClasses;
model ChillerRefrigerantCycle "Refrigerant cycle model of a chiller"
  extends IBPSA.Fluid.HeatPumps.BaseClasses.PartialModularRefrigerantCycle;
  // Setting all values to zero avoids errors when checking this model.
  // The values are correctly propagated by the heat pump / chiller model anyway
  replaceable model RefrigerantCycleChillerCooling =
      IBPSA.Fluid.Chillers.RefrigerantCycleModels.BaseClasses.PartialChillerRefrigerantCycle
      (
      QUse_flow_nominal=0,
      QUseNoSca_flow_nominal=0,
      scaFac=0,
      TCon_nominal=0,
      TEva_nominal=0,
      dTCon_nominal=0,
      dTEva_nominal=0,
      mCon_flow_nominal=0,
      mEva_flow_nominal=0,
      y_nominal=0)
    constrainedby
    IBPSA.Fluid.Chillers.RefrigerantCycleModels.BaseClasses.PartialChillerRefrigerantCycle
    "Replaceable model for refrigerant cycle of a chiller in main operation mode"
    annotation (choicesAllMatching=true);

  replaceable model RefrigerantCycleChillerHeating =
      IBPSA.Fluid.HeatPumps.RefrigerantCycleModels.BaseClasses.NoHeating
    constrainedby
    IBPSA.Fluid.HeatPumps.RefrigerantCycleModels.BaseClasses.PartialHeatPumpRefrigerantCycle
    "Replaceable model for refrigerant cycle of a chiller in reversible operation mode"
    annotation (Dialog(enable=use_rev),choicesAllMatching=true);

  RefrigerantCycleChillerCooling refCycChiCoo
    "Regrigerant cycle instance for cooling"
    annotation (Placement(transformation(extent={{21,40},{60,80}}, rotation=0)));
  RefrigerantCycleChillerHeating refCycChiHea
    "Regrigerant cycle instance for heating"
    annotation (Placement(transformation(extent={{-80,38},{-39,80}}, rotation=0)));

  Modelica.Blocks.Math.Gain gainEva(final k=-1)
    "Negate QEva to match definition of heat flow direction" annotation (Placement(
        transformation(extent={{-10,-10},{10,10}},
                                               rotation=180,
        origin={-22,12})));
  Modelica.Blocks.Math.Gain gainCon(final k=-1) if use_rev
    "Negate QCon to match definition of heat flow direction" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={30,-8})));
protected
  IBPSA.Utilities.IO.Strings.StringPassThrough strPasThr
    "String pass through to enable conditional string data";
  IBPSA.Utilities.IO.Strings.ConstStringSource conStrSou(
    final k=refCycChiCoo.datSou) if not use_rev
   "Constant String data source";
initial equation
  assert(
    strPasThr.y ==refCycChiCoo.datSou,
    "Data sources for reversible operation are not equal! 
    Only continue if this is intended",
    AssertionLevel.warning);
equation
  connect(conStrSou.y, strPasThr.u);
  connect(refCycChiHea.datSouOut, strPasThr.u);
  connect(refCycChiCoo.PEle, swiPEle.u1) annotation (Line(points={{40.5,38},{40,
          38},{40,8},{8,8},{8,-58}}, color={0,0,127}));
  connect(refCycChiHea.PEle, swiPEle.u3) annotation (Line(
      points={{-59.5,35.9},{-58,35.9},{-58,26},{-24,26},{-24,-58},{-8,-58}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(constZer.y, swiPEle.u3) annotation (Line(
      points={{-59,-70},{-34,-70},{-34,-58},{-8,-58}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(constZer.y, swiQEva.u3) annotation (Line(
      points={{-59,-70},{-52,-70},{-52,-8},{-58,-8}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(constZer.y, swiQCon.u3) annotation (Line(
      points={{-59,-70},{-52,-70},{-52,-38},{58,-38},{58,-8}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(sigBus,refCycChiHea.sigBus)  annotation (Line(
      points={{0,102},{0,92},{-59.295,92},{-59.295,80.84}},
      color={255,204,51},
      thickness=0.5));
  connect(sigBus,refCycChiCoo.sigBus)  annotation (Line(
      points={{0,102},{0,92},{40.695,92},{40.695,80.8}},
      color={255,204,51},
      thickness=0.5));

  connect(refCycChiCoo.QEva_flow, gainEva.u) annotation (Line(points={{56.1,38},
          {56.1,26},{14,26},{14,12},{-10,12}},           color={0,0,127}));
  connect(gainEva.y, swiQEva.u1) annotation (Line(points={{-33,12},{-50,12},{-50,
          8},{-58,8}}, color={0,0,127}));
  connect(refCycChiHea.QEva_flow, swiQEva.u3) annotation (Line(
      points={{-43.1,35.9},{-42,35.9},{-42,-10},{-52,-10},{-52,-8},{-58,-8}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(refCycChiHea.QCon_flow, gainCon.u) annotation (Line(
      points={{-75.9,35.9},{-74,35.9},{-74,20},{-34,20},{-34,-8},{18,-8}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(gainCon.y, swiQCon.u3) annotation (Line(
      points={{41,-8},{58,-8}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(refCycChiCoo.QCon_flow, swiQCon.u1) annotation (Line(points={{24.9,38},
          {24.9,36},{24,36},{24,24},{50,24},{50,8},{58,8}}, color={0,0,127}));
  connect(swiPEle.u2, sigBus.coo) annotation (Line(points={{2.22045e-15,-58},{2.22045e-15,
          -2},{0,-2},{0,102}}, color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(swiQEva.u2, sigBus.coo) annotation (Line(points={{-58,0},{0,0},{0,102}},
        color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(swiQCon.u2, sigBus.coo) annotation (Line(points={{58,0},{0,0},{0,102}},
        color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
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
  Modular refrigerant cycle model for chiller applications used in 
  the model <a href=\"IBPSA.Fluid.Chillers.ModularReversible\">
  IBPSA.Fluid.Chillers.ModularReversible</a> and extending models 
  of the modular approach.
</p>
<p>
  This model adds the replaceable model approaches for cooling and heating data
  to the partial refrigerant cylce.
</p>
<p>
  Further, an asseration warns if the data-sources and, thus, 
  model approaches differ for cooling and heating.
</p>
</html>"));
end ChillerRefrigerantCycle;

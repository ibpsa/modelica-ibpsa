within IBPSA.Fluid.HeatPumps.BlackBoxData;
model EuropeanNorm2D "Data from European Norm in two dimensions"
  extends
    IBPSA.Fluid.HeatPumps.BlackBoxData.BaseClasses.PartialHeatPumpBlackBox(
    final datasource=dataTable.device_id,
    mEva_flow_nominal=dataTable.mEva_flow_nominal*finalScalingFactor,
    mCon_flow_nominal=dataTable.mCon_flow_nominal*finalScalingFactor,
    QUseBlackBox_flow_nominal=
        Modelica.Blocks.Tables.Internal.getTable2DValueNoDer2(
        tableConID,
        TCon_nominal - 273.15,
        TEva_nominal - 273.15));

  parameter EuropeanNorm2DData.HeatPumpBaseDataDefinition dataTable=
      IBPSA.Fluid.HeatPumps.BlackBoxData.EuropeanNorm2DData.EN255.Vitocal350AWI114()
         "Data Table of HP" annotation (choicesAllMatching=true);
  parameter Modelica.Blocks.Types.Smoothness smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments
    "Smoothness of table interpolation";
  parameter Modelica.Blocks.Types.Extrapolation extrapolation=Modelica.Blocks.Types.Extrapolation.LastTwoPoints
    "Extrapolation of data outside the definition range";

  Modelica.Blocks.Tables.CombiTable2Ds tableQCon_flow(
    final smoothness=smoothness,
    final u1(unit="degC"),
    final u2(unit="degC"),
    final y(unit="W", displayUnit="kW"),
    final table=dataTable.tableQCon_flow,
    final extrapolation=extrapolation) annotation (extent=[-60,40; -40,60],
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={50,50})));
  Modelica.Blocks.Tables.CombiTable2Ds PelTab(
    final smoothness=smoothness,
    final u1(unit="degC"),
    final u2(unit="degC"),
    final y(unit="W", displayUnit="kW"),
    final table=dataTable.tablePel,
    final extrapolation=extrapolation) "Electrical power table" annotation (
      extent=[-60,-20; -40,0], Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-50,50})));

  Modelica.Blocks.Math.UnitConversions.To_degC t_Ev_in
    annotation (extent=[-88,38; -76,50], Placement(transformation(extent={{-10,-10},
            {10,10}},
        rotation=270,
        origin={50,90})));
  Modelica.Blocks.Math.UnitConversions.To_degC t_Co_ou annotation (extent=[-88,38;
        -76,50], Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-50,90})));
  Modelica.Blocks.Math.Product nTimesPel annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-30,-10})));
  Modelica.Blocks.Math.Product nTimesQCon annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={50,-10})));

  Modelica.Blocks.Math.Product nTimesSF
    "Create the product of the scaling factor and relative compressor speed"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={10,10})));

protected
  final parameter Real perDevMasFloCon = (mCon_flow_nominal - dataTable.mCon_flow_nominal*finalScalingFactor)/mCon_flow_nominal*100 "Deviation of nominal mass flow rate at condenser in percent";
  final parameter Real perDevMasFloEva = (mEva_flow_nominal - dataTable.mEva_flow_nominal*finalScalingFactor)/mEva_flow_nominal*100 "Deviation of nominal mass flow rate at evaporator in percent";

  Modelica.Blocks.Sources.Constant realCorr(final k=finalScalingFactor)
    "Calculates correction of table output based on scaling factor"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-10,50})));
  parameter Modelica.Blocks.Types.ExternalCombiTable2D tableConID=
      Modelica.Blocks.Types.ExternalCombiTable2D("NoName", "NoName", dataTable.tableQCon_flow, smoothness, extrapolation, false) "External table object";
initial equation
  assert(perDevMasFloCon < 1,
      "The deviation of the given mCon_flow_nominal to the table data is " +
      String(perDevMasFloCon) + " %. Carefully check results, you are extrapolating the table data!",
    AssertionLevel.warning);
  assert(perDevMasFloEva < 1,
    "The deviation of the given mEva_flow_nominal to the table data is " +
      String(perDevMasFloEva) + " %. Carefully check results, you are extrapolating the table data!",
    AssertionLevel.warning);


equation
  connect(t_Ev_in.y, tableQCon_flow.u2) annotation (Line(points={{50,79},{50,74},
          {44,74},{44,62}}, color={0,0,127}));
  connect(t_Ev_in.y, PelTab.u2) annotation (Line(points={{50,79},{50,74},{-56,74},
          {-56,62}}, color={0,0,127}));
  connect(t_Co_ou.y, PelTab.u1) annotation (Line(points={{-50,79},{-50,68},{-44,
          68},{-44,62}}, color={0,0,127}));
  connect(t_Co_ou.y, tableQCon_flow.u1) annotation (Line(points={{-50,79},{-50,68},
          {56,68},{56,62}}, color={0,0,127}));
  connect(sigBus.TConOutMea, t_Co_ou.u) annotation (Line(
      points={{1,104},{0,104},{0,88},{-4,88},{-4,86},{-34,86},{-34,110},{-50,110},
          {-50,102}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(sigBus.TEvaInMea, t_Ev_in.u) annotation (Line(
      points={{1,104},{0,104},{0,86},{34,86},{34,108},{50,108},{50,102}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(PelTab.y, nTimesPel.u2) annotation (Line(points={{-50,39},{-50,8},{-36,
          8},{-36,2}}, color={0,0,127}));
  connect(tableQCon_flow.y, nTimesQCon.u1)
    annotation (Line(points={{50,39},{50,8},{56,8},{56,2}}, color={0,0,127}));
  connect(nTimesPel.y, Pel) annotation (Line(points={{-30,-21},{-30,-80},{0,-80},
          {0,-110}},               color={0,0,127}));
  connect(realCorr.y, nTimesSF.u2) annotation (Line(points={{-10,39},{-10,30},{4,
          30},{4,22}},         color={0,0,127}));
  connect(sigBus.ySet, nTimesSF.u1) annotation (Line(
      points={{1,104},{0,104},{0,64},{16,64},{16,22}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(nTimesSF.y, nTimesPel.u1) annotation (Line(points={{10,-1},{10,-6},{-14,
          -6},{-14,10},{-24,10},{-24,2}},
                                     color={0,0,127}));
  connect(nTimesSF.y, nTimesQCon.u2) annotation (Line(points={{10,-1},{10,-6},{34,
          -6},{34,8},{44,8},{44,2}},color={0,0,127}));
  connect(nTimesPel.y, calcRedQCon.u2) annotation (Line(points={{-30,-21},{-30,-48},
          {64,-48},{64,-58}},                color={0,0,127}));
  connect(nTimesPel.y, feedbackHeatFlowEvaporator.u2) annotation (Line(points={{-30,-21},
          {-30,-20},{-56,-20},{-56,-24},{-70,-24},{-70,-18}},     color={0,0,
          127}));
  connect(nTimesQCon.y, feedbackHeatFlowEvaporator.u1) annotation (Line(points={{50,-21},
          {50,-26},{-96,-26},{-96,-10},{-78,-10}},     color={0,0,127}));
  annotation (Icon(graphics={
    Line(points={{-60.0,40.0},{-60.0,-40.0},{60.0,-40.0},{60.0,40.0},{30.0,40.0},{30.0,-40.0},{-30.0,-40.0},{-30.0,40.0},{-60.0,40.0},{-60.0,20.0},{60.0,20.0},{60.0,0.0},{-60.0,0.0},{-60.0,-20.0},{60.0,-20.0},{60.0,-40.0},{-60.0,-40.0},{-60.0,40.0},{60.0,40.0},{60.0,-40.0}}),
    Line(points={{0.0,40.0},{0.0,-40.0}}),
    Rectangle(fillColor={255,215,136},
      fillPattern=FillPattern.Solid,
      extent={{-60.0,20.0},{-30.0,40.0}}),
    Rectangle(fillColor={255,215,136},
      fillPattern=FillPattern.Solid,
      extent={{-60.0,0.0},{-30.0,20.0}}),
    Rectangle(fillColor={255,215,136},
      fillPattern=FillPattern.Solid,
      extent={{-60.0,-20.0},{-30.0,0.0}}),
    Rectangle(fillColor={255,215,136},
      fillPattern=FillPattern.Solid,
      extent={{-60.0,-40.0},{-30.0,-20.0}})}), Documentation(revisions="<html>
<ul>
  <li>
    <i>May 21, 2021</i> by Fabian Wuellhorst:<br/>
    Make use of BaseClasses (see issue <a href=
    \"https://github.com/RWTH-EBC/AixLib/issues/1092\">AixLib #1092</a>)
  </li>
  <li>
    <i>November 26, 2018</i> by Fabian Wuellhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/RWTH-EBC/AixLib/issues/577\">AixLib #577</a>)
  </li>
</ul>
</html>", info="<html>
<p>
  This model uses the 2-dimensional table data given in the DIN EN
  14511 (formerly EN255) to calculate <i>QCon</i> and <i>P_el</i>. To
  model an inverter controlled heat pump, the relative <b>compressor
  speed <i>n</i> is scaled linearly</b> with the ouput of the tables.
  Furthermore, the design of a heat pump is modeled via a scaling
  factor. As a result, the equations follow below:
</p>
<p style=\"text-align:center;\">
  <i>QCon,n = n * scalingFactor * TableQCon.y</i>
</p>
<p style=\"text-align:center;\">
  <i>P_el = n * scalingFactor * TablePel.y</i>
</p>
<p style=\"text-align:justify;\">
  To simulate possible icing of the evaporator on air-source heat
  pumps, the icing factor is used to influence the output as well. As
  the factor resembles the reduction of heat transfer between
  refrigerant and source, the factor is implemented as follows:
</p>
<p style=\"text-align:center;\">
  <i>QEva = iceFac * (QCon,n-P_el,n)</i>
</p>
<p>
  With <i>iceFac</i> as a relative value between 0 and 1:
</p>
<p style=\"text-align:center;\">
  <i>iceFac = kA/kA_noIce</i>
</p>
<p>
  Finally, to follow the first law of thermodynamics:
</p>
<p style=\"text-align:center;\">
  <i>QCon = P_el,n + QEva</i>
</p>
<h4>
  Known Limitations
</h4>
<p>
  The model <a href=
  \"modelica://IBPSA.Utilities.Tables.CombiTable2DExtra\">CombiTable2DExtra</a>
  is able to disallow extrapolation by holding the last value. If one
  extrapolates the given perfomance data, warnings about occuring
  extrapolations are emitted. <b>CAUTION: Checking for possible
  extrapolations will trigger state events which results in higher
  computing time.</b>
</p>
</html>"));
end EuropeanNorm2D;

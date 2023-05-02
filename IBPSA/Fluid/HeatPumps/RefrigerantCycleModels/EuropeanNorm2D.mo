within IBPSA.Fluid.HeatPumps.RefrigerantCycleModels;
model EuropeanNorm2D "Data from European Norm in two dimensions"
  extends
    IBPSA.Fluid.HeatPumps.RefrigerantCycleModels.BaseClasses.PartialHeatPumpRefrigerantCycle(
    final datSou=datTab.device_id,
    mEva_flow_nominal=datTab.mEva_flow_nominal*scaFac,
    mCon_flow_nominal=datTab.mCon_flow_nominal*scaFac,
    QUseNoSca_flow_nominal=
        Modelica.Blocks.Tables.Internal.getTable2DValueNoDer2(
        tabConID,
        TCon_nominal - 273.15,
        TEva_nominal - 273.15));

  parameter EuropeanNorm2DData.HeatPumpBaseDataDefinition datTab=
      IBPSA.Fluid.HeatPumps.RefrigerantCycleModels.EuropeanNorm2DData.EN255.Vitocal350AWI114()
         "Data Table of HP" annotation (choicesAllMatching=true);
  parameter Modelica.Blocks.Types.Smoothness smoothness=
    Modelica.Blocks.Types.Smoothness.LinearSegments
    "Smoothness of table interpolation";
  parameter Modelica.Blocks.Types.Extrapolation extrapolation=
    Modelica.Blocks.Types.Extrapolation.LastTwoPoints
    "Extrapolation of data outside the definition range";

  Modelica.Blocks.Tables.CombiTable2Ds tabQCon_flow(
    final smoothness=smoothness,
    final u1(unit="degC"),
    final u2(unit="degC"),
    final y(unit="W", displayUnit="kW"),
    final table=datTab.tableQCon_flow,
    final extrapolation=extrapolation) annotation (Placement(transformation(
          extent={{-10,-10},{10,10}}, rotation=-90,
        origin={30,50})));
  Modelica.Blocks.Tables.CombiTable2Ds tabPEle(
    final smoothness=smoothness,
    final u1(unit="degC"),
    final u2(unit="degC"),
    final y(unit="W", displayUnit="kW"),
    final table=datTab.tablePel,
    final extrapolation=extrapolation) "Electrical power table" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={70,50})));

  Modelica.Blocks.Math.UnitConversions.To_degC TEvaInToDegC
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=270,
        origin={-50,90})));
  Modelica.Blocks.Math.UnitConversions.To_degC TConOutToDegC
    annotation (Placement(
        transformation(extent={{-10,-10},{10,10}}, rotation=270,
        origin={50,90})));
  Modelica.Blocks.Math.Product nTimesPel annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-30,-10})));
  Modelica.Blocks.Math.Product nTimesQCon annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={50,-10})));

  Modelica.Blocks.Math.Product nTimesScaFac
    "Create the product of the scaling factor and relative compressor speed"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}}, rotation=-90,
        origin={-70,30})));

protected
  final parameter Real perDevMasFloCon=
    (mCon_flow_nominal - datTab.mCon_flow_nominal*scaFac)/mCon_flow_nominal*100
    "Deviation of nominal mass flow rate at condenser in percent";
  final parameter Real perDevMasFloEva=
    (mEva_flow_nominal - datTab.mEva_flow_nominal*scaFac)/mEva_flow_nominal*100
    "Deviation of nominal mass flow rate at evaporator in percent";

  Modelica.Blocks.Sources.Constant constScaFac(final k=scaFac)
    "Calculates correction of table output based on scaling factor"
    annotation (Placement(
        transformation(extent={{-10,-10},{10,10}}, rotation=270,
        origin={-90,70})));
  parameter Modelica.Blocks.Types.ExternalCombiTable2D tabConID=
      Modelica.Blocks.Types.ExternalCombiTable2D(
      "NoName",
      "NoName",
      datTab.tableQCon_flow,
      smoothness,
      extrapolation,
      false) "External table object";
initial equation
  assert(perDevMasFloCon < 1,
      "The deviation of the given mCon_flow_nominal to the table data is " +
      String(perDevMasFloCon) + " %. Carefully check results, 
      you are extrapolating the table data!",
    AssertionLevel.warning);
  assert(perDevMasFloEva < 1,
    "The deviation of the given mEva_flow_nominal to the table data is " +
      String(perDevMasFloEva) + " %. Carefully check results, 
      you are extrapolating the table data!",
    AssertionLevel.warning);

equation
  connect(TEvaInToDegC.y, tabQCon_flow.u2) annotation (Line(points={{-50,79},{-50,
          74},{24,74},{24,62}},
                            color={0,0,127}));
  connect(TEvaInToDegC.y, tabPEle.u2) annotation (Line(points={{-50,79},{-50,74},
          {64,74},{64,62}}, color={0,0,127}));
  connect(TConOutToDegC.y, tabPEle.u1) annotation (Line(points={{50,79},{50,78},
          {54,78},{54,76},{76,76},{76,62}}, color={0,0,127}));
  connect(TConOutToDegC.y, tabQCon_flow.u1)
    annotation (Line(points={{50,79},{50,70},{36,70},{36,62}},
                                                            color={0,0,127}));
  connect(sigBus.TConOutMea, TConOutToDegC.u) annotation (Line(
      points={{1,104},{0,104},{0,84},{36,84},{36,108},{50,108},{50,102}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(sigBus.TEvaInMea, TEvaInToDegC.u) annotation (Line(
      points={{1,104},{0,104},{0,86},{-34,86},{-34,110},{-50,110},{-50,102}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(tabPEle.y, nTimesPel.u2) annotation (Line(points={{70,39},{70,34},{-24,
          34},{-24,8},{-36,8},{-36,2}}, color={0,0,127}));
  connect(tabQCon_flow.y, nTimesQCon.u1)
    annotation (Line(points={{30,39},{30,20},{56,20},{56,2}},
                                                           color={0,0,127}));
  connect(nTimesPel.y, PEle) annotation (Line(points={{-30,-21},{-30,-80},{0,-80},
          {0,-110}}, color={0,0,127}));
  connect(constScaFac.y, nTimesScaFac.u2) annotation (Line(points={{-90,59},{-90,
          50},{-76,50},{-76,42}},                  color={0,0,127}));
  connect(sigBus.ySet, nTimesScaFac.u1) annotation (Line(
      points={{1,104},{0,104},{0,76},{-64,76},{-64,42}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(nTimesScaFac.y, nTimesPel.u1) annotation (Line(points={{-70,19},{-70,14},
          {-20,14},{-20,6},{-16,6},{-16,2},{-24,2}},             color={0,0,127}));
  connect(nTimesScaFac.y, nTimesQCon.u2) annotation (Line(points={{-70,19},{-70,
          14},{46,14},{46,8},{44,8},{44,2}},                    color={0,0,127}));
  connect(nTimesPel.y, redQCon.u2) annotation (Line(points={{-30,-21},{-30,-48},
          {64,-48},{64,-58}}, color={0,0,127}));
  connect(nTimesPel.y, feeHeaFloEva.u2) annotation (Line(points={{-30,-21},{-30,
          -20},{-56,-20},{-56,-24},{-70,-24},{-70,-18}}, color={0,0,127}));
  connect(nTimesQCon.y, feeHeaFloEva.u1) annotation (Line(points={{50,-21},{50,
          -26},{-96,-26},{-96,-10},{-78,-10}}, color={0,0,127}));
  annotation (Icon(graphics={
    Line(points={
          {-60.0,40.0},{-60.0,-40.0},{60.0,-40.0},{60.0,40.0},{30.0,40.0},
          {30.0,-40.0},{-30.0,-40.0},{-30.0,40.0},{-60.0,40.0},{-60.0,20.0},
          {60.0,20.0},{60.0,0.0},{-60.0,0.0},{-60.0,-20.0},{60.0,-20.0},
          {60.0,-40.0},{-60.0,-40.0},{-60.0,40.0},{60.0,40.0},{60.0,-40.0}}),
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
<p>This model uses the 2-dimensional table data given in the DIN EN 14511 (formerly EN255) to calculate <code>QCon</code> and <code>P_el</code>. </p>
<p><br>This standard defines two of the three values electrical power consumption, condenser heat flow rate, and COP for different condenser outlet and evaporator inlet temperatures.</p>
<p>Known Limitations</p>
<p>The standard does not require to provide the compressor speed at wich the data holds. Thus, nominal values may be obtained at different compressor speeds and, thus, efficiencies. Depending on your simulation aim, please check that you use the maximal possible power information, which is often provided in the data sheets from the manufacturers. This limitation only holds for inverter driven heat pumps.</p>
<p>As the standard does not require the compressor speed, we assume that </p>
<p>To model an inverter controlled heat pump, the relative <b>compressor speed <code>ySet</code> is scaled linearly</b> with the ouput of the tables.</p>
<p>Furthermore, the design of a heat pump is modeled via a scaling factor. As a result, the equations follow below: </p>
<p><code>QCon,n = ySet * scaFac * tabQCon_flow.y</code> </p>
<p><code>P_el = n * scaFac * tabPel.y</code> </p>
<h4>Known Limitations </h4>
<p>The model is able to disallow extrapolation by holding the last value. If one extrapolates the given perfomance data, warnings about occuring extrapolations are emitted.</p>
</html>"));
end EuropeanNorm2D;

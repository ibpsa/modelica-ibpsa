within IBPSA.Fluid.HeatPumps.RefrigerantCycleModels;
model EuropeanNorm2D "Data from European Norm in two dimensions"
  extends
    IBPSA.Fluid.HeatPumps.RefrigerantCycleModels.BaseClasses.PartialHeatPumpRefrigerantCycle(
    final datSou=datTab.devIde,
    mEva_flow_nominal=datTab.mEva_flow_nominal*scaFac,
    mCon_flow_nominal=datTab.mCon_flow_nominal*scaFac,
    QUseNoSca_flow_nominal=
        Modelica.Blocks.Tables.Internal.getTable2DValueNoDer2(
        tabIdeQUse_flow,
        TCon_nominal - 273.15,
        TEva_nominal - 273.15));
  extends
    IBPSA.Fluid.HeatPumps.RefrigerantCycleModels.BaseClasses.PartialEuropeanNorm2D(
    perDevMasFloCon=(mCon_flow_nominal - datTab.mCon_flow_nominal*scaFac)/mCon_flow_nominal*100,
    perDevMasFloEva=(mEva_flow_nominal - datTab.mEva_flow_nominal*scaFac)/mEva_flow_nominal*100);


  parameter IBPSA.Fluid.HeatPumps.RefrigerantCycleModels.EuropeanNorm2DData.HeatPumpBaseDataDefinition datTab=
      IBPSA.Fluid.HeatPumps.RefrigerantCycleModels.EuropeanNorm2DData.EN255.Vitocal350AWI114()
         "Data Table of HP" annotation (choicesAllMatching=true);

equation

  if datTab.use_conOut then
    connect(sigBus.TConOutMea, TConToDegC.u) annotation (Line(
      points={{1,104},{0,104},{0,88},{60,88},{60,82}},
      color={255,204,51},
      thickness=0.5));
  else
    connect(sigBus.TConInMea, TConToDegC.u) annotation (Line(
      points={{1,104},{0,104},{0,88},{60,88},{60,82}},
      color={255,204,51},
      thickness=0.5));
  end if;
  if datTab.use_evaOut then
    connect(sigBus.TEvaOutMea, TEvaToDegC.u) annotation (Line(
      points={{1,104},{0,104},{0,88},{-40,88},{-40,82}},
      color={255,204,51},
      thickness=0.5));
  else
    connect(sigBus.TEvaInMea, TEvaToDegC.u) annotation (Line(
        points={{1,104},{0,104},{0,88},{-40,88},{-40,82}},
        color={255,204,51},
        thickness=0.5));
  end if;

  connect(scaFacTimPel.y, feeHeaFloEva.u2) annotation (Line(points={{-40,-11},{-40,
          -24},{-70,-24},{-70,-18}}, color={0,0,127}));
  connect(scaFacTimPel.y, PEle) annotation (Line(points={{-40,-11},{-40,-24},{0,
          -24},{0,-110}}, color={0,0,127}));
  connect(scaFacTimPel.y, redQCon.u2) annotation (Line(points={{-40,-11},{-40,-24},
          {64,-24},{64,-58}}, color={0,0,127}));
  connect(scaFacTimQUse_flow.y, feeHeaFloEva.u1) annotation (Line(points={{40,-11},
          {40,-18},{-86,-18},{-86,-10},{-78,-10}}, color={0,0,127}));
  connect(ySetTimScaFac.u1, sigBus.ySet) annotation (Line(points={{-64,48},{-64,
          94},{1,94},{1,104}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
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
<p>This model uses the 2-dimensional table data given in the DIN EN 14511 (formerly EN255) to calculate <code>QCon</code> and <code>PEle</code>. </p>
<p><br>This standard defines two of the three values electrical power consumption, condenser heat flow rate, and COP for different condenser outlet and evaporator inlet temperatures.</p>
<p>Known Limitations</p>
<p>The standard does not require to provide the compressor speed at wich the data holds. Thus, nominal values may be obtained at different compressor speeds and, thus, efficiencies. Depending on your simulation aim, please check that you use the maximal possible power information, which is often provided in the data sheets from the manufacturers. This limitation only holds for inverter driven heat pumps.</p>
<p>As the standard does not require the compressor speed, we assume that </p>
<p>To model an inverter controlled heat pump, the relative <b>compressor speed <code>ySet</code> is scaled linearly</b> with the ouput of the tables.</p>
<p>Furthermore, the design of a heat pump is modeled via a scaling factor. As a result, the equations follow below: </p>
<p><code>QCon,n = ySet * scaFac * tabQCon_flow.y</code> </p>
<p><code>PEle = n * scaFac * tabPel.y</code> </p>
<h4>Known Limitations </h4>
<p>The model is able to disallow extrapolation by holding the last value. If one extrapolates the given perfomance data, warnings about occuring extrapolations are emitted.</p>
</html>"));
end EuropeanNorm2D;

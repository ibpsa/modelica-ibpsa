within IBPSA.Fluid.Chillers.ModularReversible.RefrigerantCycle;
model EuropeanNorm2D
  "Two-Dimensional performance data"
  extends
    IBPSA.Fluid.Chillers.ModularReversible.RefrigerantCycle.BaseClasses.PartialChillerCycle(
    final datSou=datTab.devIde,
    mEva_flow_nominal=datTab.mEva_flow_nominal*scaFac,
    mCon_flow_nominal=datTab.mCon_flow_nominal*scaFac,
    final PEle_nominal=Modelica.Blocks.Tables.Internal.getTable2DValueNoDer2(
        tabIdePEle,
        TCon_nominal - 273.15,
        TEva_nominal - 273.15) * scaFac,
    QUseNoSca_flow_nominal=
        Modelica.Blocks.Tables.Internal.getTable2DValueNoDer2(
        tabIdeQUse_flow,
        TCon_nominal - 273.15,
        TEva_nominal - 273.15));
  extends
    IBPSA.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.PartialEuropeanNorm2D(
    final use_conOut=datTab.use_conOut,
    final use_evaOut=datTab.use_evaOut,
    tabQUse_flow(final table=datTab.tabQEva_flow),
    tabPEle(final table=datTab.tabPEle),
    final perDevMasFloEva=(mEva_flow_nominal - datTab.mEva_flow_nominal*scaFac)/mEva_flow_nominal*100,
    final perDevMasFloCon=(mCon_flow_nominal - datTab.mCon_flow_nominal*scaFac)/mCon_flow_nominal*100,
    constScaFac(final k=scaFac));
  parameter IBPSA.Fluid.Chillers.ModularReversible.Data.EuropeanNorm2D.Generic datTab=
      IBPSA.Fluid.Chillers.ModularReversible.Data.EuropeanNorm2D.EN14511.Vitocal200AWO201()
    "Data Table of Chiller" annotation (choicesAllMatching=true);

equation

  connect(scaFacTimPel.y, PEle) annotation (Line(points={{-40,-11},{-40,-26},{-30,
          -26},{-30,-94},{0,-94},{0,-110}}, color={0,0,127}));
  connect(scaFacTimPel.y, redQCon.u2) annotation (Line(points={{-40,-11},{-40,-26},
          {-30,-26},{-30,-48},{64,-48},{64,-58}}, color={0,0,127}));
  connect(scaFacTimQUse_flow.y, proRedQEva.u2) annotation (Line(points={{40,-11},
          {40,-40},{-44,-40},{-44,-58}}, color={0,0,127}));
  connect(ySetTimScaFac.u1, sigBus.ySet) annotation (Line(points={{-64,48},{-64,
          100},{-10,100},{-10,104},{1,104}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(reaPasThrTEvaOut.u, sigBus.TEvaOutMea) annotation (Line(points={{-20,102},
          {-20,104},{1,104}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(reaPasThrTEvaIn.u, sigBus.TEvaInMea) annotation (Line(points={{-50,102},
          {-50,106},{0,106},{0,104},{1,104}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(reaPasThrTConIn.u, sigBus.TConInMea) annotation (Line(points={{40,102},
          {40,104},{1,104}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(reaPasThrTConOut.u, sigBus.TConOutMea) annotation (Line(points={{70,102},
          {70,104},{1,104}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  annotation (Icon(graphics={
    Line(points={{-60.0,40.0},{-60.0,-40.0},{60.0,-40.0},{60.0,40.0},
      {30.0,40.0},{30.0,-40.0},{-30.0,-40.0},{-30.0,40.0},{-60.0,40.0},
      {-60.0,20.0},{60.0,20.0},{60.0,0.0},{-60.0,0.0},{-60.0,-20.0},
      {60.0,-20.0},{60.0,-40.0},{-60.0,-40.0},{-60.0,40.0},{60.0,40.0},
      {60.0,-40.0}}),
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
      extent={{-60.0,-40.0},{-30.0,-20.0}})}), Documentation(revisions="<html><ul>
  <li>
    <i>October 2, 2022</i> by Fabian Wuellhorst:<br/>
    Adjusted based on the discussion in this issue <a href=
    \"https://github.com/ibpsa/modelica-ibpsa/issues/1576\">#1576</a>)
  </li>
  <li>
    <i>May 22, 2019&#160;</i> by Julian Matthes:<br/>
    First implementation (see issue <a href=
    \"https://github.com/RWTH-EBC/AixLib/issues/715\">AixLib #715</a>)
  </li>
</ul>
</html>", info="<html>
<p>
  This model uses the 2-dimensional table data given in the
  DIN EN 14511 (formerly EN255) to calculate
  <code>QEva_flow</code> and <code>PEle</code>.
</p>
<p>
  The standard defines two of the three values electrical power consumption,
  evaporator heat flow rate, and COP for different condenser outlet and
  evaporator inlet temperatures.
</p>
<p>
  Based on the two powers, the equation <code>QCon_flow = QEva_flow + PEle</code>
  is solved, assuming an adiabatic device. However, as losses are implicitly
  included in the measured data, the model still account for such losses.
  Same hold true for frosting effects, as frosting decreases the COP in the
  standard.
</p>

<h4>Scaling factor</h4>
For the scaling factor, the table data for evaporator heat flow rate
is evaluated at nominal conditions. Then, the table data is scaled linearly.
This implies a constant COP over different design sizes:
<p><code>QEva_flow = scaFac * tabQEva_flow.y</code> </p>
<p><code>PEle = scaFac * tabPel.y</code>


<h4>Known Limitations </h4>
<ul>
<li>
  The standard does not require providing the compressor speed at which
  the data are measured. Thus, nominal values may be obtained at different
  compressor speeds and, thus, efficiencies.
  To accurately model the available thermal output, 
  please check that you use tables of the maximal thermal output, 
  which is often provided in the data sheets from the manufacturers. 
  This limitation only holds for inverter driven chillers.
</li>
<li>
  We assume that the efficiency is contant over the whole
  compressor speed range. Typically, efficiencies will drop at minimal
  and maximal compressor speeds.
  To model an inverter controlled chiller, the relative
  compressor speed <code>ySet</code> is used to scale
  the ouput of the tables linearly.
  For models including the compressor speed, check the SDF-Library
  dependent refrigerant cycle models in the AixLib.
</li>
</ul>
</html>"));
end EuropeanNorm2D;

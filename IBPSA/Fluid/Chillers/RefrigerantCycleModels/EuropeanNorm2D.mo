within IBPSA.Fluid.Chillers.RefrigerantCycleModels;
model EuropeanNorm2D
  "Performance data coming from manufacturer according to European Standards"
  extends
    IBPSA.Fluid.Chillers.RefrigerantCycleModels.BaseClasses.PartialChillerRefrigerantCycle(
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
    tabQUse_flow(final table=datTab.tabQEva_flow),
    tabPEle(final table=datTab.tabPEle),
    final perDevMasFloEva=(mEva_flow_nominal - datTab.mEva_flow_nominal*scaFac)/mEva_flow_nominal*100,
    final perDevMasFloCon=(mCon_flow_nominal - datTab.mCon_flow_nominal*scaFac)/mCon_flow_nominal*100);
  parameter IBPSA.Fluid.Chillers.RefrigerantCycleModels.EuropeanNorm2DData.ChillerBaseDataDefinition datTab=
      IBPSA.Fluid.Chillers.RefrigerantCycleModels.EuropeanNorm2DData.EN14511.Vitocal200AWO201()
         "Data Table of Chiller" annotation (choicesAllMatching=true);

equation
  if datTab.use_conOut then
    connect(sigBus.TConOutMea, TConToDegC.u) annotation (Line(
      points={{1,104},{0,104},{0,86},{60,86},{60,82}},
      color={255,204,51},
      thickness=0.5));
  else
    connect(sigBus.TConInMea, TConToDegC.u) annotation (Line(
      points={{1,104},{0,104},{0,86},{60,86},{60,82}},
      color={255,204,51},
      thickness=0.5));
  end if;
  if datTab.use_evaOut then
    connect(sigBus.TEvaOutMea, TEvaToDegC.u) annotation (Line(
      points={{1,104},{0,104},{0,86},{-40,86},{-40,82}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  else
    connect(sigBus.TEvaOutMea, TEvaToDegC.u) annotation (Line(
      points={{1,104},{0,104},{0,86},{-40,86},{-40,82}},
      color={255,204,51},
      thickness=0.5));
  end if;
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
<p>This model uses the 2-dimensional table data given in the DIN EN 14511 
(formerly EN255) to calculate <code>QEva</code> and <code>PEle</code>. </p>
<p>To model an inverter controlled chiller, the relative <b>compressor speed 
<code>ySet</code> is scaled linearly</b> with the ouput of the tables.</p>
<p>Furthermore, the design of a chiller is modeled via a scaling factor. 
As a result, the equations follow below: </p>
<p><code>QEva = ySet * scaFac * tabQEva_flow.y</code> </p>
<p><code>PEle = n * scaFac * tabPel.y</code> </p>
<h4>Known Limitations </h4>
<p>The model is able to disallow extrapolation by holding the last value. 
If one extrapolates the given perfomance data, warnings about occuring 
extrapolations are emitted.</p>
</html>"));
end EuropeanNorm2D;

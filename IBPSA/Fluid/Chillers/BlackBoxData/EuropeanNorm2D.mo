within IBPSA.Fluid.Chillers.BlackBoxData;
model EuropeanNorm2D
  "Performance data coming from manufacturer according to European Standards"
  extends IBPSA.Fluid.Chillers.BlackBoxData.BaseClasses.PartialChillerBlackBox(
    final datSou=datTab.device_id,
    mEva_flow_nominal=datTab.mEva_flow_nominal*scaFac,
    mCon_flow_nominal=datTab.mCon_flow_nominal*scaFac,
    QUseBlaBox_flow_nominal=
        Modelica.Blocks.Tables.Internal.getTable2DValueNoDer2(
        tableConID,
        TCon_nominal - 273.15,
        TEva_nominal - 273.15));

  parameter Modelica.Blocks.Types.Smoothness smoothness=
    Modelica.Blocks.Types.Smoothness.LinearSegments
    "Smoothness of table interpolation";
  parameter EuropeanNorm2DData.ChillerBaseDataDefinition datTab=
      IBPSA.Fluid.Chillers.BlackBoxData.EuropeanNorm2DData.EN14511.Vitocal200AWO201()
         "Data Table of Chiller" annotation (choicesAllMatching=true);
  parameter Modelica.Blocks.Types.Extrapolation extrapolation=
    Modelica.Blocks.Types.Extrapolation.LastTwoPoints
    "Extrapolation of data outside the definition range";

  Modelica.Blocks.Tables.CombiTable2Ds tabQEva_flow(
    final smoothness=smoothness,
    final u1(unit="degC"),
    final u2(unit="degC"),
    final y(unit="W", displayUnit="kW"),
    final extrapolation=extrapolation,
    final table=datTab.tableQEva_flow) "Evaporator heat flow table"
                                       annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={50,50})));
  Modelica.Blocks.Tables.CombiTable2Ds tabPel(
    final smoothness=smoothness,
    final extrapolation=extrapolation,
    final u1(unit="degC"),
    final u2(unit="degC"),
    final y(unit="W", displayUnit="kW"),
    final table=datTab.tablePel) "Electrical power table" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-70,50})));

  Modelica.Blocks.Math.UnitConversions.To_degC TConInToDegC
    "Table input is in degC"                                annotation (extent=[
        -88,38; -76,50], Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={50,90})));
  Modelica.Blocks.Math.UnitConversions.To_degC TEvaOutToDegC
    "Table input is in degC"                                 annotation (extent=
       [-88,38; -76,50], Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-70,90})));
  Modelica.Blocks.Math.Product nTimPel "Scale Pel using ySet and scaFac"
                                       annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-30,-10})));
  Modelica.Blocks.Math.Product nTimEva "Scale QEva_flow using ySet and scaFac"
                                       annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={50,10})));

  Modelica.Blocks.Math.Product nTimScaFac
    "Create the product of the scaling factor and relative compressor speed"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={10,20})));

protected
  Modelica.Blocks.Sources.Constant realCorr(final k=scaFac)
    "Calculates correction of table output based on scaling factor" annotation (
     Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-10,50})));

protected
  parameter Modelica.Blocks.Types.ExternalCombiTable2D tableConID=
      Modelica.Blocks.Types.ExternalCombiTable2D(
      "NoName",
      "NoName",
      datTab.tableQEva_flow,
      smoothness,
      extrapolation,
      false) "External table object";

equation

  connect(TConInToDegC.y, tabQEva_flow.u2) annotation (Line(points={{50,79},{50,
          86},{44,86},{44,62}}, color={0,0,127}));
  connect(TConInToDegC.y, tabPel.u2) annotation (Line(points={{50,79},{50,86},{44,
          86},{44,68},{36,68},{36,70},{-68,70},{-68,72},{-82,72},{-82,62},{-76,62}},
        color={0,0,127}));
  connect(TEvaOutToDegC.y, tabPel.u1) annotation (Line(points={{-70,79},{-70,68},
          {-64,68},{-64,62}}, color={0,0,127}));
  connect(TEvaOutToDegC.y, tabQEva_flow.u1) annotation (Line(points={{-70,79},{-70,
          68},{-58,68},{-58,66},{-6,66},{-6,68},{38,68},{38,84},{56,84},{56,62}},
        color={0,0,127}));
  connect(sigBus.TEvaOutMea, TEvaOutToDegC.u) annotation (Line(
      points={{1,104},{0,104},{0,88},{-6,88},{-6,86},{-54,86},{-54,110},{-70,110},
          {-70,102}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(sigBus.TConInMea, TConInToDegC.u) annotation (Line(
      points={{1,104},{0,104},{0,86},{34,86},{34,108},{50,108},{50,102}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(tabPel.y, nTimPel.u2) annotation (Line(points={{-70,39},{-70,10},{-36,
          10},{-36,2}}, color={0,0,127}));
  connect(tabQEva_flow.y, nTimEva.u1) annotation (Line(points={{50,39},{50,26},{
          56,26},{56,22}}, color={0,0,127}));

  connect(nTimPel.y, PEle) annotation (Line(points={{-30,-21},{-30,-94},{0,-94},
          {0,-110}}, color={0,0,127}));
  connect(realCorr.y, nTimScaFac.u2)
    annotation (Line(points={{-10,39},{-10,32},{4,32}}, color={0,0,127}));
  connect(sigBus.ySet, nTimScaFac.u1) annotation (Line(
      points={{1,104},{0,104},{0,64},{16,64},{16,32}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(nTimScaFac.y, nTimPel.u1)
    annotation (Line(points={{10,9},{10,2},{-24,2}}, color={0,0,127}));
  connect(nTimScaFac.y, nTimEva.u2) annotation (Line(points={{10,9},{10,4},{34,4},
          {34,28},{44,28},{44,22}}, color={0,0,127}));
  connect(nTimPel.y, redQCon.u2) annotation (Line(points={{-30,-21},{-30,-48},{
          64,-48},{64,-58}}, color={0,0,127}));
  connect(nTimEva.y, proRedQEva.u2) annotation (Line(points={{50,-1},{50,-28},{
          -44,-28},{-44,-58}}, color={0,0,127}));
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
(formerly EN255) to calculate <code>QEva</code> and <code>P_el</code>. </p>
<p>To model an inverter controlled chiller, the relative <b>compressor speed 
<code>ySet</code> is scaled linearly</b> with the ouput of the tables.</p>
<p>Furthermore, the design of a chiller is modeled via a scaling factor. 
As a result, the equations follow below: </p>
<p><code>QEva = ySet * scaFac * tabQEva_flow.y</code> </p>
<p><code>P_el = n * scaFac * tabPel.y</code> </p>
<h4>Known Limitations </h4>
<p>The model is able to disallow extrapolation by holding the last value. 
If one extrapolates the given perfomance data, warnings about occuring 
extrapolations are emitted.</p>
</html>"));
end EuropeanNorm2D;

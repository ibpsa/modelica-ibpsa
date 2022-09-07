within IBPSA.Fluid.Chillers.BlackBoxData;
model LookUpTable2D "Performance data coming from manufacturer"
  extends IBPSA.Fluid.Chillers.BlackBoxData.BaseClasses.PartialChillerBlackBox(
    datasource=dataTable.device_id,
    mEva_flow_nominal=dataTable.mEva_flow_nominal*finalScalingFactor,
    mCon_flow_nominal=dataTable.mCon_flow_nominal*finalScalingFactor,
    QUseBlackBox_flow_nominal=
        Modelica.Blocks.Tables.Internal.getTable2DValueNoDer2(
        tableConID,
        TCon_nominal - 273.15,
        TEva_nominal - 273.15));

  parameter Modelica.Blocks.Types.Smoothness smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments
    "Smoothness of table interpolation";
  parameter
    IBPSA.Fluid.Chillers.BlackBoxData.EuropeanNorm2D.ChillerBaseDataDefinition
    dataTable=
      IBPSA.Fluid.Chillers.BlackBoxData.EuropeanNorm2D.EN14511.Vitocal200AWO201
      () "Data Table of Chiller" annotation (choicesAllMatching=true);
  parameter Modelica.Blocks.Types.Extrapolation extrapolation=Modelica.Blocks.Types.Extrapolation.LastTwoPoints
    "Extrapolation of data outside the definition range";

  Modelica.Blocks.Tables.CombiTable2Ds     Qdot_EvaTable(
    final smoothness=smoothness,
    final u1(unit="degC"),
    final u2(unit="degC"),
    final y(unit="W", displayUnit="kW"),
    final extrapolation=extrapolation,
    final table=dataTable.tableQdot_eva) annotation (extent=[-60,40; -40,60],
      Placement(transformation(
        extent={{-14,-14},{14,14}},
        rotation=-90,
        origin={46,34})));
  Modelica.Blocks.Tables.CombiTable2Ds     P_eleTable(
    final smoothness=smoothness,
    final extrapolation=extrapolation,
    final u1(unit="degC"),
    final u2(unit="degC"),
    final y(unit="W", displayUnit="kW"),
    final table=dataTable.tablePel) "Electrical power table" annotation (
      extent=[-60,-20; -40,0], Placement(transformation(
        extent={{-14,-14},{14,14}},
        rotation=-90,
        origin={-60,36})));

  Modelica.Blocks.Math.UnitConversions.To_degC t_Co_in
    annotation (extent=[-88,38; -76,50], Placement(transformation(extent={{-6,-6},
            {6,6}},
        rotation=270,
        origin={52,72})));
  Modelica.Blocks.Math.UnitConversions.To_degC t_Ev_ou annotation (extent=[-88,38;
        -76,50], Placement(transformation(extent={{-6,-6},{6,6}},
        rotation=270,
        origin={-54,76})));
  Modelica.Blocks.Math.Product nTimesPel annotation (Placement(transformation(
        extent={{-7,-7},{7,7}},
        rotation=-90,
        origin={-33,-5})));
  Modelica.Blocks.Math.Product nTimesQEva annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=-90,
        origin={40,-10})));

  Modelica.Blocks.Math.Product nTimesSF
    "Create the product of the scaling factor and relative compressor speed"
    annotation (Placement(transformation(
        extent={{-7,-7},{7,7}},
        rotation=-90,
        origin={-9,23})));

protected
  Modelica.Blocks.Sources.Constant realCorr(final k=scalingFactor)
    "Calculates correction of table output based on scaling factor"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-10,50})));

protected
  Modelica.Blocks.Sources.Constant constZero(final k=0)
    "For chilling, evaporator heat flow is calculated"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-90,10})));

protected
    parameter Modelica.Blocks.Types.ExternalCombiTable2D tableConID=
      Modelica.Blocks.Types.ExternalCombiTable2D("NoName", "NoName", dataTable.tableQdot_eva,  smoothness, extrapolation, false) "External table object";

equation

  connect(t_Co_in.y,Qdot_EvaTable. u2) annotation (Line(points={{52,65.4},{52,
          60},{37.6,60},{37.6,50.8}},      color={0,0,127}));
  connect(t_Co_in.y, P_eleTable.u2) annotation (Line(points={{52,65.4},{-68.4,
          65.4},{-68.4,52.8}},  color={0,0,127}));
  connect(t_Ev_ou.y, P_eleTable.u1) annotation (Line(points={{-54,69.4},{-54,
          52.8},{-51.6,52.8}},  color={0,0,127}));
  connect(t_Ev_ou.y,Qdot_EvaTable. u1) annotation (Line(points={{-54,69.4},{-54,
          60},{52,60},{52,50.8},{54.4,50.8}},
                                  color={0,0,127}));
  connect(sigBus.TEvaOutMea, t_Ev_ou.u) annotation (Line(
      points={{1,104},{-54,104},{-54,83.2}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(sigBus.TConInMea,t_Co_in. u) annotation (Line(
      points={{1,104},{2,104},{2,104},{52,104},{52,79.2}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(P_eleTable.y, nTimesPel.u2) annotation (Line(points={{-60,20.6},{-60,8},
          {-37.2,8},{-37.2,3.4}},    color={0,0,127}));
  connect(Qdot_EvaTable.y,nTimesQEva. u1) annotation (Line(points={{46,18.6},{
          46,-2.8},{43.6,-2.8}},        color={0,0,127}));

  connect(nTimesPel.y, Pel) annotation (Line(points={{-33,-12.7},{-33,-94},{0,-94},
          {0,-110}},               color={0,0,127}));
  connect(realCorr.y, nTimesSF.u2) annotation (Line(points={{-10,39},{-10,36},{-13.2,
          36},{-13.2,31.4}},   color={0,0,127}));
  connect(sigBus.ySet, nTimesSF.u1) annotation (Line(
      points={{1,104},{-4,104},{-4,31.4},{-4.8,31.4}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(nTimesSF.y, nTimesPel.u1) annotation (Line(points={{-9,15.3},{-9,8},{-28.8,
          8},{-28.8,3.4}},          color={0,0,127}));
  connect(nTimesSF.y, nTimesQEva.u2) annotation (Line(points={{-9,15.3},{-9,
          10},{36.4,10},{36.4,-2.8}}, color={0,0,127}));
  connect(nTimesQEva.y, feedbackHeatFlowEvaporator.u1) annotation (Line(points={
          {40,-16.6},{42,-16.6},{42,-18},{-84,-18},{-84,-10},{-78,-10}}, color={
          0,0,127}));
  connect(nTimesPel.y, calcRedQCon.u2) annotation (Line(points={{-33,-12.7},{-33,
          -48},{64,-48},{64,-58}}, color={0,0,127}));
  connect(constZero.y, feedbackHeatFlowEvaporator.u2) annotation (Line(points={{
          -79,10},{-62,10},{-62,4},{-56,4},{-56,-24},{-70,-24},{-70,-18}},
        color={0,0,127}));
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
    <i>May 22, 2019&#160;</i> by Julian Matthes:<br/>
    First implementation (see issue <a href=
    \"https://github.com/RWTH-EBC/AixLib/issues/715\">#715</a>)
  </li>
</ul>
</html>", info="<html>
<p>
  This model uses the 2-dimensional table data given in the DIN EN
  14511 (formerly EN255) to calculate <i>QEva</i> and <i>P_el</i>. To
  model an inverter controlled chiller, the relative <b>compressor
  speed <i>n</i> is scaled linearly</b> with the ouput of the tables.
  Furthermore, the design of a chiller is modeled via a scaling factor.
  As a result, the equations follow below:
</p>
<p style=\"text-align:center;\">
  <i>QEva,n = n * scalingFactor * TableQEva.y</i>
</p>
<p style=\"text-align:center;\">
  <i>P_el = n * scalingFactor * TablePel.y</i>
</p>
<p style=\"text-align:justify;\">
  To simulate possible icing of the evaporator on air-source chillers,
  the icing factor is used to influence the output as well. As the
  factor resembles the reduction of heat transfer between refrigerant
  and source, the factor is implemented as follows:
</p>
<p style=\"text-align:center;\">
  <i>QEva = iceFac * QEva,n</i>
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
end LookUpTable2D;

within IBPSA.Fluid.HeatPumps.BlackBoxData;
model ConstantQualityGrade "Carnot COP with a constant qualtiy grade"
  extends
    IBPSA.Fluid.HeatPumps.BlackBoxData.BaseClasses.PartialHeatPumpBlackBox(
      QUseBlackBox_flow_nominal=QUse_flow_nominal, datasource="ConstantQualityGradeCarnot");
  parameter Real qualityGrade=0.3 "Constant quality grade";
  final parameter Modelica.Units.SI.Power PEl_nominal = QUse_flow_nominal / (qualityGrade * TCon_nominal * y_nominal)  * (TCon_nominal - TEva_nominal);
  Modelica.Blocks.Sources.Constant constPel(final k=PEl_nominal*
        finalScalingFactor) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={90,90})));
  Modelica.Blocks.Logical.Switch        switchPel
    "If HP is off, no heat will be exchanged" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={50,10})));
  Modelica.Blocks.Logical.Switch        switchQCon
    "If HP is off, no heat will be exchanged" annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={-50,10})));
  Modelica.Blocks.Sources.Constant constZero(final k=0)
                                             annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-10,10})));


  Modelica.Blocks.Math.MultiProduct multiProduct(nu=3) annotation (Placement(
        transformation(
        extent={{-11,-11},{11,11}},
        rotation=270,
        origin={-49,71})));
  Modelica.Blocks.Sources.Constant constEta(final k=qualityGrade) annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={30,70})));
  Modelica.Blocks.Math.Add add(final k1=+1, final k2=-1) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-90,70})));

  Modelica.Blocks.Math.Product product1 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={70,50})));
  Modelica.Blocks.Math.Division division annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-70,40})));
equation

  connect(switchQCon.u3, constZero.y) annotation (Line(points={{-42,22},{-42,28},
          {-10,28},{-10,21}},                         color={0,0,127}));
  connect(switchQCon.y, feedbackHeatFlowEvaporator.u1) annotation (Line(points={{-50,-1},
          {-50,-28},{-72,-28},{-72,-24},{-84,-24},{-84,-10},{-78,-10}},
                                                        color={0,0,127}));
  connect(constZero.y, switchPel.u3) annotation (Line(points={{-10,21},{-10,28},
          {42,28},{42,22}},
                        color={0,0,127}));
  connect(switchPel.y, calcRedQCon.u2) annotation (Line(points={{50,-1},{50,-50},
          {64,-50},{64,-58}},                color={0,0,127}));
  connect(switchPel.y, Pel) annotation (Line(points={{50,-1},{50,-94},{0,-94},{0,
          -110}},    color={0,0,127}));
  connect(switchPel.y, feedbackHeatFlowEvaporator.u2) annotation (Line(points={{50,-1},
          {50,-20},{-54,-20},{-54,-26},{-70,-26},{-70,-18}},    color={0,0,127}));
  connect(switchPel.u2, sigBus.onOffMea) annotation (Line(points={{50,22},{50,56},
          {1,56},{1,104}},                              color={255,0,255}),
      Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(switchQCon.u2, sigBus.onOffMea) annotation (Line(points={{-50,22},{-50,
          30},{1,30},{1,104}},                           color={255,0,255}),
      Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(multiProduct.u[1], sigBus.TConOutMea) annotation (Line(points={{
          -51.5667,82},{-51.5667,104},{1,104}},                color={0,0,127}),
      Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(add.u1, sigBus.TConOutMea) annotation (Line(points={{-84,82},{-84,90},
          {-82,90},{-82,104},{1,104}},
                          color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,6},{6,6}},
      horizontalAlignment=TextAlignment.Left));
  connect(add.u2, sigBus.TEvaInMea) annotation (Line(points={{-96,82},{-96,104},
          {1,104}},      color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(product1.y, switchPel.u1) annotation (Line(points={{70,39},{70,34},{58,
          34},{58,22}}, color={0,0,127}));
  connect(product1.u1, constPel.y) annotation (Line(points={{76,62},{76,74},{90,
          74},{90,79}}, color={0,0,127}));
  connect(product1.u2, sigBus.ySet) annotation (Line(points={{64,62},{66,62},{66,
          104},{1,104}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(constEta.y, multiProduct.u[2]) annotation (Line(points={{30,59},{30,54},
          {-22,54},{-22,92},{-48,92},{-48,82},{-49,82}}, color={0,0,127}));
  connect(product1.y, multiProduct.u[3]) annotation (Line(points={{70,39},{70,
          34},{52,34},{52,92},{-46,92},{-46,82},{-46.4333,82}},
                                                            color={0,0,127}));
  connect(multiProduct.y, division.u1)
    annotation (Line(points={{-49,58.13},{-49,52},{-64,52}}, color={0,0,127}));
  connect(add.y, division.u2)
    annotation (Line(points={{-90,59},{-90,52},{-76,52}}, color={0,0,127}));
  connect(division.y, switchQCon.u1) annotation (Line(points={{-70,29},{-66,29},
          {-66,22},{-58,22}}, color={0,0,127}));
  annotation (Icon(graphics={
        Text(
          lineColor={0,0,255},
          extent={{-136,109},{164,149}},
          textString="%name")}),
                             Documentation(revisions="<html><ul>
  <li>
    <i>November 26, 2018&#160;</i> by Fabian Wüllhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/RWTH-EBC/AixLib/issues/577\">#577</a>)
  </li>
</ul>
</html>", info="<html>
<p>This model uses a constant quality grade approach to model the efficiency of the heat pump.</p>
<p>According to the defined QUse_flow_nominal, the heat pump supplies it&apos;s heat. </p>
<p>The following equations are used:</p>
<p><img src=\"modelica://IBPSA/Resources/Images/equations/equation-kDbLGklc.png\" alt=\"Q_Con = P_elNominal * eta_QualityGrade * y_Set * T_ConOutMea / (T_ConOutMea - T_EvaInMea)\"/></p>
<p><img src=\"modelica://IBPSA/Resources/Images/equations/equation-d0dh1QDk.png\" alt=\"P_elNominal = Q_UseNominal / (eta_QualityGrade * T_ConNominal * y_nominal ) * (T_ConNominal - T_EvaNominal)\"/></p>
</html>"));
end ConstantQualityGrade;

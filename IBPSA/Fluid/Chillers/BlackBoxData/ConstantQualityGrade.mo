within IBPSA.Fluid.Chillers.BlackBoxData;
model ConstantQualityGrade "Carnot EER with a constant qualtiy grade"
  extends IBPSA.Fluid.Chillers.BlackBoxData.BaseClasses.PartialChillerBlackBox(
      QUseBlaBox_flow_nominal=QUse_flow_nominal,
      datSou="ConstantQualityGradeCarnot");
  parameter Real quaGra=0.3 "Constant quality grade";
  final parameter Modelica.Units.SI.Power PEl_nominal=QUse_flow_nominal/(quaGra
      *TEva_nominal*y_nominal)*(TCon_nominal - TEva_nominal);
  Modelica.Blocks.Sources.Constant constPel(final k=PEl_nominal)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={90,90})));
  Modelica.Blocks.Logical.Switch switchPel
    "If chiller is off, no heat will be exchanged"
                                              annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={50,10})));
  Modelica.Blocks.Logical.Switch switchQEva
    "If chiller is off, no heat will be exchanged"
                                              annotation (Placement(
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

  Modelica.Blocks.Math.MultiProduct mulPro(nu=3) "All aside division"
    annotation (Placement(transformation(
        extent={{-11,-11},{11,11}},
        rotation=270,
        origin={-49,71})));
  Modelica.Blocks.Sources.Constant constEta(final k=quaGra) annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={30,70})));
  Modelica.Blocks.Math.Add add(final k1=+1, final k2=-1) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-90,82})));

  Modelica.Blocks.Math.Product product1 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={70,50})));
  Modelica.Blocks.Math.Division div "Calculate heat flow rate by division"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-70,40})));
  Modelica.Blocks.Sources.RealExpression reaTDifMax(y=
        IBPSA.Utilities.Math.Functions.smoothMax(
        x1=15,
        x2=add.y,
        deltaX=0.25)) "Avoid division by zero error"
    annotation (Placement(transformation(extent={{-100,50},{-80,70}})));
equation

  connect(switchQEva.u3, constZero.y) annotation (Line(points={{-42,22},{-42,28},
          {-10,28},{-10,21}},                         color={0,0,127}));
  connect(constZero.y, switchPel.u3) annotation (Line(points={{-10,21},{-10,28},
          {42,28},{42,22}},
                        color={0,0,127}));
  connect(switchPel.y, redQCon.u2) annotation (Line(points={{50,-1},{50,-50},{
          64,-50},{64,-58}}, color={0,0,127}));
  connect(switchPel.y, PEle) annotation (Line(points={{50,-1},{50,-94},{0,-94},
          {0,-110}}, color={0,0,127}));
  connect(switchPel.u2, sigBus.onOffMea) annotation (Line(points={{50,22},{50,56},
          {1,56},{1,104}},                              color={255,0,255}),
      Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(switchQEva.u2, sigBus.onOffMea) annotation (Line(points={{-50,22},{-50,
          30},{1,30},{1,104}},                           color={255,0,255}),
      Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(add.u1, sigBus.TConOutMea) annotation (Line(points={{-84,94},{-84,90},
          {-82,90},{-82,104},{1,104}},
                          color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,6},{6,6}},
      horizontalAlignment=TextAlignment.Left));
  connect(add.u2, sigBus.TEvaInMea) annotation (Line(points={{-96,94},{-96,104},
          {1,104}},      color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(product1.y, switchPel.u1) annotation (Line(points={{70,39},{70,34},{58,
          34},{58,22}}, color={0,0,127}));
  connect(product1.u1, constPel.y) annotation (Line(points={{76,62},{76,74},{90,
          74},{90,79}}, color={0,0,127}));
  connect(product1.u2, sigBus.ySet) annotation (Line(points={{64,62},{64,104},{1,
          104}},         color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(constEta.y, mulPro.u[1]) annotation (Line(points={{30,59},{30,54},{
          -22,54},{-22,92},{-48,92},{-48,82},{-51.5667,82}}, color={0,0,127}));
  connect(product1.y, mulPro.u[2]) annotation (Line(points={{70,39},{70,34},{52,
          34},{52,92},{-46,92},{-46,82},{-49,82}}, color={0,0,127}));
  connect(mulPro.y, div.u1)
    annotation (Line(points={{-49,58.13},{-49,52},{-64,52}}, color={0,0,127}));
  connect(div.y, switchQEva.u1) annotation (Line(points={{-70,29},{-66,29},{-66,
          22},{-58,22}}, color={0,0,127}));
  connect(mulPro.u[3], sigBus.TEvaOutMea) annotation (Line(points={{-46.4333,82},
          {-46.4333,104},{1,104}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(switchQEva.y, proRedQEva.u2) annotation (Line(points={{-50,-1},{-50,-38},
          {-44,-38},{-44,-58}}, color={0,0,127}));
  connect(div.u2, reaTDifMax.y)
    annotation (Line(points={{-76,52},{-76,60},{-79,60}}, color={0,0,127}));
  annotation (Documentation(revisions="<html><ul>
  <li>
    <i>October 2, 2022</i> by Fabian Wuellhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/ibpsa/modelica-ibpsa/issues/1576\">#1576</a>)
  </li>
</ul>
</html>", info="<html>
<p>This model uses a constant quality grade approach to model the efficiency of the chiller.</p>
<p>According to the defined <span style=\"font-family: Courier New;\">QUse_flow_nominal</span>, the chiller supplies its cold. </p>
<p>The following equations are used:</p>
<p><br><br><img src=\"modelica://IBPSA/Resources/Images/equations/equation-kDbLGklc.png\" alt=\"Q_Con = P_elNominal * eta_QualityGrade * y_Set * T_ConOutMea / (T_ConOutMea - T_EvaInMea)\"/></p>
<p><img src=\"modelica://IBPSA/Resources/Images/equations/equation-d0dh1QDk.png\" alt=\"P_elNominal = Q_UseNominal / (eta_QualityGrade * T_ConNominal * y_nominal ) * (T_ConNominal - T_EvaNominal)\"/></p>
</html>"), Icon(graphics={Text(
          extent={{-78,68},{74,-78}},
          textColor={0,0,127},
          textString="Carnot")}));
end ConstantQualityGrade;

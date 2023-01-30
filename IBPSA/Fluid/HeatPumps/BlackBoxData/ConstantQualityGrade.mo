within IBPSA.Fluid.HeatPumps.BlackBoxData;
model ConstantQualityGrade "Carnot COP with a constant qualtiy grade"
  extends
    IBPSA.Fluid.HeatPumps.BlackBoxData.BaseClasses.PartialHeatPumpBlackBox(
      QUseBlaBox_flow_nominal=QUse_flow_nominal,
      datSou="ConstantQualityGradeCarnot");
  extends IBPSA.Fluid.HeatPumps.BlackBoxData.BaseClasses.PartialCarnot(constPel(
        final k=QUse_flow_nominal/(quaGra*TCon_nominal*y_nominal)*(TCon_nominal
           - TEva_nominal)));

  Modelica.Blocks.Logical.Switch switchPel
    "If HP is off, no heat will be exchanged" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={50,10})));
  Modelica.Blocks.Logical.Switch switchQCon
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

equation

  connect(switchQCon.u3, constZero.y) annotation (Line(points={{-42,22},{-42,28},
          {-10,28},{-10,21}},                         color={0,0,127}));
  connect(switchQCon.y, feeHeaFloEva.u1) annotation (Line(points={{-50,-1},{-50,
          -28},{-72,-28},{-72,-24},{-84,-24},{-84,-10},{-78,-10}}, color={0,0,
          127}));
  connect(constZero.y, switchPel.u3) annotation (Line(points={{-10,21},{-10,28},
          {42,28},{42,22}},
                        color={0,0,127}));
  connect(switchPel.y, redQCon.u2) annotation (Line(points={{50,-1},{50,-50},{
          64,-50},{64,-58}}, color={0,0,127}));
  connect(switchPel.y, PEle) annotation (Line(points={{50,-1},{50,-94},{0,-94},
          {0,-110}}, color={0,0,127}));
  connect(switchPel.y, feeHeaFloEva.u2) annotation (Line(points={{50,-1},{50,-20},
          {-54,-20},{-54,-26},{-70,-26},{-70,-18}}, color={0,0,127}));
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
  connect(pasThrYSet.u, sigBus.ySet) annotation (Line(points={{18,70},{1,70},{1,
          104}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(pasThrTUse.u, sigBus.TConOutMea) annotation (Line(points={{-70,92},{
          -70,104},{1,104}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(pasThrTNotUse.u, sigBus.TEvaInMea) annotation (Line(points={{-30,92},
          {-30,104},{0,104},{0,86},{1,86},{1,104}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(proQUse_flow.y, switchQCon.u1) annotation (Line(points={{-50,39},{-50,
          32},{-58,32},{-58,22}}, color={0,0,127}));
  connect(proPEle.y, switchPel.u1) annotation (Line(points={{70,39},{70,34},{58,
          34},{58,22}}, color={0,0,127}));
  annotation (Documentation(revisions="<html><ul>
  <li>
    <i>October 2, 2022</i> by Fabian Wuellhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/ibpsa/modelica-ibpsa/issues/1576\">#1576</a>)
  </li>
</ul>
</html>", info="<html>
<p>This model uses a constant quality grade approach to model the efficiency of the heat pump.</p>
<p>According to the defined <code>QUse_flow_nominal</code>, the heat pump supplies its heat. </p>
<p>The following equations are used:</p>
<p><br><br><img src=\"modelica://IBPSA/Resources/Images/equations/equation-kDbLGklc.png\" alt=\"Q_Con = P_elNominal * eta_QualityGrade * y_Set * T_ConOutMea / (T_ConOutMea - T_EvaInMea)\"/></p>
<p><img src=\"modelica://IBPSA/Resources/Images/equations/equation-d0dh1QDk.png\" alt=\"P_elNominal = Q_UseNominal / (eta_QualityGrade * T_ConNominal * y_nominal ) * (T_ConNominal - T_EvaNominal)\"/></p>
</html>"), Icon(graphics={Text(
          extent={{-78,80},{74,-66}},
          textColor={0,0,127},
          textString="Carnot")}));
end ConstantQualityGrade;

within IBPSA.Fluid.HeatPumps.BlackBoxData;
model ConstantQualityGrade "Carnot COP with a constant qualtiy grade"
  extends
    IBPSA.Fluid.HeatPumps.BlackBoxData.BaseClasses.PartialHeatPumpBlackBox(
      QUseBlaBox_flow_nominal=QUse_flow_nominal,
      datSou="ConstantQualityGradeCarnot");
  extends IBPSA.Fluid.HeatPumps.BlackBoxData.BaseClasses.PartialCarnot(constPel(
        final k=QUse_flow_nominal/(quaGra*(TCon_nominal+TAppCon_nominal)*y_nominal)*(
        TCon_nominal + TAppCon_nominal - TEva_nominal - TAppEva_nominal)),
    dTAppUse(k=TAppCon_nominal),
    dTAppNotUse(k=-TAppEva_nominal));

equation

  connect(pasThrYSet.u, sigBus.ySet) annotation (Line(points={{18,70},{1,70},{1,
          104}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(addTVapCycUse.u1, sigBus.TConOutMea) annotation (Line(points={{-64,82},
          {-64,104},{1,104}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(addTVapCycNotUse.u1, sigBus.TEvaInMea) annotation (Line(points={{-24,82},
          {-24,104},{1,104}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(switchPel.y, redQCon.u2) annotation (Line(points={{50,-1},{50,-26},{62,
          -26},{62,-58},{64,-58}}, color={0,0,127}));
  connect(switchPel.y, PEle) annotation (Line(points={{50,-1},{50,-92},{0,-92},{
          0,-110}}, color={0,0,127}));
  connect(switchPel.y, feeHeaFloEva.u2) annotation (Line(points={{50,-1},{50,-24},
          {-70,-24},{-70,-18}}, color={0,0,127}));
  connect(switchQUse.y, feeHeaFloEva.u1) annotation (Line(points={{-50,-1},{-88,
          -1},{-88,-10},{-78,-10}}, color={0,0,127}));
  connect(switchQUse.u2, sigBus.onOffMea) annotation (Line(points={{-50,22},{-50,
          32},{1,32},{1,104}}, color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(switchPel.u2, sigBus.onOffMea) annotation (Line(points={{50,22},{50,56},
          {1,56},{1,104}}, color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
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

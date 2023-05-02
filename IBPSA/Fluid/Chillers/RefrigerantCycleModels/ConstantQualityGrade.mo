within IBPSA.Fluid.Chillers.RefrigerantCycleModels;
model ConstantQualityGrade "Carnot EER with a constant qualtiy grade"
  extends
    IBPSA.Fluid.Chillers.RefrigerantCycleModels.BaseClasses.PartialChillerRefrigerantCycle(
      QUseNoSca_flow_nominal=QUse_flow_nominal, datSou=
        "ConstantQualityGradeCarnot");
  extends
    IBPSA.Fluid.HeatPumps.RefrigerantCycleModels.BaseClasses.PartialCarnot(
                                                                       constPel(
        final k=QUse_flow_nominal/(quaGra*(TEva_nominal - TAppEva_nominal)*y_nominal)*
        (TCon_nominal + TAppCon_nominal - TEva_nominal - TAppEva_nominal)),
    dTAppUse(k=-TAppEva_nominal),
    dTAppNotUse(k=TAppCon_nominal));

equation
  connect(switchQUse.u2, sigBus.onOffMea) annotation (Line(points={{-50,22},{-26,
          22},{-26,34},{1,34},{1,104}}, color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(switchPel.y, redQCon.u2) annotation (Line(points={{50,-1},{50,-36},{64,
          -36},{64,-58}}, color={0,0,127}));
  connect(switchPel.y, PEle) annotation (Line(points={{50,-1},{50,-8},{0,-8},{0,
          -110}}, color={0,0,127}));
  connect(switchPel.u2, sigBus.onOffMea) annotation (Line(points={{50,22},{50,48},
          {1,48},{1,104}}, color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(pasThrYSet.u, sigBus.ySet) annotation (Line(points={{18,70},{1,70},{1,
          104}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(addTVapCycNotUse.u1, sigBus.TConOutMea) annotation (Line(points={{-24,
          82},{-24,104},{1,104}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(addTVapCycUse.u1, sigBus.TEvaOutMea) annotation (Line(points={{-64,82},
          {-64,104},{1,104}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(switchQUse.y, proRedQEva.u2) annotation (Line(points={{-50,-1},{-50,
          -30},{-44,-30},{-44,-58}}, color={0,0,127}));
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
</html>"), Icon(graphics={Text(
          extent={{-78,68},{74,-78}},
          textColor={0,0,127},
          textString="Carnot")}));
end ConstantQualityGrade;

within IBPSA.Fluid.HeatPumps.RefrigerantCycleModels;
model ConstantQualityGrade "Carnot COP with a constant qualtiy grade"
  extends
    IBPSA.Fluid.HeatPumps.RefrigerantCycleModels.BaseClasses.PartialHeatPumpCycle(
      final PEle_nominal=QUse_flow_nominal/(quaGra*(TCon_nominal + TAppCon_nominal)
          *y_nominal)*(TCon_nominal + TAppCon_nominal - TEva_nominal -
          TAppEva_nominal),
      QUseNoSca_flow_nominal=QUse_flow_nominal,
      datSou="ConstantQualityGradeCarnot");
  extends
    IBPSA.Fluid.HeatPumps.RefrigerantCycleModels.BaseClasses.PartialCarnot(
    constPEle(final k=PEle_nominal),
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
  connect(swiPEle.y, redQCon.u2) annotation (Line(points={{50,-1},{50,-26},{62,
          -26},{62,-58},{64,-58}}, color={0,0,127}));
  connect(swiPEle.y, PEle) annotation (Line(points={{50,-1},{50,-92},{0,-92},{0,
          -110}}, color={0,0,127}));
  connect(swiPEle.y, feeHeaFloEva.u2) annotation (Line(points={{50,-1},{50,-24},
          {-70,-24},{-70,-18}}, color={0,0,127}));
  connect(swiQUse.y, feeHeaFloEva.u1) annotation (Line(points={{-50,-1},{-88,-1},
          {-88,-10},{-78,-10}}, color={0,0,127}));
  connect(swiQUse.u2, sigBus.onOffMea) annotation (Line(points={{-50,22},{-50,
          32},{1,32},{1,104}}, color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(swiPEle.u2, sigBus.onOffMea) annotation (Line(points={{50,22},{50,56},
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
<p>
  This model uses a constant quality grade approach and carnot equations 
  to model the efficiency of the heat pump.
</p>
<p>
  According to the defined <code>QUse_flow_nominal</code> and 
  the nominal conditions <code>PEle_nominal</code> is calculated.
  <code>PEle_nominal</code> stays constant over all boundary conditions,
  aside from different compressor speeds.
  <code>QCon_flow</code> changes according to the carnot COP, which follows:
</p>
<p>
  <code>
    QCon_flow = PEle_nominal * quaGra * ySet * 
    (TCon_nominal + TAppCon_nominal) / 
    (TCon_nominal + TAppCon_nominal - TEva_nominal - TAppEva_nominal)
  </code>
</p>    
<p>
  <code>
    PEle = PEle_nominal * ySet 
  </code>
</p>    
<p>
  This equations follows the Carnot approach of the IBPSA library:
  <a href=\"modelica://IBPSA.Fluid.HeatPumps.Carnot_y\">
  IBPSA.Fluid.HeatPumps.Carnot_y</a>
  Similar, the paramateres <code>TAppCon_nominal</code> and
  <code>TAppEva_nominal</code> define pinch temperature differences.
</p>
</html>"), Icon(graphics={Text(
          extent={{-78,80},{74,-66}},
          textColor={0,0,127},
          textString="Carnot")}));
end ConstantQualityGrade;

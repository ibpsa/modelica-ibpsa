within IBPSA.Fluid.Chillers.ModularReversible.RefrigerantCycle;
model ConstantQualityGrade "Carnot EER with a constant qualtiy grade"
  extends
    IBPSA.Fluid.Chillers.ModularReversible.RefrigerantCycle.BaseClasses.PartialChillerCycle(
      useInChi=true,
      PEle_nominal=QUse_flow_nominal/EER_nominal,
      QUseNoSca_flow_nominal=QUse_flow_nominal,
      datSou="ConstantQualityGradeCarnot");
  extends
    IBPSA.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.PartialCarnot(
     final useForChi=true,
     final QEva_flow_nominal=QUse_flow_nominal,
     final QCon_flow_nominal=QUse_flow_nominal+PEle_nominal,
     constPEle(final k=PEle_nominal));
  parameter Real EER_nominal = quaGra*y_nominal *
    (TEva_nominal - TAppEva_nominal) /
    (TCon_nominal + TAppCon_nominal - (TEva_nominal - TAppEva_nominal))
    "Nominal EER";

equation
  connect(swiQUse.u2, sigBus.onOffMea) annotation (Line(points={{-50,22},{-26,
          22},{-26,34},{1,34},{1,104}}, color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(swiPEle.y, redQCon.u2) annotation (Line(points={{50,-1},{50,-36},{64,
          -36},{64,-58}}, color={0,0,127}));
  connect(swiPEle.y, PEle) annotation (Line(points={{50,-1},{50,-8},{0,-8},{0,-110}},
        color={0,0,127}));
  connect(swiPEle.u2, sigBus.onOffMea) annotation (Line(points={{50,22},{50,48},
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
  if useInChi then
    connect(pasThrTCon.u, sigBus.TConOutMea) annotation (Line(points={{-30,90},{-30,
            104},{1,104}}, color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{-3,6},{-3,6}},
        horizontalAlignment=TextAlignment.Right));
    connect(pasThrTEva.u, sigBus.TEvaOutMea) annotation (Line(points={{-70,90},{-70,
            104},{1,104}}, color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{-3,6},{-3,6}},
        horizontalAlignment=TextAlignment.Right));
  else
    connect(pasThrTCon.u, sigBus.TEvaOutMea) annotation (Line(points={{-30,90},{-30,
            104},{1,104}}, color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{-3,6},{-3,6}},
        horizontalAlignment=TextAlignment.Right));
    connect(pasThrTEva.u, sigBus.TConOutMea) annotation (Line(points={{-70,90},{-70,
            104},{1,104}}, color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{-3,6},{-3,6}},
        horizontalAlignment=TextAlignment.Right));
  end if;
  connect(swiQUse.y, proRedQEva.u2) annotation (Line(points={{-50,-1},{-50,-30},{
          -14,-30},{-14,-58}},  color={0,0,127}));
  connect(calEER.PEle, swiPEle.y) annotation (Line(points={{-78,-66},{-50,-66},{
          -50,-52},{0,-52},{0,-8},{50,-8},{50,-1}}, color={0,0,127}));
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
  to compute the efficiency of the chiller.
</p>
<p>
  <code>PEle_nominal</code> is computed from the provided
  <code>QUse_flow_nominal</code> and other nominal conditions.
  <code>PEle_nominal</code> stays constant over all boundary conditions
  and is used to calculate <code>PEle</code> by multiplying it with the
  relative compressor speed.
  <code>QEva_flow</code> is computed using the carnot approach:
</p>
<p>
  <code>
    QEva_flow = PEle_nominal * quaGra * ySet *
    (TEvaOut - TAppEva) /
    (TConOut + TAppCon - (TEvaOut - TAppEva))
  </code>
</p>
<p>
  <code>
    PEle = PEle_nominal * ySet
  </code>
</p>
<p>
  These equations follow the same methods used in
  <a href=\"modelica://IBPSA.Fluid.Chillers.Carnot_y\">
  IBPSA.Fluid.Chillers.Carnot_y</a>
  Similarly, the variables <code>TAppCon</code> and
  <code>TAppEva</code> define the approach (pinch) temperature differences.
</p>
<p>
  The approach temperatures
  are calculated using the following equation:
</p>
<p>
  <code>
  TApp = TApp_nominal * Q_flow / Q_flow_nominal
  </code>
</p>
<p>
  This introduces nonlinear equations to the model, which
  can lead to solver issues for reversible operation.
  You can use the nominal values as a constant by
  enabling <code>use_constAppTem</code>
</p>
</html>"), Icon(graphics={Text(
          extent={{-78,68},{74,-78}},
          textColor={0,0,127},
          textString="Carnot")}));
end ConstantQualityGrade;

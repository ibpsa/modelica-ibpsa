within IBPSA.Fluid.Chillers.ModularReversible.RefrigerantCycle.BaseClasses;
partial model PartialChillerCycle
  "Partial model of refrigerant cycle used for chiller applications"
  extends
    IBPSA.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.PartialRefrigerantCycle;
  parameter Boolean useInChi
    "=false to indicate that this model is used as a heat pump";
  IBPSA.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.CalculateCOP
    calEER(PEleMin=PEle_nominal*0.1)  if calEff
                                      "Calculate the EER"
    annotation (Placement(transformation(extent={{-60,-60},{-80,-80}})));
equation
  connect(iceFacCal.iceFac, sigBus.iceFacChiMea) annotation (Line(points={{-69,-40},
          {-72,-40},{-72,-26},{-102,-26},{-102,104},{1,104}},      color={0,0,
          127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(calEER.COP, sigBus.EER) annotation (Line(points={{-81,-70},{-102,-70},{
          -102,104},{1,104}},  color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(calEER.QUse_flow, proRedQEva.y) annotation (Line(points={{-58,-74},{-46,
          -74},{-46,-88},{-20,-88},{-20,-81}}, color={0,0,127}));
  annotation (Icon(graphics={Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,255},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid)}),
      Documentation(
  info="<html>
<p>
  Partial refrigerant cycle model for chillers.
  It adds the specification for frosting calculation
  and restricts to the intended choices under
  <code>choicesAllMatching</code>.</p>
</html>", revisions="<html>
<ul>
  <li>
    <i>October 2, 2022</i> by Fabian Wuellhorst:<br/>
    Adapted based on IBPSA implementation (see issue <a href=
    \"https://github.com/ibpsa/modelica-ibpsa/issues/1576\">#1576</a>)
  </li>
  <li>
    <i>October 2, 2022</i> by Fabian Wuellhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/ibpsa/modelica-ibpsa/issues/1576\">#1576</a>)
  </li>
</ul>
</html>"));
end PartialChillerCycle;

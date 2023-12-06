within IBPSA.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses;
partial model PartialHeatPumpCycle
  "Partial model to allow selection of only heat pump options"
  extends PartialRefrigerantCycle;
  parameter Boolean useInHeaPum
    "=false to indicate that this model is used in a chiller";
  Modelica.Blocks.Math.Feedback feeHeaFloEva
    "Calculates evaporator heat flow with total energy balance" annotation (
      Placement(transformation(extent={{-80,-20},{-60,0}}, rotation=0)));
  IBPSA.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.CalculateCOP calCOP(
    PEleMin=PEle_nominal*0.1)  if calEff
    "Calculate the COP"
    annotation (Placement(transformation(extent={{-60,-60},{-80,-80}})));
equation
  connect(iceFacCal.iceFac, sigBus.icefacHPMea) annotation (Line(points={{-69,-40},
          {-56,-40},{-56,-26},{-102,-26},{-102,104},{1,104}}, color={0,0,127}),
      Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(feeHeaFloEva.y, proRedQEva.u2)
    annotation (Line(points={{-61,-10},{-14,-10},{-14,-58}}, color={0,0,127}));
  connect(calCOP.QUse_flow, redQCon.y) annotation (Line(points={{-58,-74},{-50,
          -74},{-50,-96},{70,-96},{70,-81}}, color={0,0,127}));
  connect(calCOP.COP, sigBus.COP) annotation (Line(points={{-81,-70},{-102,-70},{
          -102,104},{1,104}},  color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  annotation (Documentation(info="<html>
<p>
  Partial refrigerant cycle model for heat pumps.
  It adds the specification for frosting calculation
  and restricts to the intended choices under
  <code>choicesAllMatching</code>.
</p>
</html>",
revisions="<html>
<ul>
  <li>
    <i>October 2, 2022</i> by Fabian Wuellhorst:<br/>
    Adapted based on IBPSA implementation. Mainly, the iceFac is added directly
    in this partial model (see issue <a href=
    \"https://github.com/ibpsa/modelica-ibpsa/issues/1576\">#1576</a>)
  </li>
  <li>
    <i>October 2, 2022</i> by Fabian Wuellhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/ibpsa/modelica-ibpsa/issues/1576\">#1576</a>)
  </li>
</ul>
</html>"));
end PartialHeatPumpCycle;

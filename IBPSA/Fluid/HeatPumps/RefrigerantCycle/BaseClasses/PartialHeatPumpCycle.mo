within IBPSA.Fluid.HeatPumps.RefrigerantCycle.BaseClasses;
partial model PartialHeatPumpCycle
  "Partial model to allow selection of only heat pump options"
  extends PartialRefrigerantCycle;
  Modelica.Blocks.Math.Feedback feeHeaFloEva
    "Calculates evaporator heat flow with total energy balance" annotation (
      Placement(transformation(extent={{-80,-20},{-60,0}}, rotation=0)));
equation
  connect(iceFacCal.iceFac, sigBus.icefacHPMea) annotation (Line(points={{-79,-42},
          {-72,-42},{-72,-28},{-102,-28},{-102,104},{1,104}}, color={0,0,127}),
      Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(feeHeaFloEva.y, proRedQEva.u2)
    annotation (Line(points={{-61,-10},{-44,-10},{-44,-58}}, color={0,0,127}));
  annotation (Documentation(info="<html>
<p>
  Partial refrigerant cycle model for heat pumps. 
  Specifies <code>iceFacHPMea</code> in addition to basic 
  equations to calculate the frosting performance of the heat pump operation.
</p>
<p>
  This model further enables the correct selection of approaches 
  for heat pumps when using <code>choicesAllMatching</code>.
<\p>
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

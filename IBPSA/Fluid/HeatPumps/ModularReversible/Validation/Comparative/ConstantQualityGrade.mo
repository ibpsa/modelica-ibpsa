within IBPSA.Fluid.HeatPumps.ModularReversible.Validation.Comparative;
model ConstantQualityGrade
  "Validation case for modular carnot approach"
  extends BaseClasses.PartialModularComparison(heaPum(redeclare model
        RefrigerantCycleHeatPumpHeating =
          IBPSA.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.ConstantQualityGrade
          (
          useAirForCon=false,
          useAirForEva=false,
          quaGra=etaCarnot_nominal)));
  extends Modelica.Icons.Example;

  annotation (experiment(Tolerance=1e-6, StopTime=3600),
__Dymola_Commands(file="modelica://IBPSA/Resources/Scripts/Dymola/Fluid/HeatPumps/ModularReversible/Validation/Comparative/ConstantQualityGrade.mos"
        "Simulate and plot"),
    Documentation(revisions="<html>
<ul>
<li>
November 13, 2023 by Fabian Wuellhorst:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
Validation case for <a href=\"modelica://IBPSA.Fluid.Chillers.ModularReversible.RefrigerantCycle.ConstantQualityGrade\">
IBPSA.Fluid.Chillers.ModularReversible.RefrigerantCycle.ConstantQualityGrade</a>.
</p>
</html>"));
end ConstantQualityGrade;

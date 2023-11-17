within IBPSA.Fluid.Chillers.ModularReversible.Validation;
model ConstantQualityGrade
  "Validation case for modular carnot approach"
  extends BaseClasses.PartialModularComparison(chi(redeclare model
        RefrigerantCycleChillerCooling =
          IBPSA.Fluid.Chillers.ModularReversible.RefrigerantCycle.ConstantQualityGrade
          (
          cpCon=chi.cpCon,
          cpEva=chi.cpEva,
          quaGra=etaCarnot_nominal)));
  extends Modelica.Icons.Example;

  annotation (experiment(Tolerance=1e-6, StopTime=3600),
__Dymola_Commands(file="modelica://IBPSA/Resources/Scripts/Dymola/Fluid/Chillers/ModularReversible/Validation/ConstantQualityGrade.mos"
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

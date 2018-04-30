within IBPSA.Fluid.MassExchangers.Validation;
model ConstantEffectivenessZeroFlow
  "Zero flow test for constants effectiveness mass exchanger"
  extends IBPSA.Fluid.MassExchangers.Examples.ConstantEffectiveness(
    PSin_1(height=0, offset=1E5));
  annotation (Documentation(revisions="<html>
<ul>
<li>
April 30, 2018, by Filip Jorissen:<br/>
First implementation.
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/907\">#907</a>.
</li>
</ul>
</html>", info="<html>
<p>
This model tests whether 
<a href=\"modelica://IBPSA.Fluid.MassExchangers.ConstantEffectiveness\">ConstantEffectiveness</a>
works correctly at zero flow.
</p>
</html>"), experiment(Tolerance=1e-06),
    __Dymola_Commands(file=
          "Resources/Scripts/Dymola/Fluid/MassExchangers/Validation/ConstantEffectivenessZeroFlow.mos"
        "Simulate and plot"));
end ConstantEffectivenessZeroFlow;

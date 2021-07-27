within IBPSA.Fluid.FixedResistances.Examples;
model PlugFlowPipeNoMix
  "Simple example of plug flow pipe without mixing volume"
  extends IBPSA.Fluid.FixedResistances.Examples.PlugFlowPipe(
    pip(have_pipCap=false));
  annotation (
    __Dymola_Commands(file=
          "Resources/Scripts/Dymola/Fluid/FixedResistances/Examples/PlugFlowPipeNoMix.mos"
        "Simulate and Plot"),
    experiment(StopTime=1000, Tolerance=1e-006),
    Documentation(info="<html>
<p>Basic test of model
<a href=\"modelica://IBPSA.Fluid.FixedResistances.PlugFlowPipe\">
IBPSA.Fluid.FixedResistances.PlugFlowPipe</a> when the pipe wall thermal
capacity is not modeled with a mixing volume at the outlet port.
This test includes an inlet temperature step under a constant mass flow rate.
</p>
</html>", revisions="<html>
<ul>
<li>
July 12, 2021 by Baptiste Ravache:<br/>
First implementation.
</li>
</ul>
</html>"));
end PlugFlowPipeNoMix;

within IBPSA.Fluid.Examples.Performance.PressureDrop;
model ParallelSeriesFromDpFalse
  "Parallel-series configurations with from_dp=false for right pressure drop component"
  extends ParallelSeriesFromDpTrue(
    res4(from_dp=false),
    res5(from_dp=false),
    res6(from_dp=false),
    res7(from_dp=false));
  annotation (
    Documentation(info="<html>
<p>
Parallel-series configurations of 
<a href=\"modelica://IBPSA.Fluid.FixedResistances.PressureDrop\">
IBPSA.Fluid.FixedResistances.PressureDrop</a> 
components with 
<code>from_dp = true</code> or 
<code>from_dp = false</code> and prescribed 
mass flow rate or prescribed pressure difference.
The left 
<a href=\"modelica://IBPSA.Fluid.FixedResistances.PressureDrop\">
IBPSA.Fluid.FixedResistances.PressureDrop</a> 
is a vector of components that are in parallel
to each other and in series with the right
<a href=\"modelica://IBPSA.Fluid.FixedResistances.PressureDrop\">
IBPSA.Fluid.FixedResistances.PressureDrop</a>. 
The right
<a href=\"modelica://IBPSA.Fluid.FixedResistances.PressureDrop\">
IBPSA.Fluid.FixedResistances.PressureDrop</a> 
have <code>from_dp=false</code>.
See 
<a href=\"IBPSA.Fluid.Examples.Performance.PressureDrop.ParallelSeriesFromDpTrue\">
IBPSA.Fluid.Examples.Performance.PressureDrop.ParallelSeriesFromDpTrue</a>
for <code>from_dp=true</code>.
</p>
<p>
See translation statistics for how these configurations
affect the number and size of algebraic loops.
</p>
</html>", revisions="<html>
<ul>
<li>
May 16, 2017, by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>"),
    __Dymola_Commands(file="Resources/Scripts/Dymola/Fluid/Examples/Performance/PressureDrop/ParallelSeriesFromDpFalse.mos"
        "Simulate and plot"),
    experiment(StartTime=-1, StopTime=1, Tolerance=1e-06));
end ParallelSeriesFromDpFalse;

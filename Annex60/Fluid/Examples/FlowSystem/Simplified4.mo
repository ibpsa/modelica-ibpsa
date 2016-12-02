within Annex60.Fluid.Examples.FlowSystem;
model Simplified4 "Removed valve dynamics"
  extends Simplified3(
    valNorth(filteredOpening=false),
    valSouth(
            filteredOpening=false),
    pmpNorth(
      energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
      massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
      filteredSpeed=false),
    pmpSouth(
      energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
      massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
      filteredSpeed=false),
    valSouth1(filteredOpening=false),
    valSouth2(filteredOpening=false),
    valNorth1(filteredOpening=false),
    valNorth2(filteredOpening=false),
    pumpHea(filteredSpeed=false),
    pumpCoo(filteredSpeed=false),
    valCoo(filteredOpening=false),
    valHea(filteredOpening=false));
  annotation (Documentation(info="<html>
<p>
The model is further simplified: valve and pump control dynamics were removed.
</p>
</html>", revisions="<html>
<ul>
<li>
October 7, 2016, by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>"), __Dymola_Commands(file=
          "Resources/Scripts/Dymola/Fluid/Examples/FlowSystem/Simplified4.mos"
        "Simulate and plot"));
end Simplified4;

within IDEAS.Fluid.Production.Examples;
model HeatPump_Events
  "General example and tester for a modulating water-to-water heat pump"
  extends IDEAS.Fluid.Production.Examples.HeatPump_WaterWater(
    sine(offset=273.15 + 45),
    sine2(offset=273.15 + 45),
    heatPump1(avoidEvents=true));

  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}), graphics),
    experiment(StopTime=30000),
    __Dymola_experimentSetupOutput,
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}})),
    Commands(file=
          "modelica://Annex60/Resources/Scripts/Dymola/Fluid/Production/Examples/HeatPump_Events.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>This example demonstrates the use of a heat pump.</p>
</html>", revisions="<html>
<ul>
<li>March 2014 by Filip Jorissen:<br/> 
Initial version
</li>
</ul>
</html>"));
end HeatPump_Events;

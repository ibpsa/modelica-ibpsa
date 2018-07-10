within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Boreholes.Examples;
model BoreholeOneUTube "Test for the single U-tube borehole model"
  extends IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Boreholes.Examples.BaseClasses.partialBorehole(
      redeclare
      IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Boreholes.BoreholeOneUTube
      borHol);

  annotation (
    __Dymola_Commands( file=
          "Resources/Scripts/Dymola/Fluid/HeatExchangers/GroundHeatExchangers/Boreholes/Examples/BoreholeOneUTube.mos"
        "Simulate and plot"),
    Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{100,
            100}})),
    Documentation(info="<html>
This example illustrates modeling a segment of a single U-tube borehole heat exchanger.
It simulates the behavior of the borehole on a single horizontal section with a prescribed
borehole wall boundary condition.
</html>", revisions="<html>
<ul>
<li>
July 10, 2018, by Alex Laferri&egrave;re:<br>
Adjusted the example following major changes to the GroundHeatExchangers package.
Additionally, implemented a partial example model.
</li>
<li>
August 30, 2011, by Pierre Vigouroux:<br>
First implementation.
</li>
</ul>
</html>"),
    experiment(StopTime=360000));
end BoreholeOneUTube;

within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Boreholes.Examples;
model BoreholeTwoUTube "Test for the double U-tube borehole model"
  extends IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Boreholes.Examples.BaseClasses.partialBorehole(
      redeclare
      IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Boreholes.BoreholeTwoUTube
      borHol,
    borFieDat(conDat=
          IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.ConfigurationData.SandBox_validation(
          borCon=IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Types.BoreholeConfiguration.DoubleUTubeParallel)));

  annotation (__Dymola_Commands(file=
          "Resources/Scripts/Dymola/Fluid/HeatExchangers/GroundHeatExchangers/Boreholes/Examples/BoreholeTwoUTube.mos"
        "Simulate and Plot"),
        Documentation(info="<html>
This example illustrates modeling a segment of a double U-tube borehole heat exchanger.
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
</html>"));
end BoreholeTwoUTube;

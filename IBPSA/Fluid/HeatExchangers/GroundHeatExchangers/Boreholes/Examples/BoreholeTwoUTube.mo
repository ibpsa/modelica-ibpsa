within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Boreholes.Examples;
model BoreholeTwoUTube "Test for the double U-tube borehole model"
  extends
    IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Boreholes.Examples.BaseClasses.PartialBorehole(
      redeclare
      IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Boreholes.BoreholeTwoUTube
      borHol(energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial),
    borFieDat(conDat=
          IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.ConfigurationData.Example(
          borCon=IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Types.BoreholeConfiguration.DoubleUTubeParallel)));
  extends Modelica.Icons.Example;

  annotation (experiment(Tolerance=1e-6, StopTime=360000),
        __Dymola_Commands(file=
          "Resources/Scripts/Dymola/Fluid/HeatExchangers/GroundHeatExchangers/Boreholes/Examples/BoreholeTwoUTube.mos"
        "Simulate and Plot"),
        Documentation(info="<html>
<p>
This example illustrates the use of the 
<a href=\"modelica://IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Boreholes.BoreholeTwoUTube\">
IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Boreholes.BoreholeTwoUTube</a>
model. It simulates the behavior of a borehole with a prescribed
borehole wall boundary condition.
</p>
</html>", revisions="<html>
<ul>
<li>
July 10, 2018, by Alex Laferri&egrave;re:<br/>
Adjusted the example following major changes to the GroundHeatExchangers package.
Additionally, implemented a partial example model.
</li>
<li>
August 30, 2011, by Pierre Vigouroux:<br/>
First implementation.
</li>
</ul>
</html>"));
end BoreholeTwoUTube;

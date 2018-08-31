within IBPSA.Fluid.HeatExchangers.Ground.Boreholes.Examples;
model BoreholeTwoUTube "Test for the double U-tube borehole model"
  extends Modelica.Icons.Example;
  extends IBPSA.Fluid.HeatExchangers.Ground.Boreholes.Examples.BaseClasses.PartialBorehole(
      redeclare IBPSA.Fluid.HeatExchangers.Ground.Boreholes.BoreholeTwoUTube
        borHol(energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial),
      borFieDat(
        conDat=IBPSA.Fluid.HeatExchangers.Ground.Data.ConfigurationData.Example(
          borCon=IBPSA.Fluid.HeatExchangers.Ground.Types.BoreholeConfiguration.DoubleUTubeParallel)));

  annotation (experiment(Tolerance=1e-6, StopTime=360000),
        __Dymola_Commands(file=
          "Resources/Scripts/Dymola/Fluid/HeatExchangers/Ground/Boreholes/Examples/BoreholeTwoUTube.mos"
        "Simulate and Plot"),
        Documentation(info="<html>
<p>
This example illustrates the use of the 
<a href=\"modelica://IBPSA.Fluid.HeatExchangers.Ground.Boreholes.BoreholeTwoUTube\">
IBPSA.Fluid.HeatExchangers.Ground.Boreholes.BoreholeTwoUTube</a>
model. It simulates the behavior of a borehole with a prescribed
borehole wall boundary condition.
</p>
</html>", revisions="<html>
<ul>
<li>
July 10, 2018, by Alex Laferri&egrave;re:<br/>
Adjusted the example following major changes to the IBPSA.Fluid.HeatExchangers.Ground package.
Additionally, implemented a partial example model.
</li>
<li>
August 30, 2011, by Pierre Vigouroux:<br/>
First implementation.
</li>
</ul>
</html>"));
end BoreholeTwoUTube;

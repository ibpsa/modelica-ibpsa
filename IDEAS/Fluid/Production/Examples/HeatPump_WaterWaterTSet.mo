within IDEAS.Fluid.Production.Examples;
model HeatPump_WaterWaterTSet
  "Test of a heat pump using a temperature setpoint"
  extends HeatPump_WaterWater(redeclare
      IDEAS.Fluid.Production.HP_WaterWater_TSet heatPump(
      redeclare package Medium1 = Medium,
      redeclare package Medium2 = Medium,
      redeclare IDEAS.Fluid.Production.BaseClasses.VitoCal300GBWS301dotA08
        heatPumpData,
      use_onOffSignal=false,
      use_modulationSignal=true));
  Modelica.Blocks.Sources.Constant const(k=273.15 + 35)
    annotation (Placement(transformation(extent={{-44,88},{-26,106}})));
  Modelica.Blocks.Sources.Step     const1(
    height=-0.5,
    offset=1,
    startTime=10000)
    annotation (Placement(transformation(extent={{8,26},{-8,42}})));
equation
  connect(const.y, heatPump.Tset) annotation (Line(
      points={{-25.1,97},{-22,97},{-22,75},{-20,75}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(const1.y, heatPump.mod) annotation (Line(
      points={{-8.8,34},{-21,34},{-21,61.2}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics),
    __Dymola_Commands(file="modelica://IDEAS/Resources/Scripts/Dymola/Fluid/Production/Examples/HeatPump_WaterWaterTSet.mos"
        "Simulate and plot"),  Documentation(revisions="<html>
<ul>
<li>March 2014 by Filip Jorissen:<br/> 
Initial version
</li>
</ul>
</html>", info="<html>
<p>This model demonstrates the use of a heat pump with a temperature set point.</p>
</html>"),
    experiment(StopTime=15000),
    __Dymola_experimentSetupOutput);
end HeatPump_WaterWaterTSet;

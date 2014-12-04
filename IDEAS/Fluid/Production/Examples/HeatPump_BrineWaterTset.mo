within IDEAS.Fluid.Production.Examples;
model HeatPump_BrineWaterTset
  "Test of a heat pump using a temperature setpoint"
  extends HeatPump_BrineWater(redeclare IDEAS.Fluid.Production.HeatPumpTset heatPump(
    redeclare package MediumBrine = Medium,
    redeclare package MediumFluid = Medium,
    redeclare IDEAS.Fluid.Production.BaseClasses.VitoCal300GBWS301dotA08
      heatPumpData,
      use_onOffSignal=false));
  Modelica.Blocks.Sources.Constant const(k=273.15 + 35)
    annotation (Placement(transformation(extent={{2,68},{-18,88}})));
equation
  connect(const.y, heatPump.Tset) annotation (Line(
      points={{-19,78},{-57,78},{-57,68}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Documentation(revisions="<html>
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
end HeatPump_BrineWaterTset;

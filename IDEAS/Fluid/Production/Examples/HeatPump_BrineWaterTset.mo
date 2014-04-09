within IDEAS.Fluid.Production.Examples;
model HeatPump_BrineWaterTset
  "Test of a heat pump using a temperature setpoint"
  extends HeatPump_BrineWater(redeclare IDEAS.Fluid.Production.HeatPumpTset heatPump(
    redeclare package MediumBrine = Medium,
    redeclare package MediumFluid = Medium,
    redeclare IDEAS.Fluid.Production.BaseClasses.VitoCal300GBWS301dotA08
      heatPumpData));
  Modelica.Blocks.Sources.Constant const(k=273.15 + 35)
    annotation (Placement(transformation(extent={{2,56},{-18,76}})));
equation
  connect(const.y, heatPump.Tset) annotation (Line(
      points={{-19,66},{-50,66},{-50,38.8}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Documentation(revisions="<html>
<ul>
<li>March 2014 by Filip Jorissen:<br/> 
Initial version
</li>
</ul>
</html>"),
    experiment(StopTime=15000),
    __Dymola_experimentSetupOutput);
end HeatPump_BrineWaterTset;

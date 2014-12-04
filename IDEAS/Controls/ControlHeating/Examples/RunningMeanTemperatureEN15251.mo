within IDEAS.Controls.ControlHeating.Examples;
model RunningMeanTemperatureEN15251
  extends Modelica.Icons.Example;

  Simplified2ZonesOfficeBuilding.Control.BaseClasses.RunningMeanTemperatureEN15251_discrete
    runningMeanTemperature
    annotation (Placement(transformation(extent={{-8,-10},{12,10}})));
  Simplified2ZonesOfficeBuilding.Control.BaseClasses.RunningMeanTemperatureEN15251_continuous
    runningMeanTemperatureEN15251_continuous
    annotation (Placement(transformation(extent={{-10,30},{10,50}})));
  inner IDEAS.SimInfoManager sim
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=sim.Te)
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
equation
  connect(realExpression.y, runningMeanTemperature.TIn) annotation (Line(
      points={{-59,0},{-8.6,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(realExpression.y, runningMeanTemperatureEN15251_continuous.TIn)
    annotation (Line(
      points={{-59,0},{-40,0},{-40,40},{-10.6,40}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics),
    experiment(StopTime=1e+006),
    __Dymola_experimentSetupOutput);
end RunningMeanTemperatureEN15251;

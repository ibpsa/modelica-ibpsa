within IDEAS.Controls.ControlHeating.Examples;
model RunningMeanTemperatureEN15251
  extends Modelica.Icons.Example;

  IDEAS.Controls.ControlHeating.RunningMeanTemperatureEN15251_discrete runningMeanTemperature_discrete
    annotation (Placement(transformation(extent={{-10,-20},{10,0}})));
  inner IDEAS.SimInfoManager sim
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  RunningMeanTemperatureEN15251_continuous
    runningMeanTemperatureEN15251_continuous
    annotation (Placement(transformation(extent={{-10,20},{10,40}})));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics),
    experiment(StopTime=1e+007, __Dymola_NumberOfIntervals=50000),
    __Dymola_experimentSetupOutput);
end RunningMeanTemperatureEN15251;

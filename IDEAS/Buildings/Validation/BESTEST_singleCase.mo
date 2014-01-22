within IDEAS.Buildings.Validation;
model BESTEST_singleCase

  extends Modelica.Icons.RotationalSensor;

  /*
Simulation of a single BESTEST case of your choice.
*/

  inner IDEAS.SimInfoManager sim(
    redeclare IDEAS.Climate.Meteo.Files.min60 detail,
    redeclare IDEAS.Climate.Meteo.Locations.BesTest city,
    PV=false,
    occBeh=false)
    annotation (Placement(transformation(extent={{-92,68},{-82,78}})));

  replaceable Cases.Case900 Case900 constrainedby Interfaces.BesTestCase
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  annotation (
    Diagram(graphics),
    experiment(
      StopTime=3.1536e+007,
      Interval=600,
      Tolerance=1e-007),
    __Dymola_experimentSetupOutput(events=false));
end BESTEST_singleCase;

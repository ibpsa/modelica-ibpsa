within IDEAS.Buildings.Validation;
model BESTEST_singleCase

  extends Modelica.Icons.Example;

  /*
Simulation of a single BESTEST case of your choice.
*/

  inner IDEAS.SimInfoManager sim(
    PV=false,
    occBeh=false)
    annotation (Placement(transformation(extent={{-92,68},{-82,78}})));

  replaceable Cases.Case900 Case900 constrainedby Interfaces.BesTestCase
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  inner Modelica.Fluid.System system
    annotation (Placement(transformation(extent={{-100,70},{-92,78}})));
  annotation (
    Diagram(graphics),
    experiment(
      StopTime=3.1536e+007,
      Interval=600,
      Tolerance=1e-007),
    __Dymola_experimentSetupOutput(events=false));
end BESTEST_singleCase;

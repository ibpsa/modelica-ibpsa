within IDEAS.Buildings.Validation.Tests;
model Case650 "Case 650"

  extends Modelica.Icons.Example;

  /*

Simulation of all so far modeled BESTEST cases in a single simulation.

*/

  inner IDEAS.BoundaryConditions.SimInfoManager sim(
    filNam="BESTEST.TMY",
    lat=0.69464104229374,
    lon=-1.8308503853421,
    timZonSta=-7*3600)
    annotation (Placement(transformation(extent={{-92,68},{-82,78}})));

  // BESTEST 600 Series

  replaceable Cases.Case650 Case650 constrainedby Interfaces.BesTestCase
    annotation (Placement(transformation(extent={{44,44},{56,56}})));

  // BESTEST 900 Series

  annotation (
    experiment(
      StopTime=3.1536e+007,
      Interval=3600,
      Tolerance=1e-007),
    __Dymola_experimentSetupOutput,
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}), graphics={Text(
          extent={{-78,68},{-40,60}},
          lineColor={85,0,0},
          fontName="Calibri",
          textStyle={TextStyle.Bold},
          textString="BESTEST 600 Series")}),
    __Dymola_Commands(file=
          "Resources/Scripts/Dymola/Buildings/Validation/Tests/Case650.mos"
        "Simulate and plot"));
end Case650;

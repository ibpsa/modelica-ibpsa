within IDEAS.Buildings.Validation;
model BESTEST

  extends Modelica.Icons.Example;

  /*

Simulation of all so far modeled BESTEST cases in a single simulation.

*/

  inner IDEAS.SimInfoManager sim(
    occBeh=false,
    PV=false,
    filNam="BESTEST.TMY",
    lat=0.69464104229374,
    lon=-1.8308503853421,
    timZonSta=-25200)
              annotation (Placement(transformation(extent={{-92,68},{-82,78}})));

  // BESTEST 600 Series

  replaceable Cases.Case600 Case600 constrainedby Interfaces.BesTestCase
    annotation (Placement(transformation(extent={{-76,44},{-64,56}})));
  replaceable Cases.Case600FF Case600FF constrainedby Interfaces.BesTestCase
    annotation (Placement(transformation(extent={{-56,44},{-44,56}})));
  replaceable Cases.Case610 Case610 constrainedby Interfaces.BesTestCase
    annotation (Placement(transformation(extent={{-36,44},{-24,56}})));
  replaceable Cases.Case620 Case620 constrainedby Interfaces.BesTestCase
    annotation (Placement(transformation(extent={{-16,44},{-4,56}})));
  replaceable Cases.Case630 Case630 constrainedby Interfaces.BesTestCase
    annotation (Placement(transformation(extent={{4,44},{16,56}})));
  replaceable Cases.Case640 Case640 constrainedby Interfaces.BesTestCase
    annotation (Placement(transformation(extent={{24,44},{36,56}})));
  replaceable Cases.Case650 Case650 constrainedby Interfaces.BesTestCase
    annotation (Placement(transformation(extent={{44,44},{56,56}})));
  replaceable Cases.Case650FF Case650FF constrainedby Interfaces.BesTestCase
    annotation (Placement(transformation(extent={{64,44},{76,56}})));

  // BESTEST 900 Series

  replaceable Cases.Case900 Case900 constrainedby Interfaces.BesTestCase
    annotation (Placement(transformation(extent={{-76,4},{-64,16}})));
  replaceable Cases.Case900FF Case900FF constrainedby Interfaces.BesTestCase
    annotation (Placement(transformation(extent={{-56,4},{-44,16}})));
  replaceable Cases.Case910 Case910 constrainedby Interfaces.BesTestCase
    annotation (Placement(transformation(extent={{-36,4},{-24,16}})));
  replaceable Cases.Case920 Case920 constrainedby Interfaces.BesTestCase
    annotation (Placement(transformation(extent={{-16,4},{-4,16}})));
  replaceable Cases.Case930 Case930 constrainedby Interfaces.BesTestCase
    annotation (Placement(transformation(extent={{4,4},{16,16}})));
  replaceable Cases.Case940 Case940 constrainedby Interfaces.BesTestCase
    annotation (Placement(transformation(extent={{24,4},{36,16}})));
  replaceable Cases.Case950 Case950 constrainedby Interfaces.BesTestCase
    annotation (Placement(transformation(extent={{44,4},{56,16}})));
  replaceable Cases.Case950FF Case950FF constrainedby Interfaces.BesTestCase
    annotation (Placement(transformation(extent={{64,4},{76,16}})));
  inner Modelica.Fluid.System system
    annotation (Placement(transformation(extent={{-100,70},{-92,78}})));
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
          textString="BESTEST 600 Series"),Text(
          extent={{-78,28},{-40,20}},
          lineColor={85,0,0},
          fontName="Calibri",
          textStyle={TextStyle.Bold},
          textString="BESTEST 900 Series")}));
end BESTEST;

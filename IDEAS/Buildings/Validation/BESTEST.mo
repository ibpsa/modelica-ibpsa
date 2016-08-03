within IDEAS.Buildings.Validation;
model BESTEST
  extends Modelica.Icons.Example;

  inner IDEAS.BoundaryConditions.SimInfoManager sim(
    lat=0.69464104229374,
    lon=-1.8308503853421,
    timZonSta=-7*3600,
    filNam="BESTEST.TMY")
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));


  IDEAS.Buildings.Validation.Cases.Case600 Case600
    annotation (Placement(transformation(extent={{-76,44},{-64,56}})));
  IDEAS.Buildings.Validation.Cases.Case600FF Case600FF
    annotation (Placement(transformation(extent={{-56,44},{-44,56}})));
  IDEAS.Buildings.Validation.Cases.Case610 Case610
    annotation (Placement(transformation(extent={{-36,44},{-24,56}})));
  IDEAS.Buildings.Validation.Cases.Case620 Case620
    annotation (Placement(transformation(extent={{-16,44},{-4,56}})));
  IDEAS.Buildings.Validation.Cases.Case630 Case630
    annotation (Placement(transformation(extent={{4,44},{16,56}})));
  IDEAS.Buildings.Validation.Cases.Case640 Case640
    annotation (Placement(transformation(extent={{24,44},{36,56}})));
  IDEAS.Buildings.Validation.Cases.Case650 Case650
    annotation (Placement(transformation(extent={{44,44},{56,56}})));
  IDEAS.Buildings.Validation.Cases.Case650FF Case650FF
    annotation (Placement(transformation(extent={{64,44},{76,56}})));
  IDEAS.Buildings.Validation.Cases.Case900 Case900
    annotation (Placement(transformation(extent={{-76,4},{-64,16}})));
  IDEAS.Buildings.Validation.Cases.Case900FF Case900FF
    annotation (Placement(transformation(extent={{-56,4},{-44,16}})));
  IDEAS.Buildings.Validation.Cases.Case910 Case910
    annotation (Placement(transformation(extent={{-36,4},{-24,16}})));
  IDEAS.Buildings.Validation.Cases.Case920 Case920
    annotation (Placement(transformation(extent={{-16,4},{-4,16}})));
  IDEAS.Buildings.Validation.Cases.Case930 Case930
    annotation (Placement(transformation(extent={{4,4},{16,16}})));
  IDEAS.Buildings.Validation.Cases.Case940 Case940
    annotation (Placement(transformation(extent={{24,4},{36,16}})));
  IDEAS.Buildings.Validation.Cases.Case950 Case950
    annotation (Placement(transformation(extent={{44,4},{56,16}})));
  IDEAS.Buildings.Validation.Cases.Case950FF Case950FF
    annotation (Placement(transformation(extent={{64,4},{76,16}})));

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

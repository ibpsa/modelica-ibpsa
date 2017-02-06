within IDEAS.Buildings.Validation.Tests;
model ConvectionVerification
  "Comparison between linear and non-linear convection"
  extends Modelica.Icons.Example;

  inner BoundaryConditions.SimInfoManager sim(
    filNam="BESTEST.TMY",
    lat=0.69464104229374,
    lon=-1.8308503853421,
    timZonSta=-28800)
    annotation (Placement(transformation(extent={{-92,68},{-82,78}})));
  IDEAS.Buildings.Validation.Cases.Case900 CaseLin(building(
      roof(linearise_a=true),
      wall(each linearise_a=true),
      floor(linearise_a=true),
      win(each linearise_a=true)))
    annotation (Placement(transformation(extent={{-76,4},{-64,16}})));
  IDEAS.Buildings.Validation.Cases.Case900 CaseNonLin(building(
      roof(linearise_a=false),
      wall(each linearise_a=false),
      floor(linearise_a=false),
      win(each linearise_a=false)))
    annotation (Placement(transformation(extent={{-76,-16},{-64,-4}})));
  annotation (Diagram(graphics={           Text(
          extent={{-78,28},{-40,20}},
          lineColor={85,0,0},
          fontName="Calibri",
          textStyle={TextStyle.Bold},
          textString="BESTEST 900 Series")}),
    experiment(
      StopTime=1e+06,
      Interval=3600,
      Tolerance=1e-07,
      __Dymola_Algorithm="Lsodar"),
    __Dymola_experimentSetupOutput,
    __Dymola_Commands(executeCall(ensureSimulated=true) = {createPlot(
        id=1,
        position={0,0,1097,611},
        y={"CaseNonLin.heatingSystem.QHeaSys","CaseLin.heatingSystem.QHeaSys"},
        range={0.0,1000000.0,-4000.0,2000.0},
        grid=true,
        filename="ConvectionVerification.mat",
        colors={{28,108,200},{238,46,47}}),createPlot(
        id=1,
        position={0,0,1097,302},
        y={"CaseLin.building.TSensor[1]","CaseNonLin.building.TSensor[1]"},
        range={0.0,1000000.0,293.0,301.0},
        grid=true,
        subPlot=2,
        colors={{28,108,200},{238,46,47}})} "Simulate and plot"));
end ConvectionVerification;

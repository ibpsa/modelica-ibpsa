within IDEAS.Buildings.Validation.Tests;
model EnergyConservationValidation
  "This example shows how conservation of energy can be checked."
  extends Components.Examples.ZoneExample(zone(nSurf=6));
  Modelica.Blocks.Sources.RealExpression Qgai(y=sim.Qgai.Q_flow)
    "Thermal gains of model"
    annotation (Placement(transformation(extent={{40,60},{60,80}})));
  Modelica.Blocks.Continuous.Integrator intQgai(k=1/3600000)
    "Integral of internal gains of model [kWh]"
    annotation (Placement(transformation(extent={{80,60},{100,80}})));
  Modelica.Blocks.Sources.RealExpression absQgai(y=abs(sim.Qgai.Q_flow))
    "Absolute thermal gains of model"
    annotation (Placement(transformation(extent={{40,30},{60,50}})));
  Modelica.Blocks.Continuous.Integrator intAbsQgai(k=1/3600000)
    "Integral of absolute internal gains of model [kWh]"
    annotation (Placement(transformation(extent={{80,30},{100,50}})));
  Components.OuterWall
            outerWall1(
    inc=0,
    azi=0,
    redeclare parameter IDEAS.Buildings.Validation.Data.Constructions.HeavyWall
      constructionType,
    redeclare parameter IDEAS.Buildings.Data.Insulation.Glasswool insulationType,
    AWall=10,
    insulationThickness=0)
    annotation (Placement(transformation(extent={{-54,-26},{-44,-6}})));
  Components.Window
         window1(
    inc=0,
    azi=0,
    redeclare parameter IDEAS.Buildings.Data.Glazing.Ins2 glazing,
    redeclare IDEAS.Buildings.Data.Interfaces.Frame fraType,
    A=2,
    redeclare IDEAS.Buildings.Components.Shading.None shaType)
    annotation (Placement(transformation(extent={{-10,40},{0,60}})));
equation
  connect(Qgai.y, intQgai.u)
    annotation (Line(points={{61,70},{61,70},{78,70}}, color={0,0,127}));
  connect(absQgai.y, intAbsQgai.u)
    annotation (Line(points={{61,40},{61,40},{78,40}}, color={0,0,127}));
  connect(outerWall1.propsBus_a, zone.propsBus[5]) annotation (Line(
      points={{-44,-12},{-2,-12},{-2,-6},{20,-6}},
      color={255,204,51},
      thickness=0.5));
  connect(window1.propsBus_a, zone.propsBus[6]) annotation (Line(
      points={{0,54},{20,54},{20,-6}},
      color={255,204,51},
      thickness=0.5));
  annotation (
    experiment(
      StopTime=3.15e+07,
      __Dymola_NumberOfIntervals=15000,
      Tolerance=1e-06),
    __Dymola_experimentSetupOutput,
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})),
    __Dymola_Commands(file=
          "Resources/Scripts/Dymola/Buildings/Validation/Tests/EnergyConservationValidation.mos"
        "Simulate and plot"));
end EnergyConservationValidation;

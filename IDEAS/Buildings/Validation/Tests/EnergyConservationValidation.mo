within IDEAS.Buildings.Validation.Tests;
model EnergyConservationValidation
  "This example shows how conservation of energy can be checked."
  extends Components.Examples.ZoneExample;

  parameter Modelica.SIunits.Energy E0(fixed=false);
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
  Modelica.Blocks.Sources.RealExpression consEne(y=E0 + intQgai.y + (outerWall.layMul.E
         + zone.E + zone1.E + commonWall.layMul.E + commonWall1.layMul.E +
        slabOnGround.layMul.E)/3600000) "Conservaiton of energy"
    annotation (Placement(transformation(extent={{-50,-106},{100,-86}})));

initial equation
  consEne.y=0;
equation

  assert(abs(consEne.y)<1e-6, "Conservation of energy is violated!");

  connect(Qgai.y, intQgai.u)
    annotation (Line(points={{61,70},{61,70},{78,70}}, color={0,0,127}));
  connect(absQgai.y, intAbsQgai.u)
    annotation (Line(points={{61,40},{61,40},{78,40}}, color={0,0,127}));
  annotation (
    experiment(
      StopTime=5e+06,
      __Dymola_NumberOfIntervals=5000,
      Tolerance=1e-06),
    __Dymola_experimentSetupOutput,
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})),
    __Dymola_Commands(file=
          "Resources/Scripts/Dymola/Buildings/Validation/Tests/EnergyConservationValidation.mos"
        "Simulate and plot"));
end EnergyConservationValidation;

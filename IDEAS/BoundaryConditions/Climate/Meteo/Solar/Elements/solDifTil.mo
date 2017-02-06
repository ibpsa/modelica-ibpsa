within IDEAS.BoundaryConditions.Climate.Meteo.Solar.Elements;
model solDifTil

extends Modelica.Blocks.Interfaces.BlockIcon;

parameter Modelica.SIunits.Area A;
parameter Modelica.SIunits.Angle inc(displayUnit="degree") "inclination";

Modelica.Blocks.Interfaces.RealOutput solDifTil
    annotation (Placement(transformation(extent={{90,50},{110,70}})));
  outer IDEAS.BoundaryConditions.SimInfoManager sim
    annotation (Placement(transformation(extent={{60,72},{80,92}})));

  Modelica.Blocks.Interfaces.RealInput angZen
    annotation (Placement(transformation(extent={{-120,0},{-80,40}})));
  Modelica.Blocks.Interfaces.RealInput angInc
    annotation (Placement(transformation(extent={{-120,40},{-80,80}})));

final parameter Modelica.SIunits.Angle i = inc/180*Modelica.Constants.pi;

  SkyClearness skyClearness
    annotation (Placement(transformation(extent={{-60,10},{-42,28}})));
  RelativeAirMass relativeAirMass
    annotation (Placement(transformation(extent={{-60,-18},{-42,0}})));
  SkyBrightness skyBrightness
    annotation (Placement(transformation(extent={{-34,-18},{-16,0}})));
  SkyBrightnessCoefficients skyBrightnessCoefficients
    annotation (Placement(transformation(extent={{0,22},{18,40}})));
  Perez perez(A=A, inc=inc) annotation (Placement(transformation(extent={{40,44},{60,64}})));

equation
  connect(angZen, skyClearness.angZen) annotation (Line(
      points={{-100,20},{-70,20},{-70,24},{-66,24},{-60,24.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(angZen, relativeAirMass.angZen) annotation (Line(
      points={{-100,20},{-70,20},{-70,-3.6},{-60,-3.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(relativeAirMass.relAirMas, skyBrightness.relAirMas) annotation (
      Line(
      points={{-42,-3.6},{-40,-3.6},{-40,-3.6},{-38,-3.6},{-38,-3.6},{-34,-3.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(angZen, skyBrightnessCoefficients.angZen) annotation (Line(
      points={{-100,20},{-70,20},{-70,36.4},{0,36.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(skyClearness.skyCle, skyBrightnessCoefficients.skyCle) annotation (
      Line(
      points={{-42,24.4},{-22,24.4},{-22,32.8},{0,32.8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(skyBrightness.skyBri, skyBrightnessCoefficients.skyBri) annotation (
     Line(
      points={{-16,-3.6},{-8,-3.6},{-8,29.2},{0,29.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(skyBrightnessCoefficients.F1, perez.F1) annotation (Line(
      points={{18,36.4},{22,36},{26,36},{26,52},{40,52}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(skyBrightnessCoefficients.F2, perez.F2) annotation (Line(
      points={{18,32.8},{30,32.8},{30,48},{40,48}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(angZen, perez.angZen) annotation (Line(
      points={{-100,20},{-70,20},{-70,56},{40,56}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(angInc, perez.angInc) annotation (Line(
      points={{-100,60},{40,60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(perez.solDifTil, solDifTil) annotation (Line(
      points={{60,60},{100,60}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(graphics));
end solDifTil;

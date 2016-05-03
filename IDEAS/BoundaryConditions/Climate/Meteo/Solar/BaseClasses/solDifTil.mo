within IDEAS.BoundaryConditions.Climate.Meteo.Solar.BaseClasses;
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

  final parameter Modelica.SIunits.Angle i=inc/180*Modelica.Constants.pi;

  Perez perez(A=A, inc=inc)
    annotation (Placement(transformation(extent={{40,44},{60,64}})));

  Modelica.Blocks.Sources.RealExpression realExpression(y=sim.skyBrightnessCoefficients.F1)
    annotation (Placement(transformation(extent={{-60,34},{6,54}})));
  Modelica.Blocks.Sources.RealExpression realExpression1(y=sim.skyBrightnessCoefficients.F2)
    annotation (Placement(transformation(extent={{-60,20},{6,40}})));
equation

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
  connect(realExpression.y, perez.F1) annotation (Line(
      points={{9.3,44},{24,44},{24,52},{40,52}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(realExpression1.y, perez.F2) annotation (Line(
      points={{9.3,30},{24,30},{24,32},{40,32},{40,48}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                      graphics));
end solDifTil;

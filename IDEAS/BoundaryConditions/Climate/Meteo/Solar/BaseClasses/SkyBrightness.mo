within IDEAS.BoundaryConditions.Climate.Meteo.Solar.BaseClasses;
block SkyBrightness
  extends Modelica.Blocks.Interfaces.BlockIcon;
  Modelica.Blocks.Interfaces.RealInput relAirMas "relative air mass"
    annotation (Placement(transformation(extent={{-120,40},{-80,80}})));
  Modelica.Blocks.Interfaces.RealOutput skyBri "sky brightness"
    annotation (Placement(transformation(extent={{90,50},{110,70}})));

  Modelica.Blocks.Interfaces.RealInput solDifHor "Diffuse horizontal radiation"
    annotation (Placement(transformation(extent={{-120,-20},{-80,20}})));
equation
  skyBri = IDEAS.Utilities.Math.Functions.smoothMin(
    solDifHor*relAirMas/1367,
    1,
    0.025);

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                      graphics));
end SkyBrightness;

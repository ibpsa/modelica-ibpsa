within IDEAS.BoundaryConditions.Climate.Meteo.Solar.Elements;
block SkyBrightness
  extends Modelica.Blocks.Interfaces.BlockIcon;
  outer IDEAS.BoundaryConditions.SimInfoManager sim
    annotation (Placement(transformation(extent={{-80,72},{-60,92}})));
  Modelica.Blocks.Interfaces.RealInput relAirMas "relative air mass"
    annotation (Placement(transformation(extent={{-120,40},{-80,80}})));
  Modelica.Blocks.Interfaces.RealOutput skyBri "sky brightness"
    annotation (Placement(transformation(extent={{90,50},{110,70}})));

algorithm
  skyBri := IDEAS.BaseClasses.Math.MinSmooth(
    sim.solDifHor*relAirMas/1367,
    1,
    0.025);

  annotation (Diagram(graphics));
end SkyBrightness;

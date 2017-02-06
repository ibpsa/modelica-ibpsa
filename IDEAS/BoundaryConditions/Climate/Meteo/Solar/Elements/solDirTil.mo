within IDEAS.BoundaryConditions.Climate.Meteo.Solar.Elements;
model solDirTil

extends Modelica.Blocks.Interfaces.BlockIcon;

parameter Modelica.SIunits.Area A;
parameter Modelica.SIunits.Angle inc(displayUnit="degree") "inclination";

  Modelica.Blocks.Interfaces.RealInput angSol
    annotation (Placement(transformation(extent={{-120,40},{-80,80}})));
  Modelica.Blocks.Interfaces.RealOutput solDirTil
    annotation (Placement(transformation(extent={{90,50},{110,70}})));
  outer IDEAS.BoundaryConditions.SimInfoManager sim
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));

algorithm
  if inc <= Modelica.Constants.small then
    solDirTil := IDEAS.BaseClasses.Math.MaxSmooth(
      0,
      A*sim.solDirHor,
      delta=0.01);
  else
    solDirTil := IDEAS.BaseClasses.Math.MaxSmooth(
      0,
      cos(angSol)*sim.solDirPer*A,
      delta=0.01);
  end if;
end solDirTil;

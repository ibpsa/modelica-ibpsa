within IDEAS.BoundaryConditions.Climate.Meteo.Solar.BaseClasses;
model solDirTil

  extends Modelica.Blocks.Interfaces.BlockIcon;

  parameter Modelica.SIunits.Angle inc(displayUnit="degree") "inclination";

  Modelica.Blocks.Interfaces.RealInput angSol
    annotation (Placement(transformation(extent={{-120,40},{-80,80}})));
  Modelica.Blocks.Interfaces.RealInput solDirPer
    annotation (Placement(transformation(extent={{-120,8},{-80,48}})));
  Modelica.Blocks.Interfaces.RealOutput solDirTil
    annotation (Placement(transformation(extent={{90,50},{110,70}})));

equation
    solDirTil =  IDEAS.Utilities.Math.Functions.smoothMax(
      0,
      cos(angSol)*solDirPer,
      deltaX=0.01);

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics));
end solDirTil;

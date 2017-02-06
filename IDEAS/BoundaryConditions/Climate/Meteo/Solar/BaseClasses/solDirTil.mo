within IDEAS.BoundaryConditions.Climate.Meteo.Solar.BaseClasses;
model solDirTil
  extends Modelica.Blocks.Icons.Block;
  parameter Modelica.SIunits.Angle inc(displayUnit="degree") "Inclination angle of surface";

  Modelica.Blocks.Interfaces.RealInput angSol
    "Solar angle"
    annotation (Placement(transformation(extent={{-120,40},{-80,80}})));
  Modelica.Blocks.Interfaces.RealInput solDirPer
    "Beam solar irradiation on surface perpendicular to beam direction"
    annotation (Placement(transformation(extent={{-120,-80},{-80,-40}})));
  Modelica.Blocks.Interfaces.RealOutput solDirTil=
    IDEAS.Utilities.Math.Functions.smoothMax(
      0,
      cos(angSol)*solDirPer,
      deltaX=0.01)
    "Direct/beam solar irradiation on tilted surface"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})));
end solDirTil;

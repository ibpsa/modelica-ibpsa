within IDEAS.BoundaryConditions.Climate.Meteo.Solar.BaseClasses;
block Perez
  extends Modelica.Blocks.Interfaces.BlockIcon;
  parameter Real rho=0.2 "Ground reflectance";
  parameter Modelica.SIunits.Angle inc(displayUnit="degree")
    "surface inclination";

  Modelica.Blocks.Interfaces.RealInput F1 "Circomsolar brightening coefficient"
    annotation (Placement(transformation(extent={{-120,-10},{-80,30}})));
  Modelica.Blocks.Interfaces.RealInput F2 "horizon brightening coefficient"
    annotation (Placement(transformation(extent={{-120,-50},{-80,-10}})));
  Modelica.Blocks.Interfaces.RealInput angZen(
    quantity="Angle",
    unit="rad",
    displayUnit="degree") "zenith angle"
    annotation (Placement(transformation(extent={{-120,30},{-80,70}})));
  Modelica.Blocks.Interfaces.RealInput angInc(
    quantity="Angle",
    unit="rad",
    displayUnit="degree") "incedence angle"
    annotation (Placement(transformation(extent={{-120,70},{-80,110}})));
  Modelica.Blocks.Interfaces.RealOutput solDifTil
    annotation (Placement(transformation(extent={{90,50},{110,70}})));

protected
  Real a;
  Real b;

public
  Modelica.Blocks.Interfaces.RealInput solDifHor
    "Diffuse solar radiation on horizontal surface"
    annotation (Placement(transformation(extent={{-120,-90},{-80,-50}})));
  Modelica.Blocks.Interfaces.RealInput solGloHor
    "Global radiation on horizontal surface"
    annotation (Placement(transformation(extent={{-120,-110},{-80,-70}})));
equation
  a = IDEAS.Utilities.Math.Functions.smoothMax(
    0,
    cos(angInc),
    0.01);
  b = IDEAS.Utilities.Math.Functions.smoothMax(
    0.087,
    cos(angZen),
    0.01);

    solDifTil =  solDifHor*(0.5*(1 - F1)*(1 + cos(inc)) + F1*a/b + F2*sin(inc)) + solGloHor*0.5*rho*(1 - cos(inc));

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics));
end Perez;

within IDEAS.Climate.Meteo.Solar.BaseClasses;
block Perez
  extends Modelica.Blocks.Interfaces.BlockIcon;
  outer IDEAS.SimInfoManager sim
    annotation (Placement(transformation(extent={{-68,72},{-48,92}})));
  parameter Real rho=0.2 "Ground reflectance";
  parameter Modelica.SIunits.Angle inc(displayUnit="degree")
    "surface inclination";
  parameter Modelica.SIunits.Area A "surface area";

  Modelica.Blocks.Interfaces.RealInput F1 "Circomsolar brightening coefficient"
    annotation (Placement(transformation(extent={{-120,-40},{-80,0}})));
  Modelica.Blocks.Interfaces.RealInput F2 "horizon brightening coefficient"
    annotation (Placement(transformation(extent={{-120,-80},{-80,-40}})));
  Modelica.Blocks.Interfaces.RealInput angZen(
    quantity="Angle",
    unit="rad",
    displayUnit="degree") "zenith angle"
    annotation (Placement(transformation(extent={{-120,0},{-80,40}})));
  Modelica.Blocks.Interfaces.RealInput angInc(
    quantity="Angle",
    unit="rad",
    displayUnit="degree") "incedence angle"
    annotation (Placement(transformation(extent={{-120,40},{-80,80}})));
  Modelica.Blocks.Interfaces.RealOutput solDifTil
    annotation (Placement(transformation(extent={{90,50},{110,70}})));

protected
  Real a;
  Real b;

algorithm
  a := IDEAS.Utilities.Math.Functions.smoothMax(
    0,
    cos(angInc),
    0.01);
  b := IDEAS.Utilities.Math.Functions.smoothMax(
    0.087,
    cos(angZen),
    0.01);

//  if inc <= Modelica.Constants.small then
//    solDifTil := sim.solDifHor;
//  else
    solDifTil := A*sim.solDifHor*(0.5*(1 - F1)*(1 + cos(inc)) + F1*a/b + F2*sin(inc)) + A*sim.solGloHor*0.5*rho*(1 - cos(inc));
//  end if;
end Perez;

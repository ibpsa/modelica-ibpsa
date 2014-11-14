within IDEAS.Climate.Meteo.Solar.BaseClasses;
block SkyClearness
  extends Modelica.Blocks.Interfaces.BlockIcon;
  Modelica.Blocks.Interfaces.RealInput angZen(
    quantity="Angle",
    unit="rad",
    displayUnit="degreeC") "zenith angle"
    annotation (Placement(transformation(extent={{-120,40},{-80,80}})));
  Modelica.Blocks.Interfaces.RealOutput skyCle "sky clearness"
    annotation (Placement(transformation(extent={{96,-10},{116,10}})));

//  final parameter Real kappa=1.041 "original kappa of 1.014 but for degrees";
protected
  final parameter Real kappa = 5.534*10^(-6)
    "original kappa of 1.014 but for degrees";

  Real solDifHorSmooth "smoothed horizontal difuse radiation";
  Real angZenDeg = angZen*180/Modelica.Constants.pi;

public
  Modelica.Blocks.Interfaces.RealInput solGloHor "Global horizontal radiation"
    annotation (Placement(transformation(extent={{-120,-20},{-80,20}})));
  Modelica.Blocks.Interfaces.RealInput solDifHor "Diffuse horizontal radiation"
    annotation (Placement(transformation(extent={{-120,-80},{-80,-40}})));
equation
  solDifHorSmooth = IDEAS.Utilities.Math.Functions.smoothMax(
    solDifHor,
    1e-4,
    1e-5);
  skyCle = IDEAS.Utilities.Math.Functions.spliceFunction(x=solGloHor-1, pos=((solGloHor)
    /solDifHorSmooth + kappa*angZenDeg^3)/(1 + kappa*angZenDeg^3), neg= 1, deltax=1);
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                      graphics));
end SkyClearness;

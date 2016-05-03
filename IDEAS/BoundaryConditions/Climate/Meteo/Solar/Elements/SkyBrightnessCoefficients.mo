within IDEAS.BoundaryConditions.Climate.Meteo.Solar.Elements;
block SkyBrightnessCoefficients
  extends Modelica.Blocks.Interfaces.BlockIcon;
  Modelica.Blocks.Interfaces.RealInput skyCle
    annotation (Placement(transformation(extent={{-120,0},{-80,40}})));
  Modelica.Blocks.Interfaces.RealInput angZen
    annotation (Placement(transformation(extent={{-120,40},{-80,80}})));
  Modelica.Blocks.Interfaces.RealInput skyBri
    annotation (Placement(transformation(extent={{-120,-40},{-80,0}})));
  Modelica.Blocks.Interfaces.RealOutput F1
    "circumsolar brightening coefficient"
    annotation (Placement(transformation(extent={{90,50},{110,70}})));

  Modelica.Blocks.Interfaces.RealOutput F2 "horizon brightening coefficient"
    annotation (Placement(transformation(extent={{90,10},{110,30}})));

protected
  Real F11;
  Real F12;
  Real F13;
  Real F21;
  Real F22;
  Real F23;
  final parameter Real d = 0.01;
  Real[8] a;
  Real[8] b;

algorithm
  //first we define the discrete sky clearness categories a[:]
  b[1] := Modelica.Media.Air.MoistAir.Utilities.spliceFunction(1,0,1.065 - skyCle,d);
  b[2] := Modelica.Media.Air.MoistAir.Utilities.spliceFunction(1,0,1.23 - skyCle,d);
  b[3] := Modelica.Media.Air.MoistAir.Utilities.spliceFunction(1,0,1.50 - skyCle,d);
  b[4] := Modelica.Media.Air.MoistAir.Utilities.spliceFunction(1,0,1.95 - skyCle,d);
  b[5] := Modelica.Media.Air.MoistAir.Utilities.spliceFunction(1,0,2.8 - skyCle,d);
  b[6] := Modelica.Media.Air.MoistAir.Utilities.spliceFunction(1,0,4.5 - skyCle,d);
  b[7] := Modelica.Media.Air.MoistAir.Utilities.spliceFunction(1,0,6.2 - skyCle,d);
  b[8] := Modelica.Media.Air.MoistAir.Utilities.spliceFunction(1,0,skyCle - 6.2,d);
  a[1] := b[1];
  a[1] := b[2] - b[1];
  a[2] := b[3] - b[2];
  a[3] := b[4] - b[3];
  a[4] := b[5] - b[4];
  a[5] := b[6] - b[5];
  a[6] := b[7] - b[6];
  a[7] := b[8];

  F11 := -0.008*a[1] + 0.130*a[2] + 0.330*a[3] + 0.568*a[4] + 0.873*a[5] + 1.132*a[6] + 1.060*a[7] + 0.678*a[8];
  F12 := 0.588*a[1] + 0.683*a[2] + 0.487*a[3] + 0.187*a[4] - 0.392*a[5] - 1.237*a[6] - 1.600*a[7] - 0.327*a[8];
  F13 := -0.062*a[1] - 0.151*a[2] - 0.221*a[3] - 0.295*a[4] - 0.362*a[5] - 0.412*a[6] - 0.359*a[7] - 0.250*a[8];
  F21 := -0.060*a[1] - 0.019*a[2] + 0.055*a[3] + 0.109*a[4] + 0.226*a[5] + 0.288*a[6] + 0.264*a[7] + 0.156*a[8];
  F22 := 0.072*a[1] + 0.066*a[2] - 0.064*a[3] - 0.152*a[4] - 0.462*a[5] - 0.823*a[6] - 1.127*a[7] - 1.377*a[8];
  F23 := -0.022*a[1] - 0.029*a[2] - 0.026*a[3] - 0.014*a[4] + 0.001*a[5] + 0.056*a[6] + 0.131*a[7] + 0.251*a[8];
  F1 := IDEAS.BaseClasses.Math.MaxSmooth(
    0,
    F11 + F12*skyBri + F13*angZen,
    0.01);
  F2 := F21 + F22*skyBri + F23*angZen;

  annotation (Diagram(graphics));
end SkyBrightnessCoefficients;

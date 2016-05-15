within IDEAS.BoundaryConditions.Climate.Meteo.Solar.BaseClasses;
block RelativeAirMass
  extends Modelica.Blocks.Interfaces.BlockIcon;

  Modelica.Blocks.Interfaces.RealInput angZen(
    quantity="Angle",
    unit="rad",
    displayUnit="degreeC") "zenith angle"
    annotation (Placement(transformation(extent={{-120,40},{-80,80}})));
  Modelica.Blocks.Interfaces.RealOutput relAirMas "relative air mass"
    annotation (Placement(transformation(extent={{90,50},{110,70}})));

protected
  Real angZenDeg "limited zenith angle in degrees";
  Real angZenLim;

equation
  angZenLim = IDEAS.Utilities.Math.Functions.smoothMin(angZen,Modelica.Constants.pi/2,0.01);
  angZenDeg = angZenLim*180/Modelica.Constants.pi;
  relAirMas = 1/(cos(angZenLim) + 0.15*(93.9 - angZenDeg)^(-1.253));

end RelativeAirMass;

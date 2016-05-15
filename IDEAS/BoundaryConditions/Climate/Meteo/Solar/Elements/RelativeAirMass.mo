within IDEAS.BoundaryConditions.Climate.Meteo.Solar.Elements;
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
Real angZenLim "limited zenith angle";
Real angZenDeg "limited zenith angle in degrees";

algorithm
  angZenLim := IDEAS.BaseClasses.Math.MinSmooth(
    angZen,
    Modelica.Constants.pi/2,
    0.01);
angZenDeg := Modelica.SIunits.Conversions.to_deg(angZenLim);
relAirMas := 1/(cos(angZenLim) + 0.50572*(96.07995-angZenDeg)^(-1.6364));

end RelativeAirMass;

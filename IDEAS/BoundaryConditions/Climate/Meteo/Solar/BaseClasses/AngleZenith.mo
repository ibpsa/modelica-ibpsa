within IDEAS.BoundaryConditions.Climate.Meteo.Solar.BaseClasses;
model AngleZenith "solar angle to surface"

  extends Modelica.Blocks.Interfaces.BlockIcon;

  parameter Modelica.SIunits.Angle lat(displayUnit="degree");

public
  Modelica.Blocks.Interfaces.RealInput angDec(quantity="Angle", unit="rad")
    "declination"
    annotation (Placement(transformation(extent={{-120,40},{-80,80}})));
  Modelica.Blocks.Interfaces.RealInput angHou(quantity="Angle", unit="rad")
    "hour angle"
    annotation (Placement(transformation(extent={{-120,0},{-80,40}})));
  Modelica.Blocks.Interfaces.RealOutput angZen(
    final quantity="Angle",
    final unit="rad",
    displayUnit="deg") "Zenith Angle"
    annotation (Placement(transformation(extent={{90,50},{110,70}})));

equation
  angZen = acos(cos(lat)*cos(angDec)*cos(angHou) + sin(lat)*sin(angDec));

  annotation (Diagram(graphics), Icon(graphics={Polygon(
          points={{-88,-78},{-38,-38},{42,-38},{92,-78},{-88,-78}},
          lineColor={95,95,95},
          smooth=Smooth.None,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),Ellipse(
          extent={{90,90},{42,44}},
          lineColor={255,255,0},
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid),Line(
          points={{66,68},{-2,-56}},
          color={0,0,0},
          smooth=Smooth.None),Line(
          points={{-2,-56},{-2,84}},
          color={0,0,0},
          smooth=Smooth.None)}));
end AngleZenith;

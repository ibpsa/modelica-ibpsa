within IDEAS.BoundaryConditions.Climate.Meteo.Solar.BaseClasses;
model AngleSolar "solar angle to surface"

  extends Modelica.Blocks.Interfaces.BlockIcon;

  parameter Modelica.SIunits.Angle inc "inclination";
  parameter Modelica.SIunits.Angle azi "azimuth";
  parameter Modelica.SIunits.Angle lat;

public
  Modelica.Blocks.Interfaces.RealInput angDec(
    final quantity="Angle",
    final unit="rad",
    displayUnit="deg")
    annotation (Placement(transformation(extent={{-120,40},{-80,80}})));
  Modelica.Blocks.Interfaces.RealInput angHou(
    final quantity="Angle",
    final unit="rad",
    displayUnit="deg")
    annotation (Placement(transformation(extent={{-120,0},{-80,40}})));
  Modelica.Blocks.Interfaces.RealOutput angInc(
    final quantity="Angle",
    final unit="rad",
    displayUnit="deg") "Incidence angle"
    annotation (Placement(transformation(extent={{90,50},{110,70}})));

protected
  Real cosDec=Modelica.Math.cos(angDec);
  Real sinDec=Modelica.Math.sin(angDec);
  Real cosHou=Modelica.Math.cos(angHou);
  Real sinHou=Modelica.Math.sin(angHou);
  Real cosLat=Modelica.Math.cos(lat);
  Real sinLat=Modelica.Math.sin(lat);

equation
//  angInc = acos( cos(inc)*(cosDec*cosHou*cosLat + sinDec*sinLat) + sin(inc)*(sin(
//    azi)*cosDec*sinHou + cos(azi)*(cosDec*cosHou*sinLat - sinDec*cosLat)));

  angInc = acos(sinDec*sinLat*cos(inc) - sinDec*cosLat*sin(inc)*cos(azi) + cosDec*cosLat*cos(inc)*cosHou + cosDec*sinLat*sin(inc)*cos(azi)*cosHou + cosDec*sin(inc)*sin(azi)*sinHou);

  annotation (Icon(graphics={Ellipse(
          extent={{88,88},{40,42}},
          lineColor={255,255,0},
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid),Polygon(
          points={{-90,-76},{-40,-36},{40,-36},{90,-76},{-90,-76}},
          lineColor={95,95,95},
          smooth=Smooth.None),Polygon(
          points={{16,-42},{22,-68},{-72,0},{-18,-18},{16,-42}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillPattern=FillPattern.Solid,
          fillColor={175,175,175}),Line(
          points={{-6,-36},{84,40}},
          color={0,0,0},
          smooth=Smooth.None),Line(
          points={{-6,-36},{64,68}},
          color={0,0,0},
          smooth=Smooth.None)}), Diagram(graphics));
end AngleSolar;

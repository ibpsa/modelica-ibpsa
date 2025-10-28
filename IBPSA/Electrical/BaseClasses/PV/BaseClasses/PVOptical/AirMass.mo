within IBPSA.Electrical.BaseClasses.PV.BaseClasses.PVOptical;
block AirMass
  "Air mass calculation depending on zenith angle and height of object"
  extends Modelica.Blocks.Icons.Block;
  parameter Modelica.Units.SI.Height alt "Height of object";

  Modelica.Blocks.Interfaces.RealInput zenAng(
    final unit="rad",
    final displayUnit="deg")
    "Zenith angle for object"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput airMas(final unit="1")
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
protected
  Modelica.Units.SI.Angle zen "Zenith angle internal use";

equation
// Restriction for zenith angle
 zen = if zenAng <= Modelica.Constants.pi/2 then zenAng
 else Modelica.Constants.pi/2 "Zenith angle";

 airMas = exp(-0.0001184*alt)/(cos(zen) +
   0.5057*(96.080 - zen*180/Modelica.Constants.pi)^(-1.634)) "Air mass";

 annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
        Documentation(
          info="<html>
<p>
The model computes the air mass. It is based on an empirical approach by Kasten
et al. and bases on the zenith angle of the object as well as its height.
</p>
<h4>References</h4>
<p>
Kasten, F., &amp; Young, A. T. (1989). Revised optical air mass tables and
approximation formula. Applied optics, 28(22), 4735-4738.
<a href=\"https://doi.org/10.1364/AO.28.004735\">
https://doi.org/10.1364/AO.28.004735</a>
</p></html>",
revisions="<html>
<ul>
<li>
Jan 11, 2023, by Laura Maier:<br/>
First implementation.
</li>
</ul>
</html>"));
end AirMass;

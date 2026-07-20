within IBPSA.Fluid.PVTCollectors.BaseClasses;
model WindSpeedTilted "Calculate wind speed on a tilted surface"
  extends .Modelica.Blocks.Icons.Block;

  // Parameters
  parameter .Modelica.Units.SI.Angle azi(displayUnit="deg")
    "Surface azimuth (0 for south-facing; -90 degree for east-facing; +90 degree for west facing";
  parameter .Modelica.Units.SI.Angle til(displayUnit="deg")
    "Surface tilt (0 for horizontally mounted collector)";

  // Inputs
  .Modelica.Blocks.Interfaces.RealInput winSpe
    "Horizontal wind speed [m/s]"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  .Modelica.Blocks.Interfaces.RealInput winDir
    "Horizontal wind direction [rad]"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));

  // Outputs
  .Modelica.Blocks.Interfaces.RealOutput winSpeTil
    "Wind speed on the tilted surface [m/s]"
    annotation (Placement(transformation(extent={{100,50},{120,70}}),
        iconTransformation(extent={{100,50},{120,70}})));

equation
  winSpeTil = winSpe * sqrt(1 - (
    .Modelica.Math.cos(winDir - (azi + .Modelica.Constants.pi)) * .Modelica.Math.cos(til) +
    .Modelica.Math.sin(winDir - (azi + .Modelica.Constants.pi)) * .Modelica.Math.sin(til))^2);

annotation (
  defaultComponentName="winSpe",
  Documentation(info="<html>
<p>
This component computes the wind speed on a tilted surface starting from the horizontal wind speed and orientation.
The tilted surface is characterised by its tilt and azimuth angles.
</p>
</html>",
revisions="<html>
<ul>
<li>
July 17, 2026, by Lone Meertens:<br/>
Initial implementation. 
This is for <a href=\"https://github.com/open-ideas/IDEAS/issues/1473\">#1473</a>.
</li>
</ul>
</html>"));
end WindSpeedTilted;

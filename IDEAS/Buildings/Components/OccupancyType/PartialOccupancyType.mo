within IDEAS.Buildings.Components.OccupancyType;
record PartialOccupancyType
  "Record for defining the type (i.e. properties) of the occupants, used in InternalGains and Comfort models"
  extends Modelica.Icons.Record;

  parameter Modelica.SIunits.Power QlatPp = 45
    "Sensible heat production per person, default from Ashrae Fundamentals: 'Seated, very light work'";
  parameter Modelica.SIunits.Power QsenPp = 73
    "Latent heat production per person, default from Ashrae Fundamentals: 'Seated, very light work'";
  parameter Real radFra(min=0,max=1) = 0.6
    "Radiant fraction of sensible heat exchange, default based on Ashrae fundamentals chap 18.4 for low air velocity, used for computing radiative and convective sensible heat flow rate fractions";
  parameter Real ICl(min=0) = 0.7
    "Fixed value for clothing insulation in units of clo (summer=0.5; winter=0.9), used to compute thermal comfort";
  annotation (Documentation(revisions="<html>
<ul>
<li>
July 18, 2016 by Filip Jorissen:<br/>
First implementation
</li>
</ul>
</html>"));
end PartialOccupancyType;

within IDEAS.Buildings.Components.LightingType.BaseClasses;
partial record PartialLighting
  "Record for defining the type of the lighting"
  extends Modelica.Icons.Record;

  parameter Modelica.SIunits.Area A_zone(min=0)
    "Area of the zone";
  annotation (Documentation(revisions="<html>
<ul>
<li>
August 28, 2018 by Iago Cupeiro:<br/>
First implementation
See <a href=\"https://github.com/open-ideas/IDEAS/issues/879\">#879</a>.
</li>
</li>
</ul>
</html>", info="<html>
<p>This record allows to use the feature </p>
<p><span style=\"font-family: Courier New;\">constrainedby</span></p>
<p>in the partialZone model for the lighting records</p>
<p>For the correct working of the model it is important to keep:</p>
<p><span style=\"font-family: Courier New;\">  <span style=\"color: #ff0000;\">extends </span></p>
<p><span style=\"font-family: Courier New;\">      <span style=\"color: #0000ff;\">IDEAS.Buildings.Components.LightingType.LightingGains.OpenOfficeLights</span>(</p>
<p><span style=\"font-family: Courier New;\">      A = A_zone);</span></p>
<p><br>in order to propagate correctly the zone area</p>
</html>"));
end PartialLighting;

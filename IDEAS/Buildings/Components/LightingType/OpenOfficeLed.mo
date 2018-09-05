within IDEAS.Buildings.Components.LightingType;
record OpenOfficeLed "Properties for typical open office with led lights."
  extends Modelica.Icons.Record;
  extends
      IDEAS.Buildings.Components.LightingType.BaseClasses.PartialLighting(
      redeclare replaceable IDEAS.Buildings.Components.LightingType.LightingGains.OpenOfficeLights ligGai(A=A),
      redeclare replaceable IDEAS.Buildings.Components.LightingType.LightingSplit.RecessedLEDTrofferUniformDiffuser ligSpl);

  annotation (Documentation(revisions="<html>
<ul>
<li>
August 28, 2018 by Iago Cupeiro:<br/>
First implementation
See <a href=\"https://github.com/open-ideas/IDEAS/issues/879\">#879</a>.
</li>
</ul>
</html>", info=""));


end OpenOfficeLed;

within IDEAS.Buildings.Components.RoomType.BaseClasses;
partial record PartialRoomType
  extends Modelica.Icons.Record;

  parameter String use "zone type determined by the usage";
  parameter Modelica.SIunits.Illuminance Ev "Illuminance requirements of the zone";

  annotation (Documentation(revisions="<html>
<ul>
<li>
September 26, 2018 by Iago Cupeiro:<br/>
First implementation
See <a href=\"https://github.com/open-ideas/IDEAS/issues/879\">#879</a>.
</li>
</ul>
</html>", info="<html>
<p>This record may be used to describe the destination use of the zone.</p>
<p>At this stage, this record only supports the illuminance requirements of the zone.</p>
</html>"));
end PartialRoomType;

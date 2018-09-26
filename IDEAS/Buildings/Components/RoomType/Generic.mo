within IDEAS.Buildings.Components.RoomType;
record Generic "Generic room type"
  extends Modelica.Icons.Record;
  extends IDEAS.Buildings.Components.RoomType.BaseClasses.PartialRoomType(
  use="Generic",
  Ev = 300);
  annotation (Documentation(revisions="<html>
<ul>
<li>
September 26, 2018 by Iago Cupeiro:<br/>
First implementation
See <a href=\"https://github.com/open-ideas/IDEAS/issues/879\">#879</a>.
</li>
</ul>
</html>"));
end Generic;

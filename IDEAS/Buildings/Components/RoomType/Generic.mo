within IDEAS.Buildings.Components.RoomType;
record Generic "Generic room type"
  extends Modelica.Icons.Record;
  extends IDEAS.Buildings.Components.RoomType.BaseClasses.PartialRoomType(
  use="Generic",
  Ev = 300);
end Generic;

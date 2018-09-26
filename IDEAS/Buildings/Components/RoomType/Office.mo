within IDEAS.Buildings.Components.RoomType;
record Office "Office room type"
  extends Modelica.Icons.Record;
  extends IDEAS.Buildings.Components.RoomType.BaseClasses.PartialRoomType(
  use="Office",
  Ev = 500);
end Office;

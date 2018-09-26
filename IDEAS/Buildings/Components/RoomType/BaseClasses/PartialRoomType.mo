within IDEAS.Buildings.Components.RoomType.BaseClasses;
partial record PartialRoomType
  extends Modelica.Icons.Record;

  parameter String use "zone type determined by the usage";
  parameter Modelica.SIunits.Illuminance Ev "Illuminance requirements of the zone";

end PartialRoomType;

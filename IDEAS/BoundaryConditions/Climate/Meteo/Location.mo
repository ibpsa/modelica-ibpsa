within IDEAS.BoundaryConditions.Climate.Meteo;
model Location "Geogrphical location"

  parameter Modelica.SIunits.Angle lat(displayUnit="degree")
    "latitude of the locatioin";
  parameter Modelica.SIunits.Angle lon(displayUnit="degree")
    "longitude of the locatioin";
  parameter Modelica.SIunits.Temperature Tdes "Design outdoor temperature";
  parameter Modelica.SIunits.Temperature TdesGround "Design ground temperature";
  parameter Modelica.SIunits.Time timZonSta "Standard (winter) time zone";
  parameter Boolean DST "Take into account daylight saving time or not";
  parameter Integer yr "Ddepcited year for DST only";
  parameter String locNam;

end Location;

within IDEAS.Buildings.Components;
record IncidenceAngles
  "Record defining for which incidence angles the solar radiation needs to be calculated"
  extends Modelica.Icons.Record;

  constant Modelica.SIunits.Angle  roofInc = IDEAS.Constants.Ceiling;
  parameter Modelica.SIunits.Angle offset = IDEAS.Constants.South
    "Offset for the angle";
  parameter Integer numAng = 4 "Number of angels to be calculated";
  parameter Real lat= 0 "Latitude";
end IncidenceAngles;

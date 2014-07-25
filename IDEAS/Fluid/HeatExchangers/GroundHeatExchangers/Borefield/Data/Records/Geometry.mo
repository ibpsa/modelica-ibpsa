within IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.Data.Records;
record Geometry "Parameters of the geometrical configuration of the borefield"
  extends Modelica.Icons.Record;
  import SI = Modelica.SIunits;

  parameter String path="IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.Data.Records.Geometry";

  /*Borehole*/
  parameter SI.Height hBor=100 "Total height of the borehole"
    annotation (Dialog(group="Borehole"));
  parameter SI.Radius rBor=0.1 "Radius of the borehole"
    annotation (Dialog(group="Borehole"));
  parameter Integer nbBh=1 "total number of boreholes"
    annotation (Dialog(group="Borehole"));

  parameter Integer nbSer=1
    "DO NOT CHANGE! NOT YET SUPPORTED. number of boreholes in series."
    annotation (Dialog(group="Borehole"));

  parameter Real[nbBh,2] cooBh={{0,0}}
    "cartesian coordinates of the boreholes in meters."
    annotation (Dialog(group="Borehole"));

  /*Pipe*/
  parameter SI.Radius rTub=0.02 "Radius of the tubes"
    annotation (Dialog(group="Tubes"));
  parameter SI.ThermalConductivity kTub=0.5 "Thermal conductivity of the tube"
    annotation (Dialog(group="Tubes"));

  parameter SI.Length eTub=0.002 "Thickness of a tube"
    annotation (Dialog(group="Tubes"));

  parameter SI.Length xC=0.05
    "Shank spacing, defined as the distance between the center of a pipe and the center of the borehole"
    annotation (Dialog(group="Tubes"));

end Geometry;

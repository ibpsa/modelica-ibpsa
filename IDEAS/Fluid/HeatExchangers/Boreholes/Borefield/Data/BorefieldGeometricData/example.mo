within IDEAS.Thermal.Components.GroundHeatExchanger.Borefield.Data.BorefieldGeometricData;
record example
  extends Records.BorefieldGeometryData(
    name="example",
    rBor=0.055,
    hBor=110,
    nbBh=8,
    nbSer=1,
    cooBh={{0,0},{5.5,0},{11,0},{16.5,0},{22,0},{27.5,0},{33,0},{38.5,0}},
    rTub=0.02,
    kTub=0.5,
    eTub=0.002,
    xC=0.05);
  // only rBor and hBor is given
end example;

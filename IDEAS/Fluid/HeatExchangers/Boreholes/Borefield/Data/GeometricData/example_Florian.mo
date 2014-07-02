within IDEAS.Thermal.Components.GroundHeatExchanger.Borefield.Data.GeometricData;
record example_Florian
  extends Records.Geometry(
    name="example",
    rBor=0.055,
    hBor=100,
    nbBh=1,
    nbSer=1,
    cooBh={{0,0}},
    rTub=0.02,
    kTub=0.5,
    eTub=0.002,
    xC=0.05);
end example_Florian;

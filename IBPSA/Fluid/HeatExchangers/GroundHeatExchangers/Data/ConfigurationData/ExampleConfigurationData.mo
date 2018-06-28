within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.ConfigurationData;
record ExampleConfigurationData
  extends Template(
    borCon = Types.BoreholeConfiguration.SingleUTube,
    nbBor=4,
    cooBor={{0,0},{0,6},{6,0},{6,6}},
    mBor_flow_nominal=0.3,
    dp_nominal=5e4,
    hBor=100.0,
    rBor=0.075,
    dBor=1.0,
    rTub=0.02,
    kTub=0.5,
    eTub=0.002,
    xC=0.05);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end ExampleConfigurationData;

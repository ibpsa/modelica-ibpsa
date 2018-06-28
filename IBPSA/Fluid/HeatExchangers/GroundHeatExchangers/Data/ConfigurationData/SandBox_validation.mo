within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.ConfigurationData;
record SandBox_validation
  "General record for validation bore field using sand box experiment"
  extends Template(
    borCon = Types.BoreholeConfiguration.SingleUTube,
    nbBor=1,
    cooBor={{0,0}},
    mBor_flow_nominal=0.197/998*1000,
    dp_nominal=5e4,
    hBor=18.3,
    rBor=0.063,
    dBor=0.0,
    rTub=0.02733/2,
    kTub=0.39,
    eTub=0.003,
    xC=0.053/2);
end SandBox_validation;

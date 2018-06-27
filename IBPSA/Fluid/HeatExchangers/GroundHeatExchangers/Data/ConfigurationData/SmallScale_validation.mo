within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.ConfigurationData;
record SmallScale_validation
  "General record for validation bore field using small scale experiment"
  extends Template(
    borCon = Types.BoreholeConfiguration.SingleUTube,
    nbBor=1,
    cooBor={{0,0}},
    mBor_flow_nominal=0.0303/60,
    dp_nominal=5e4,
    hBor=0.4,
    rBor=0.00629,
    dBor=0.019,
    rTub=0.125*0.0254/2,
    kTub=401.0,
    eTub=0.06*0.0254,
    xC=0.0050/2,
    p_constant=101.3e3);
end SmallScale_validation;

within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.ConfigurationData;
record SmallScale_validation
  "General record for validation bore field using small scale experiment"
  extends Template(
    borHolCon = Types.BoreHoleConfiguration.SingleUTube,
    m_flow_nominal_bh=0.0303/60,
    rBor=0.00629,
    hBor=0.4,
    dBor=0.019,
    nbBh=1,
    cooBh={{0,0}},
    rTub=0.125*0.0254/2,
    kTub=401.0,
    eTub=0.06*0.0254,
    xC=0.0050/2,
    T_start=273.15 + 23);
end SmallScale_validation;

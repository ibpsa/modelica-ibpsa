within IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.Data.GeneralData;
record c1x1_h110_b5_d3600_T283
  "Line configuration of 8 boreholes of 110 meter with a spacing of 5.5 meter from each other. Initial temperature is 283K and the discretization is 3600 seconds"
  extends Records.General(
    pathMod=
        "IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.Data.GeneralData.c8x1_h110_b5_d3600_T283",
    pathCom=Modelica.Utilities.Files.loadResource(
        "modelica://IDEAS/Fluid/HeatExchangers/GroundHeatExchangers/Borefield/Data/GeneralData/c8x1_h110_b5_d3600_T283.mo"),
    singleUTube = true,
    m_flow_nominal_bh=0.3,
    T_start=283.15,
    rBor=0.15/2,
    hBor=110,
    nbBh=1,
    cooBh={{0,0}},
    rTub=0.02,
    kTub=0.5,
    eTub=0.002,
    xC=0.05,
    tStep=3600,
    q_ste=21.99,
    nHor=10,
    rExt=3);

end c1x1_h110_b5_d3600_T283;

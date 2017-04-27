within IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.Data.GeneralData;
record GeneralTrt2UTube
  "General record for validation bore field using thermal response test"
  extends Records.General(
    pathMod="IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.Data.GeneralData.GeneralTrt2UTube",
    pathCom=Modelica.Utilities.Files.loadResource("modelica://IDEAS/Fluid/HeatExchangers/GroundHeatExchangers/Borefield/Data/GeneralData/GeneralTrt2UTube.mo"),
    singleUTube = false,
    parallel2UTube = true,
    m_flow_nominal_bh=1225/3600,
    rBor=0.15/2,
    hBor=40,
    nbBh=1,
    nbSer=1,
    cooBh={{0,0}},
    kTub=0.38,
    eTub=0.0029,
    rTub=0.025/2,
    xC=rBor/2.5,
    T_start=273.15+11.28,
    tStep=600,
    nVer = 10);
end GeneralTrt2UTube;

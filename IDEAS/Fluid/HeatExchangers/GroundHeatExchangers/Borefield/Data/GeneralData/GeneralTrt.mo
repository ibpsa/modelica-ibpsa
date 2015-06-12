within IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.Data.GeneralData;
record GeneralTrt
  "General record for validation bore field using thermal response test"
extends Records.General(
    pathMod="IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.Data.GeneralData.GeneralTrt",
    pathCom=Modelica.Utilities.Files.loadResource("modelica://IDEAS/Fluid/HeatExchangers/GroundHeatExchangers/Borefield/Data/GeneralData/GeneralTrt.mo"),
    singleUTube = true,
    parallel2UTube = false,
    m_flow_nominal_bh=1225/3600,
    rBor=0.15/2,
    hBor=40,
    nbBh=1,
    nbSer=1,
    cooBh={{0,0}},
    rTub=0.025,
    kTub=0.38,
    eTub=0.0029,
    xC=0.03,
    T_start=273.15+11.28,
    tStep=600,
    use_Rb = true,
    Rb = 0.09);
end GeneralTrt;

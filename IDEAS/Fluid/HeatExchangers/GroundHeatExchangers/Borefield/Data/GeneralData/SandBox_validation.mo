within IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.Data.GeneralData;
record SandBox_validation
  "General record for validation bore field using sand box experiment"
extends Records.General(
    pathMod="IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.Data.GeneralData.SandBox_validation",
    pathCom=Modelica.Utilities.Files.loadResource("modelica://IDEAS/Fluid/HeatExchangers/GroundHeatExchangers/Borefield/Data/GeneralData/SandBox_validation.mo"),
    singleUTube = true,
    m_flow_nominal_bh=0.197/998*1000,
    rBor=0.063,
    hBor=18.3,
    nbBh=1,
    nbSer=1,
    cooBh={{0,0}},
    rTub=0.02733/2,
    kTub=0.39,
    eTub=0.003,
    xC=0.053/2,
    T_start=273.15+22,
    tStep=60,
    q_ste = 1056 / 18.3);
end SandBox_validation;

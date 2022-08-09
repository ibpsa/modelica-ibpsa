within IBPSA.Fluid.HeatPumps.BlackBoxData.EuropeanNom2D.EN255;
record AlphaInnotec_SW170I "Alpha Innotec SW 170 I"
  extends
    IBPSA.Fluid.HeatPumps.BlackBoxData.EuropeanNom2D.HeatPumpBaseDataDefinition(
    tablePel=[0,-5.0,0.0,5.0; 35,3700,3600,3600; 50,5100,5100,5100],
    tableQCon_flow=[0,-5.0,0.0,5.0; 35,14800,17200,19100; 50,14400,16400,18300],
    mCon_flow_nominal=17200/4180/10,
    mEva_flow_nominal=13600/3600/3,
    tableUppBou=[-22,65; 45,65]);

  annotation ();
end AlphaInnotec_SW170I;

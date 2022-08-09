within IBPSA.Fluid.HeatPumps.BlackBoxData.EuropeanNom2D.EN14511;
record Ochsner_GMSW_15plus "Ochsner GMSW 15 plus"
  extends
    IBPSA.Fluid.HeatPumps.BlackBoxData.EuropeanNom2D.HeatPumpBaseDataDefinition(
    tablePel=[0,-5,0,5; 35,3225,3300,3300; 45,4000,4000,4000; 55,4825,4900,
        4900],
    tableQCon_flow=[0,-5,0,5; 35,12762,14500,16100; 45,12100,13900,15600; 55,
        11513,13200,14900],
    mCon_flow_nominal=14500/4180/5,
    mEva_flow_nominal=(14500 - 3300)/3600/3,
    tableUppBou=[-8,52; 0,65; 20,65]);

  annotation ();
end Ochsner_GMSW_15plus;

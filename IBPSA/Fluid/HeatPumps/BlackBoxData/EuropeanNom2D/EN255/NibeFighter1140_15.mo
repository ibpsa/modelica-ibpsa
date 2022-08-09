within IBPSA.Fluid.HeatPumps.BlackBoxData.EuropeanNom2D.EN255;
record NibeFighter1140_15 "Nibe Fighter 1140-15"
  extends
    IBPSA.Fluid.HeatPumps.BlackBoxData.EuropeanNom2D.HeatPumpBaseDataDefinition(
    tablePel=[0,-5.0,0.0,2,5.0,10; 35,3360,3380,3380,3390,3400; 55,4830,4910,
        4940,4990,5050],
    tableQCon_flow=[0,-5.0,0.0,2,5.0,10; 35,13260,15420,16350,17730,19930; 55,
        12560,14490,15330,16590,18900],
    mCon_flow_nominal=15420/4180/10,
    mEva_flow_nominal=(15420 - 3380)/3600/3,
    tableUppBou=[-35,65; 50,65]);

  annotation ();
end NibeFighter1140_15;

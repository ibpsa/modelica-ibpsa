within IBPSA.Fluid.HeatPumps.BlackBoxData.EuropeanNom2D.EN14511;
record Vaillant_VWL_101 "Vaillant VWL10-1"
  extends
    IBPSA.Fluid.HeatPumps.BlackBoxData.EuropeanNom2D.HeatPumpBaseDataDefinition(
    tablePel=[0,-15,-7,2,7; 35,2138,2177,2444,2444; 45,2558,2673,2864,3055;
        55,2902,3131,3360,3513],
    tableQCon_flow=[0,-15,-7,2,7; 35,5842,7523,9776,10807; 45,5842,7332,9050,
        10387; 55,5728,7179,9050,10043],
    mCon_flow_nominal=9776/4180/5,
    mEva_flow_nominal=1,
    tableUppBou=[-25,65; 40,65]);
    //These boundary-tables are not from the datasheet but default values.

  annotation ();
end Vaillant_VWL_101;

within IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.Data.ShortTermResponse;
record example
  extends Records.ShortTermResponse(
    name="example",
    vecLen=BaseClasses.Scripts.readTrajectoryVecLen(
        "..\\IDEAS\\IDEAS\\Fluid\\HeatExchangers\\GroundHeatExchangers\\Borefield\\Data\\ShortTermResponse\\exampleData"),
    tVec=BaseClasses.Scripts.readTrajectorytVec(
        "..\\IDEAS\\IDEAS\\Fluid\\HeatExchangers\\GroundHeatExchangers\\Borefield\\Data\\ShortTermResponse\\exampleData"),
    TResSho=BaseClasses.Scripts.readTrajectoryTResSho(
        "..\\IDEAS\\IDEAS\\Fluid\\HeatExchangers\\GroundHeatExchangers\\Borefield\\Data\\ShortTermResponse\\exampleData"));
end example;

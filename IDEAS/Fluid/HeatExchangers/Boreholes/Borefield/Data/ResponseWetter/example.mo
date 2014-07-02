within IDEAS.Thermal.Components.GroundHeatExchanger.Borefield.Data.ResponseWetter;
record example
  extends Records.ResponseWetter(
    name="..\\IDEAS\\IDEAS\\Thermal\\Components\\GroundHeatExchanger\\Borefield\\Data\\ResponseWetter\\exampleData",
    vecLen=BaseClasses.Scripts.readTrajectoryVecLen(
        "..\\IDEAS\\IDEAS\\Thermal\\Components\\GroundHeatExchanger\\Borefield\\Data\\ResponseWetter\\exampleData"),
    tVec=BaseClasses.Scripts.readTrajectorytVec(
        "..\\IDEAS\\IDEAS\\Thermal\\Components\\GroundHeatExchanger\\Borefield\\Data\\ResponseWetter\\exampleData"),
    TResSho=BaseClasses.Scripts.readTrajectoryTResSho(
        "..\\IDEAS\\IDEAS\\Thermal\\Components\\GroundHeatExchanger\\Borefield\\Data\\ResponseWetter\\exampleData"));
end example;

within IDEAS.Thermal.Components.GroundHeatExchanger.Borefield.Data.ResponseWetter;
record example_accurate
  extends Records.ResponseWetter(
    name="example_accurate",
    vecLen=BaseClasses.Scripts.readTrajectoryVecLen(
        "..\\IDEAS\\IDEAS\\Thermal\\Components\\GroundHeatExchanger\\Borefield\\Data\\ResponseWetter\\example_accurateData"),
    tVec=BaseClasses.Scripts.readTrajectorytVec(
        "..\\IDEAS\\IDEAS\\Thermal\\Components\\GroundHeatExchanger\\Borefield\\Data\\ResponseWetter\\example_accurateData"),
    TResSho=BaseClasses.Scripts.readTrajectoryTResSho(
        "..\\IDEAS\\IDEAS\\Thermal\\Components\\GroundHeatExchanger\\Borefield\\Data\\ResponseWetter\\example_accurateData"));

end example_accurate;

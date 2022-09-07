within IBPSA.Fluid.HeatPumps.BlackBoxData.EuropeanNom2D.EN14511;
record StiebelEltron_WPL18 "Stiebel Eltron WPL 18"
  extends
    IBPSA.Fluid.HeatPumps.BlackBoxData.EuropeanNom2D.HeatPumpBaseDataDefinition(
    device_id="StiebelEltron_WPL18",
    tablePel=[0,-7,2,7,10,20; 35,3300,3400,3500,3700,3800; 50,4500,4400,4600,
        5000,5100],
    tableQCon_flow=[0,-7,2,7,10,20; 35,9700,11600,13000,14800,16300; 50,10000,
        11200,12900,16700,17500],
    mCon_flow_nominal=13000/4180/5,
    mEva_flow_nominal=1,
    tableUppBou=[-25,65; 40,65]);
    //These boundary-tables are not from the datasheet but default values.

  annotation (Documentation(info="<html>
<p><span style=\"font-family: Courier New; color: #006400;\">Data for a Stiebel Eltron WPL18 air-to-water heat pump</span></p>
</html>"));
end StiebelEltron_WPL18;

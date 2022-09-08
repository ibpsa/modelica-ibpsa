within IBPSA.Fluid.HeatPumps.BlackBoxData.EuropeanNorm2DData.EN14511;
record Ochsner_GMLW_19plus "Ochsner GMLW 19 plus"
  extends
    IBPSA.Fluid.HeatPumps.BlackBoxData.EuropeanNorm2DData.HeatPumpBaseDataDefinition(
    device_id="Ochsner_GMLW_19plus",
    tablePel=[0,-10,2,7; 35,4100,4300,4400; 50,5500,5700,5800; 60,6300,6500,
        6600],
    tableQCon_flow=[0,-10,2,7; 35,12600,16800,19800; 50,11700,15900,18900; 60,
        11400,15600,18600],
    mCon_flow_nominal=19800/4180/5,
    mEva_flow_nominal=1,
    tableUppBou=[-24,52; -15,55; -10,65; 40,65]);

  annotation (Documentation(info="<html>
<p><span style=\"font-family: Courier New; color: #006400;\">Data for the Ochsner GMLW 19 plus air-to-water device</span></p>
</html>"));
end Ochsner_GMLW_19plus;

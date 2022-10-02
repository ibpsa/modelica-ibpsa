within IBPSA.Fluid.HeatPumps.BlackBoxData.EuropeanNorm2DData.EN255;
record NibeFighter1140_15 "Nibe Fighter 1140-15"
  extends
    IBPSA.Fluid.HeatPumps.BlackBoxData.EuropeanNorm2DData.HeatPumpBaseDataDefinition(
    device_id="NibeFighter1140_15",
    tablePel=[0,-5.0,0.0,2,5.0,10; 35,3360,3380,3380,3390,3400; 55,4830,4910,
        4940,4990,5050],
    tableQCon_flow=[0,-5.0,0.0,2,5.0,10; 35,13260,15420,16350,17730,19930; 55,
        12560,14490,15330,16590,18900],
    mCon_flow_nominal=15420/4180/10,
    mEva_flow_nominal=(15420 - 3380)/3600/3,
    tableUppBou=[-35,65; 50,65]);

  annotation (Documentation(info="<html>
  <p>Brine-to-water heat pump according to: 
  <a href=\"https://www.nibe.lv/nibedocuments/10153/031094-4.pdf\">
  https://www.nibe.lv/nibedocuments/10153/031094-4.pdf</a></p>
</html>", revisions="<html>
<ul>
  <li>
    <i>November 26, 2018</i> by Fabian Wuellhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/RWTH-EBC/AixLib/issues/577\">AixLib #577</a>)
  </li>
</ul>
</html>"));
end NibeFighter1140_15;

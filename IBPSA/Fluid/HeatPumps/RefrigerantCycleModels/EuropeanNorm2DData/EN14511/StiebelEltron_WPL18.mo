within IBPSA.Fluid.HeatPumps.RefrigerantCycleModels.EuropeanNorm2DData.EN14511;
record StiebelEltron_WPL18 "Stiebel Eltron WPL 18"
  extends
    IBPSA.Fluid.HeatPumps.RefrigerantCycleModels.EuropeanNorm2DData.HeatPumpBaseDataDefinition(
    device_id="StiebelEltron_WPL18",
    tablePel=[
      0,-7,2,7,10,20;
      35,3300,3400,3500,3700,3800;
      50,4500,4400,4600,5000,5100],
    tableQCon_flow=[
      0,-7,2,7,10,20;
      35,9700,11600,13000,14800,16300;
      50,10000, 11200,12900,16700,17500],
    mCon_flow_nominal=13000/4180/5,
    mEva_flow_nominal=1,
    tableUppBou=[-25,65; 40,65],
    use_conOut=true,
    use_evaOut=false);
    //These boundary-tables are not from the datasheet but default values.

  annotation (Documentation(info="<html>
<p>Data for a Stiebel Eltron WPL18 air-to-water heat pump </p>
</html>", revisions="<html>
<ul>
  <li>
    <i>November 26, 2018</i> by Fabian Wuellhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/RWTH-EBC/AixLib/issues/577\">AixLib #577</a>)
  </li>
</ul>
</html>"));
end StiebelEltron_WPL18;

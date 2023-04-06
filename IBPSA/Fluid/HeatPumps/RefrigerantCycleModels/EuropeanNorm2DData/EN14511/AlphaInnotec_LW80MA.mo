within IBPSA.Fluid.HeatPumps.RefrigerantCycleModels.EuropeanNorm2DData.EN14511;
record AlphaInnotec_LW80MA "Alpha Innotec LW 80 M-A"
  extends
    IBPSA.Fluid.HeatPumps.RefrigerantCycleModels.EuropeanNorm2DData.HeatPumpBaseDataDefinition(
    device_id="AlphaInnotec_LW80MA",
    tablePel=[0,-7,2,7,10,15,20; 35,2625,2424,2410,2395,2347,2322; 45,3136,3053,
        3000,2970,2912,2889; 50,3486,3535,3451,3414,3365,3385],
    tableQCon_flow=[0,-7,2,7,10,15,20; 35,6300,8000,9400,10300,11850,13190; 45,
        6167,7733,9000,9750,11017,11730; 50,6100,7600,8800,9475,10600,11000],
    mCon_flow_nominal=9400/4180/5,
    mEva_flow_nominal=1,
    tableUppBou=[-25,65; 40,65]);
    //These boundary-tables are not from the datasheet but default values.

  annotation (Documentation(info="<html>
<p>Data for air-to-water heat pump Alpha Innotec LW 80 M-A.</p>
<p>Operational envelope data is not from the data table, as it 
is not given. Instead, default values are used.</p>
</html>", revisions="<html>
<ul>
  <li>
    <i>November 26, 2018</i> by Fabian Wuellhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/RWTH-EBC/AixLib/issues/577\">AixLib #577</a>)
  </li>
</ul>
</html>
"));
end AlphaInnotec_LW80MA;

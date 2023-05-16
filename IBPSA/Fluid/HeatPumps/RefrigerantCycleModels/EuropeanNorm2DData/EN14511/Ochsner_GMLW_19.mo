within IBPSA.Fluid.HeatPumps.RefrigerantCycleModels.EuropeanNorm2DData.EN14511;
record Ochsner_GMLW_19 "Ochsner GMLW 19"
  extends
    IBPSA.Fluid.HeatPumps.RefrigerantCycleModels.EuropeanNorm2DData.HeatPumpBaseDataDefinition(
    device_id="Ochsner_GMLW_19",
    tablePel=[
      0,-10,2,7;
      35,4300,4400,4600;
      50,6300,6400,6600],
    tableQCon_flow=[
      0,-10,2,7;
      35,11600,17000,20200;
      50,10200,15600,18800],
    mCon_flow_nominal=20200/4180/5,
    mEva_flow_nominal=1,
    tableUppBou=[-15,55; 40,55],
    use_conOut=true,
    use_evaOut=false);

  annotation (Documentation(info="<html>
<p>Data for the Ochsner GMLW 19 air-to-water device </p>
</html>", revisions="<html>
<ul>
  <li>
    <i>November 26, 2018</i> by Fabian Wuellhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/RWTH-EBC/AixLib/issues/577\">AixLib #577</a>)
  </li>
</ul>
</html>"));
end Ochsner_GMLW_19;

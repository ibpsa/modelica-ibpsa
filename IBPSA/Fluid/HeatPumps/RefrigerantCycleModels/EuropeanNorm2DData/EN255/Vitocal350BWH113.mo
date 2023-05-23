within IBPSA.Fluid.HeatPumps.RefrigerantCycleModels.EuropeanNorm2DData.EN255;
record Vitocal350BWH113 "Vitocal 350 BWH 113"
  extends
    IBPSA.Fluid.HeatPumps.RefrigerantCycleModels.EuropeanNorm2DData.HeatPumpBaseDataDefinition(
    devIde="Vitocal350BWH113",
    tabPEle=[
      0,-5.0,0.0,5.0,10.0,15.0;
      35,3750,3750,3750,3750,3833;
      45,4833,4917,4958,5042,5125;
      55,5583,5667,5750,5833,5958;
      65,7000,7125,7250,7417,7583],
    tabQCon_flow=[
      0,-5.0,0.0,5.0,10.0,15.0;
      35,14500,16292,18042,19750,21583;
      45,15708,17167,18583,20083,21583;
      55,15708,17167,18583,20083,21583;
      65,15708,17167,18583,20083,21583],
    mCon_flow_nominal=16292/4180/10,
    mEva_flow_nominal=12300/3600/3,
    tabUppBou=[-5,55; 25,55],
    use_conOut=true,
    use_evaOut=false);

  annotation (Documentation(info="<html>
<p>Data for VitoCal350 brine-to-water heat pump, around 16 kW </p>
</html>", revisions="<html>
<ul>
  <li>
    <i>November 26, 2018</i> by Fabian Wuellhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/RWTH-EBC/AixLib/issues/577\">AixLib #577</a>)
  </li>
</ul>
</html>"));
end Vitocal350BWH113;

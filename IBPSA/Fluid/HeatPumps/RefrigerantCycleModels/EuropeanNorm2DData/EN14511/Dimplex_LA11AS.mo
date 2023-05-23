within IBPSA.Fluid.HeatPumps.RefrigerantCycleModels.EuropeanNorm2DData.EN14511;
record Dimplex_LA11AS "Dimplex LA 11 AS"
  extends
    IBPSA.Fluid.HeatPumps.RefrigerantCycleModels.EuropeanNorm2DData.HeatPumpBaseDataDefinition(
    devIde="Dimplex_LA11AS",
    tabPEle=[
      0,-7,2,7,10;
      35,2444,2839,3139,3103;
      45,2783,2974,3097,3013],
    tabQCon_flow=[
      0,-7,2,7,10;
      35,6600,8800,11300,12100;
      45,6400,7898,9600,10145],
    mCon_flow_nominal=11300/4180/5,
    mEva_flow_nominal=1,
    tabUppBou=[-25,58; 35,58],
    use_conOut=true,
    use_evaOut=false);

  annotation (Documentation(info="<html>
<p>Data for a Dimplex LA11AS air-to-water heat pump. </p>
</html>", revisions="<html>
<ul>
  <li>
    <i>November 26, 2018</i> by Fabian Wuellhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/RWTH-EBC/AixLib/issues/577\">AixLib #577</a>)
  </li>
</ul>
</html>"));
end Dimplex_LA11AS;

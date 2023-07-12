within IBPSA.Fluid.HeatPumps.ModularReversible.Data.TableData2D.EN14511;
record Ochsner_GMSW_15plus "Ochsner GMSW 15 plus"
  extends
    IBPSA.Fluid.HeatPumps.ModularReversible.Data.TableData2D.GenericHeatPump(
    devIde="Ochsner_GMSW_15plus",
    tabPEle=[
      0,-5,0,5;
      35,3225,3300,3300;
      45,4000,4000,4000;
      55,4825,4900,4900],
    tabQCon_flow=[
      0,-5,0,5;
      35,12762,14500,16100;
      45,12100,13900,15600;
      55,11513,13200,14900],
    mCon_flow_nominal=14500/4180/5,
    mEva_flow_nominal=(14500 - 3300)/3600/3,
    tabUppBou=[-8,52; 0,65; 20,65],
    use_conOut=true,
    use_evaOut=false);

  annotation (Documentation(info="<html>
<p>Data for the Ochsner GMLW 15 brine-to-water device </p>
</html>", revisions="<html>
<ul>
  <li>
    <i>November 26, 2018</i> by Fabian Wuellhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/RWTH-EBC/AixLib/issues/577\">AixLib #577</a>)
  </li>
</ul>
</html>"));
end Ochsner_GMSW_15plus;

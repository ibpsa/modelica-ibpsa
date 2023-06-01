within IBPSA.Fluid.Chillers.RefrigerantCycleModels.EuropeanNorm2DData.EN14511;
record Carrier30XWP1012_1MW
  "Data for model 30XW-P 1012 from Carrier with roughly 1 MW nominal power"
  extends
    IBPSA.Fluid.Chillers.RefrigerantCycleModels.EuropeanNorm2DData.ChillerBaseDataDefinition(
    tabQEva_flow=[
      0,25,30,35,40,45;
      5,1003000,968000,932000,894000,854000;
      7,1054000,1035000,995000,954000,911000;
      10,1102000,1120000,1096000,1050000,1002000;
      15,1181000,1199000,1226000,1227000,1170000;
      18,1227000,1244000,1275000,1311000,1278000],
    tabPEle=[
      0,25,30,35,40,45;
      5,158954,181955,208036,237766,271111;
      7,159215,182218,208159,237905,271131;
      10,159479,182708,208762,238095,271545;
      15,160462,183333,209573,239648,272727;
      18,161024,183752,210396,240550,274249],
    mCon_flow_nominal=49.85,
    mEva_flow_nominal=49.85,
    tabLowBou=[20, 3; 50, 3],
    devIde="Carrier30XWP1012",
    use_TConOutForOpeEnv=true,
    use_TEvaOutForOpeEnv=true,
    use_conOut=false,
    use_evaOut=true);

  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
  Performance data for Daikin FTXM20R_RXM20R for the cooling mode.
</p>
<p>
  Boundaries are for dry-bulb temperature.
</p>
</html>", revisions="<html>
<ul>
<li>
  <i>October 2, 2022</i> by Fabian Wuellhorst:<br/>
  First implementation (see issue <a href=
  \"https://github.com/ibpsa/modelica-ibpsa/issues/1576\">#1576</a>)
</li>
</ul>
</html>"));
end Carrier30XWP1012_1MW;

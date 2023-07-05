within IBPSA.Fluid.HeatPumps.Controls.Safety.RecordsCollection;
record DefaultHeatPumpSafetyControl "Apply the default values according to 
  the conference publication by Wuellhorst et. al."
  extends PartialRefrigerantMachineSafetyControlBaseDataDefinition(
    tabLowCoo=[-10,10; 60,10],
    dTHysAntFre=2,
    preYSet_start=false,
    ySetMin=0.3,
    m_flowConMinPer=0.1,
    m_flowEvaMinPer=0.1,
    use_minFlowCtr=true,
    use_runPerHou=true,
    use_minLocTime=true,
    use_minRunTime=true,
    TAntFre=273.15,
    use_antFre=false,
    dTHysOpeEnv=5,
    use_opeEnv=true,
    tabUppHea=[-40,70; 40,70],
    maxRunPerHou=3,
    minLocTime=1200,
    minRunTime=600);
  annotation (Documentation(info="<html>
<p>
  Default values according to the conference publication 
  by Wuellhorst et. al. <a href=\"https://doi.org/10.3384/ecp21181561\">
  https://doi.org/10.3384/ecp21181561</a>.
</p>
<p>
  These values are conservative estimates based on multiple datasheets.
</p>
</html>", revisions="<html><ul>
  <li>
    <i>October 2, 2022</i> by Fabian Wuellhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/ibpsa/modelica-ibpsa/issues/1576\">#1576</a>)
  </li>
</ul>
</html>
"));
end DefaultHeatPumpSafetyControl;

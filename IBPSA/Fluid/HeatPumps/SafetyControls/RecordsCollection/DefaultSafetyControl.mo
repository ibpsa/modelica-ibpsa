within IBPSA.Fluid.HeatPumps.SafetyControls.RecordsCollection;
record DefaultSafetyControl
  "Apply the default values according to the conference publication by Wuellhorst et. al."
  extends HeatPumpSafetyControlBaseDataDefinition(
    preYSet_start=true,
    ySetMin=0.3,
    m_flowConMinPer=0.1,
    m_flowEvaMinPer=0.1,
    use_minFlowCtrl=true,
    use_deFro=false,
    use_runPerHou=true,
    use_minLocTime=true,
    use_minRunTime=true,
    TantFre=273.15,
    use_antFre=false,
    calcPel_deFro=0,
    use_chiller=true,
    deltaIceFac=0.1,
    minIceFac=0.5,
    dTHystOperEnv=5,
    dataTable=
        IBPSA.Fluid.HeatPumps.BlackBoxData.EuropeanNorm2DData.EN14511.Vitocal200AWO201(),
    use_opeEnvFroRec=false,
    use_opeEnv=true,
    tableUpp=[-40,70; 40,70],
    maxRunPerHou=3,
    minLocTime=1200,
    minRunTime=600);
  annotation (Documentation(info="<html>
<p>Default values according to the conference publication by Wuellhorst et. al.</p>
</html>"));
end DefaultSafetyControl;

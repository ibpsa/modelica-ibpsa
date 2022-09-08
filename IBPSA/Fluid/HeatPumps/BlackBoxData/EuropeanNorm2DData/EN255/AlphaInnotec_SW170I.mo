within IBPSA.Fluid.HeatPumps.BlackBoxData.EuropeanNorm2DData.EN255;
record AlphaInnotec_SW170I "Alpha Innotec SW 170 I"
  extends
    IBPSA.Fluid.HeatPumps.BlackBoxData.EuropeanNorm2DData.HeatPumpBaseDataDefinition(
    device_id="AlphaInnotec_SW170I",
    tablePel=[0,-5.0,0.0,5.0; 35,3700,3600,3600; 50,5100,5100,5100],
    tableQCon_flow=[0,-5.0,0.0,5.0; 35,14800,17200,19100; 50,14400,16400,18300],

    mCon_flow_nominal=17200/4180/10,
    mEva_flow_nominal=13600/3600/3,
    tableUppBou=[-22,65; 45,65]);

  annotation (Documentation(info="<html>
<p>Data for a brine-to-water heat pump of Alpha Innotec. Data according to: <a href=\"https://www.forum-hausbau.de/data/PruefResSW090923.pdf\">https://www.forum-hausbau.de/data/PruefResSW090923.pdf</a></p>
</html>"));
end AlphaInnotec_SW170I;

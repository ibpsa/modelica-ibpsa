within IBPSA.Fluid.Chillers.Data.EuropeanNorm2D.EN14511;
record SingleSplitRXM20R "Daikin_FTXM20R_RXM20R cooling mode"
  extends IBPSA.Fluid.Chillers.Data.EuropeanNorm2D.Generic(
    tabPEle=[0,20,25,30,32,35,40; 20,340,370,400,410,430,470; 22,340,370,400,
        420,430,470; 25,340,370,400,420,440,470; 27,340,370,410,420,440,470; 30,
        340,380,410,420,440,470; 32,350,380,410,420,440,470],
    tabQEva_flow=[0,20,25,30,32,35,40; 20,2050,1960,1860,1830,1770,1680; 22,
        2140,2050,1950,1920,1860,1770; 25,2230,2140,2050,2010,1950,1860; 27,
        2280,2190,2090,2060,2000,1910; 30,2420,2320,2230,2190,2140,2050; 32,
        2510,2420,2320,2290,2230,2140],
    mCon_flow_nominal=36*1.2/60,
    mEva_flow_nominal=(9.642*1.2)/60,
    tabLowBou=[-10,18; 50,18],
    devIde="DaikinRXM20R",
    use_TConOutForOpeEnv=false,
    use_TEvaOutForOpeEnv=false,
    use_conOut=false,
    use_evaOut=false);

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
end SingleSplitRXM20R;

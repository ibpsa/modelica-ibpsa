within IBPSA.Fluid.HeatPumps.Data.EuropeanNorm2D.EN14511;
record SingleSplitRXM20R "Daikin_FTXM20R_RXM20R heating mode"
  extends IBPSA.Fluid.HeatPumps.Data.EuropeanNorm2D.GenericHeatPump(
    tabPEle=[0,-15,-10,-5,0,7,10; 15,1190,1430,1670,1940,2590,2810; 20,1120,
        1360,1600,1860,2500,2730; 22,1090,1330,1570,1830,2470,2690; 24,1060,
        1300,1540,1800,2430,2660; 25,1040,1280,1520,1780,2410,2640; 27,1010,
        1250,1490,1760,2380,2610],
    tabQCon_flow=[0,-15,-10,-5,0,7,10; 15,320,340,360,460,490,510; 20,330,350,
        370,470,500,520; 22,340,360,370,480,500,520; 24,340,360,380,480,510,530;
        25,340,360,380,490,510,530; 27,350,370,380,490,520,540],
    mCon_flow_nominal=(9.33*1.2)/60,
    mEva_flow_nominal=(28.3*1.2)/60,
    tabUppBou=[-20,30; 18,30],
    devIde="DaikinRXM20R",
    use_conOut=false,
    use_evaOut=false);

  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>Performance data&nbsp;for&nbsp;Daikin FTXM20R_RXM20R for the heating mode.</p>
</html>", revisions="<html>
<ul>
  <li>
    <i>November 26, 2018</i> by Fabian Wuellhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/RWTH-EBC/AixLib/issues/577\">AixLib #577</a>)
  </li>
</ul>
</html>"));
end SingleSplitRXM20R;

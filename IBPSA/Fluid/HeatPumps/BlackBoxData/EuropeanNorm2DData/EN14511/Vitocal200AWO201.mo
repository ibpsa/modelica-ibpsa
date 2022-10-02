within IBPSA.Fluid.HeatPumps.BlackBoxData.EuropeanNorm2DData.EN14511;
record Vitocal200AWO201
  "Vitocal200AWO201"
  extends
    IBPSA.Fluid.HeatPumps.BlackBoxData.EuropeanNorm2DData.HeatPumpBaseDataDefinition(
    device_id="Vitocal200AWO201",
    tablePel=[0,-15,-7,2,7,10,20,30; 35,1290.0,1310.0,730.0,870.0,850.0,830.0,
        780.0; 45,1550.0,1600.0,870.0,1110.0,1090.0,1080.0,1040.0; 55,1870.0,
        1940.0,1170.0,1370.0,1370.0,1370.0,1350.0],
    tableQCon_flow=[0,-15,-7,2,7,10,20,30; 35,3020,3810,2610,3960,4340,5350,
        6610; 45,3020,3780,2220,3870,4120,5110,6310; 55,3120,3790,2430,3610,
        3910,4850,6000],
    mCon_flow_nominal=3960/4180/5,
    mEva_flow_nominal=(2250*1.2)/3600,
    tableUppBou=[-20,50; -10,60; 30,60; 35,55]);

  annotation (
    Documentation(info="<html><p>
  Data record for type AWO-M/AWO-M-E-AC 201.A04,
  obtained from the technical guide in the UK.
</p>
</html>", revisions="<html>
<ul>
  <li>
    <i>November 26, 2018</i> by Fabian Wuellhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/RWTH-EBC/AixLib/issues/577\">AixLib #577</a>)
  </li>
</ul>
</html>"));
end Vitocal200AWO201;

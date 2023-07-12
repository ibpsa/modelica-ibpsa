within IBPSA.Fluid.HeatPumps.ModularReversible.Data.TableData2D.EN14511;
record Vitocal200AWO201
  "Vitocal200AWO201"
  extends IBPSA.Fluid.HeatPumps.ModularReversible.Data.TableData2D.GenericAirToWater(
    tabPEle=[
      0,-15,-7,2,7,10,20,30;
      35,2220,2310,1765,1597,1578,1601,1416;
      45,2600,2720,2370,1975,2293,2091,1865;
      55,2890,3130,3016,2484,2860,2669,2377],
    tabQCon_flow=[
      0,-15,-7,2,7,10,20,30;
      35,5230,6670,6990,7540,8100,10450,11870;
      45,5170,6490,6850,7060,8810,10130,11460;
      55,5270,6640,6720,6820,8420,9780,11010],
    mCon_flow_nominal=5620/4180/5,
    mEva_flow_nominal=(2600*1.2)/3600,
    tabUppBou=[-20,50; -10,60; 30,60; 35,55],
    devIde="Vitocal200AWO201",
    use_conOut=true,
    use_evaOut=false);

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

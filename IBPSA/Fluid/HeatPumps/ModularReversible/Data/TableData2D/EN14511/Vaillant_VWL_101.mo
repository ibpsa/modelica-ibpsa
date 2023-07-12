within IBPSA.Fluid.HeatPumps.ModularReversible.Data.TableData2D.EN14511;
record Vaillant_VWL_101 "Vaillant VWL10-1"
  extends
    IBPSA.Fluid.HeatPumps.ModularReversible.Data.TableData2D.GenericHeatPump(
    devIde="Vaillant_VWL_101",
    tabPEle=[
      0,-15,-7,2,7;
      35,2138,2177,2444,2444;
      45,2558,2673,2864,3055;
      55,2902,3131,3360,3513],
    tabQCon_flow=[
      0,-15,-7,2,7;
      35,5842,7523,9776,10807;
      45,5842,7332,9050,10387;
      55,5728,7179,9050,10043],
    mCon_flow_nominal=9776/4180/5,
    mEva_flow_nominal=1,
    tabUppBou=[-25,65; 40,65],
    use_conOut=true,
    use_evaOut=false);
    //These boundary-tables are not from the datasheet but default values.

  annotation (Documentation(info="<html>
<p>
  Data for a Vaillaint VLW_101 air-to-water heat pump.
  As the datasheet did not provide information on the 
  operational envelope, default values are used.  
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
end Vaillant_VWL_101;

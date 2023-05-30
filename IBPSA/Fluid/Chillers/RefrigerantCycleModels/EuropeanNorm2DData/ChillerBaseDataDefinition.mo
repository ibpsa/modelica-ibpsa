within IBPSA.Fluid.Chillers.RefrigerantCycleModels.EuropeanNorm2DData;
record ChillerBaseDataDefinition "Basic chiller data"
  extends
    IBPSA.Fluid.HeatPumps.RefrigerantCycleModels.EuropeanNorm2DData.RefrigerantCycle2DBaseDataDefinition;

  parameter Real tabQEva_flow[:,:]
    "Cooling power table, T in degC, Q_flow in W";
  parameter Real tabLowBou[:,2]
    "Points to define lower boundary for source temperature";
  annotation (Documentation(info="<html>
  
  <h4>Overview</h4>
<p>
  Base data definition used in the chiller model.
</p>
<p>
  Extends <a href=\"IBPSA.Fluid.HeatPumps.RefrigerantCycleModels.EuropeanNorm2DData.RefrigerantCycle2DBaseDataDefinition\">
  IBPSA.Fluid.HeatPumps.RefrigerantCycleModels.EuropeanNorm2DData.RefrigerantCycle2DBaseDataDefinition</a> 
  to enable correct selection.</p>
<p>
  Adds the table data for lower temperature limitations to 
  the partial record, which is the operational envelope of the compressor.
</p>
</html>",
        revisions="<html><ul>
  <li>
    <i>November 26, 2018&#160;</i> by Fabian Wuellhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/RWTH-EBC/AixLib/issues/577\">AixLib #577</a>)
  </li>
</ul>
</html>"),
   Icon);
end ChillerBaseDataDefinition;

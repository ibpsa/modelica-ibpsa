within IBPSA.Fluid.Chillers.Data.EuropeanNorm2D;
record Generic "Basic chiller data"
  extends
    IBPSA.Fluid.HeatPumps.ModularReversible.Data.TableData2D.Generic;

  parameter Real tabQEva_flow[:,:]
    "Cooling power table, T in degC, Q_flow in W";
  parameter Real tabLowBou[:,2]
    "Points to define lower boundary for source temperature";
  parameter Boolean use_TEvaOutForOpeEnv=false
    "=true to use evaporator outlet temperature for operational envelope, false for inlet";
  parameter Boolean use_TConOutForOpeEnv=false
    "=true to use condenser outlet temperature for operational envelope, false for inlet";
  annotation (Documentation(info="<html>
  
  <h4>Overview</h4>
<p>
  Base data definition used in the chiller model.
</p>
<p>
  Extends <a href=\"modelica://IBPSA.Fluid.HeatPumps.ModularReversible.Data.TableData2D.Generic\">
  IBPSA.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.EuropeanNorm2DData.RefrigerantCycle2DBaseDataDefinition</a> 
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
end Generic;

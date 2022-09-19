within IBPSA.Fluid.Chillers.BlackBoxData.EuropeanNorm2DData;
record ChillerBaseDataDefinition "Basic chiller data"
    extends
    IBPSA.Fluid.HeatPumps.BlackBoxData.EuropeanNorm2DData.HeatPumpBaseDataDefinition(
                                                                tableQCon_flow = tableQdot_eva);

  parameter Real tableQdot_eva[:,:] "Cooling power table; T in degC; Q_flow in W";

  annotation (Documentation(info="<html><p>
  Base data definition extending from the <a href=
  \"modelica://IBPSA.Fluid.HeatPumps.BlackBoxData.EuropeanNorm2DData.HeatPumpBaseDataDefinition\">IBPSA.Fluid.HeatPumps.BlackBoxData.EuropeanNorm2DData.HeatPumpBaseDataDefinition</a>,
  the parameters documentation is matched for a chiller. As a result,
  <code>tableQdot_eva</code>
  corresponds to the cooling capacity on the evaporator side of the
  chiller. Furthermore, the values of the tables depend on the
  condenser inlet temperature (defined in first row) and the evaporator
  outlet temperature (defined in first column) in W.
</p>
<p>
  The nominal mass flow rate in the condenser and evaporator are also
  defined as parameters.
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

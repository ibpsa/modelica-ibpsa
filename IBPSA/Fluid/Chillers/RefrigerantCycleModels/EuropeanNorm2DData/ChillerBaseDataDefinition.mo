within IBPSA.Fluid.Chillers.RefrigerantCycleModels.EuropeanNorm2DData;
record ChillerBaseDataDefinition "Basic chiller data"
  extends
    IBPSA.Fluid.HeatPumps.RefrigerantCycleModels.EuropeanNorm2DData.RefrigerantCycle2DBaseDataDefinition(
     tableQCon_flow=tableQEva_flow);

  parameter Real tableQEva_flow[:,:]
    "Cooling power table; T in degC; Q_flow in W";

  annotation (Documentation(info="<html><p>
  Base data definition extending from the <a href=
  \"modelica://IBPSA.Fluid.HeatPumps.RefrigerantCycleModels.EuropeanNorm2DData.RefrigerantCycle2DBaseDataDefinition\">
  IBPSA.Fluid.HeatPumps.RefrigerantCycleModels.EuropeanNorm2DData.RefrigerantCycle2DBaseDataDefinition</a>,
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

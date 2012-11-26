within IDEAS.Thermal.Components.Production.VerticalGroundHeatExchanger.AdaptedFluid;
connector FlowPort "conector flow port. Based on the library"
  parameter Medium medium "Medium in the connector";
  Modelica.SIunits.Pressure p "Pressure of the port";
  flow Modelica.SIunits.MassFlowRate m_flow(start=0.64) "The massflowrate";
  Modelica.SIunits.SpecificEnthalpy h "The specific enthalyp";
  flow Modelica.SIunits.EnthalpyFlowRate H_flow(start=77000)
    "enthalyp flow rate";
annotation (Documentation(info="<HTML>
Basic definition of the connector.<br>
<b>Variables:</b>
<ul>
<li>Pressure p</li>
<li>flow MassFlowRate m_flow</li>
<li>Specific Enthalpy h</li>
<li>flow EnthaplyFlowRate H_flow</li>
</ul>
If ports with different media are connected, the simulation is asserted due to the check of parameter.
</HTML>"));
end FlowPort;

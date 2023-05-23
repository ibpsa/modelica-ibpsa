within IBPSA.Fluid.HeatPumps.RefrigerantCycleModels.EuropeanNorm2DData;
record RefrigerantCycle2DBaseDataDefinition
  "Basic data for refrigerant machine according to EN 14511"
    extends Modelica.Icons.Record;
  parameter Real tabPEle[:,:]
    "Electrical power table, T in degC, Q_flow in W";
  parameter Modelica.Units.SI.MassFlowRate mCon_flow_nominal
    "Nominal mass flow rate in condenser";
  parameter Modelica.Units.SI.MassFlowRate mEva_flow_nominal
    "Nominal mass flow rate in evaporator";
  parameter String devIde "Name of the device";
  parameter Boolean use_evaOut
    "=true to use evaporator outlet temperature, false for inlet";
  parameter Boolean use_conOut
    "=true to use condenser outlet temperature, false for inlet";

  annotation (Documentation(info="<html>
<h4>Overview</h4>
<p>Base data definition used in the heat pump model. It defines the table <span style=\"font-family: Courier New;\">table_QCon_flow</span> which gives the condenser heat flow rate and <span style=\"font-family: Courier New;\">table_Pel</span> which gives the electric power consumption of the heat pump. </p>
<p>Both tables define the power values depending on the evaporator temperature (defined in first row) and the condenser temperature (defined in first column) in W. </p>
<p>Depending on the type of the device, either inlet or outlet conditions are used. </p>
<p>The nominal mass flow rate in the condenser and evaporator are also defined as parameters.</p>
<p>The devIde ensures that if data for heating and cooling are required, matching data is used.</p>
</html>",
        revisions="<html><ul>
  <li>
    <i>October 2, 2022</i> by Fabian Wuellhorst:<br/>
    Adjusted based on IPBSA guidelines <a href=
    \"https://github.com/ibpsa/modelica-ibpsa/issues/1576\">#1576</a>)
  </li>
  <li>
    <i>May 7, 2020</i> by Philipp Mehrfeld:<br/>
    Add description of how to calculate m_flows
  </li>
  <li>
    <i>December 10, 2013</i> by Ole Odendahl:<br/>
    Formatted documentation appropriately
  </li>
</ul>
</html>
"),Icon);
end RefrigerantCycle2DBaseDataDefinition;

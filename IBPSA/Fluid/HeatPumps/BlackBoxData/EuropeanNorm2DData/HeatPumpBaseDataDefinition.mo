within IBPSA.Fluid.HeatPumps.BlackBoxData.EuropeanNorm2DData;
record HeatPumpBaseDataDefinition "Basic heat pump data"
    extends Modelica.Icons.Record;
  parameter Real tableQCon_flow[:,:]
    "Heating power table; T in degC; Q_flow in W";
  parameter Real tablePel[:,:]
    "Electrical power table; T in degC; Q_flow in W";
  parameter Modelica.Units.SI.MassFlowRate mCon_flow_nominal
    "Nominal mass flow rate in condenser";
  parameter Modelica.Units.SI.MassFlowRate mEva_flow_nominal
    "Nominal mass flow rate in evaporator";
  parameter Real tableUppBou[:,2]
    "Points to define upper boundary for sink temperature";
  parameter String device_id "Name of the device";
  annotation (Documentation(info="<html>
<p><b>Overview</b></p>
<p>Base data definition used in the heat pump model. It defines the table 
<code>table_Qdot_Co</code> which gives the condenser heat flow rate and 
<code>table_Pel</code> which gives the electric power consumption of 
the heat pump. Both tables define the power values depending on the evaporator 
inlet temperature (defined in first row) and the condenser outlet temperature 
(defined in first column) in W. The nominal mass flow rate in the condenser 
and evaporator are also defined as parameters. </p>
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
end HeatPumpBaseDataDefinition;

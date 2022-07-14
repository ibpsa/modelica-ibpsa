within IBPSA.Fluid.HeatPumps.BlackBoxData.AmericanNom2D;
record HeatPumpBaseDataDefinition "Basic heat pump data"
    extends Modelica.Icons.Record;
  parameter Real tableQCon_flow[:,:]
    "Heating power table; T in degC; Q_flow in W";
  parameter Real tableQEva_flow[:,:]
    "Cooling power table; T in degC; Q_flow in W";
  parameter Real tablePEle[:,:] "Electrical power table; T in degC; Q_flow in W";
  parameter Modelica.Units.SI.MassFlowRate mCon_flow_nominal
    "Nominal mass flow rate in condenser";
  parameter Modelica.Units.SI.MassFlowRate mEva_flow_nominal
    "Nominal mass flow rate in evaporator";
  parameter Real tableUppBou[:,2] "Points to define upper boundary for sink temperature";

  annotation (Documentation(info="<html><h4>
  <span style=\"color: #008000\">Overview</span>
  </h4>Base data definition used in the heat pump model. In heating mode, it defines the
table <span style=\"font-family: Courier New;\">tableQCon_flow</span>
which gives the condenser (indoor coil) heat flow rate and, in cooling mode, it defines the
table <span style=\"font-family: Courier New;\">tableQEva_flow</span>
which gives the evaporator (indoor coil) heat flow rate. For both modes, it defines the table <span style=
\"font-family: Courier New;\">tablePEle</span> which gives the electric power consumption of the heat pump. 
<br><br>
<i>Unlike the European standard</i>, these tables define the power values depending on
the coil <b>inlet</b> temperatures. In heating mode, the data is parameterized by 
evaporator (outdoor coil) inlet temperature (defined in first row) and the condenser (indoor coil) inlet 
temperature (defined in first column) in W. In cooling mode, the data is parameterized by 
condenser (outdoor coil) inlet temperature (defined in first row) and the evaporator (indoor coil) inlet 
temperature (defined in first column) in W. The nominal mass flow rate in the coils are also
defined as parameters.
<h4>
  <span style=\"color: #008000\">Calculation of nominal mass flow
  rates</span>
</h4>
<ul>
  <li>General calculation ṁ = Q̇<sub>nominal</sub> / c<sub>p</sub> /
  ΔT
  </li>
</ul>
</html>",
        revisions="<html><ul>
  <li>
    <i>July 13, 2022</i> by Dre Helmns:<br/>
    Including American standard heat pump data
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
"),Icon,     preferedView="info");
end HeatPumpBaseDataDefinition;

within IDEAS.Fluid.Production.BaseClasses;
record HeatPumpData "Data record for storing data for an on/off heat pump"

  extends Modelica.Icons.Record;

  Modelica.SIunits.Mass mBrine "Fluid content of the evaporator";

  Modelica.SIunits.Mass mFluid "Fluid content of the condensor";

  Modelica.SIunits.MassFlowRate m_flow_nominal_brine
    "Nominal mass flow rate of the brine (evaporator)";
  Modelica.SIunits.MassFlowRate m_flow_nominal_fluid
    "Nominal mass flow rate of the fluid (condensor)";

  Modelica.SIunits.Pressure dp_nominal_brine
    "Nominal pressure drop of the evaporator";
  Modelica.SIunits.Pressure dp_nominal_fluid
    "Nominal pressure drop of the condensor";

  Modelica.SIunits.ThermalConductance G
    "Thermal conductivity between the evaporator and the environment";

  annotation (Documentation(revisions="<html>
<ul>
<li>March 2014 by Filip Jorissen:<br/> 
Initial version
</li>
</ul>
</html>"));
end HeatPumpData;

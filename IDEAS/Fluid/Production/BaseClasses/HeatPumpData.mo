within IDEAS.Fluid.Production.BaseClasses;
record HeatPumpData "Data record for storing data for an on/off heat pump"

  extends Modelica.Icons.Record;

  Modelica.SIunits.Mass mBrine "Fluid content of the evaporator";

  Modelica.SIunits.Mass mFluid "Fluid content of the condensor";

  Modelica.SIunits.MassFlowRate m_flow_nominal_brine
    "Mass flow rate of the brine (evaporator) for calculation of the pressure drop";
  Modelica.SIunits.MassFlowRate m_flow_nominal_fluid
    "Mass flow rate of the fluid (condensor) for calculation of the pressure drop";

  Modelica.SIunits.Pressure dp_nominal_brine
    "Pressure drop of the evaporator at nominal mass flow rate";
  Modelica.SIunits.Pressure dp_nominal_fluid
    "Pressure drop of the condensor at nominal mass flow rate";

  Modelica.SIunits.ThermalConductance G
    "Thermal conductivity between the evaporator and the environment";
  Modelica.SIunits.Power P_the_nominal "nominal thermal power of the heat pump";

  Modelica.SIunits.Temperature T_evap_min = 273.15
    "Temperature protection threshold evaporator";
  Modelica.SIunits.Temperature T_cond_max = 273.15 + 60
    "Temperature protection threshold condensor";

  annotation (Documentation(revisions="<html>
<ul>
<li>March 2014 by Filip Jorissen:<br/> 
Initial version
</li>
</ul>
</html>"));
end HeatPumpData;

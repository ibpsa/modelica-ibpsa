within IDEAS.Thermal.Components.Production.BaseClasses;
model IdealHeatSource
  "Ideal heat source for the dynamic heater model.  No losses, no interpolation"
  import IDEAS;

  /*
Ideal heater, will always make sure to reach the setpoint
  
  */
//protected
  parameter Thermal.Data.Interfaces.Medium medium=Data.Media.Water()
    "Medium in the component";

  Modelica.SIunits.Power QAsked(start=0);
  parameter Modelica.SIunits.ThermalConductance UALoss
    "UA of heat losses of HP to environment";
  parameter Modelica.SIunits.Power QDesign "Design heat load";
  final parameter Modelica.SIunits.Power QNom=QDesign
    "The power at nominal conditions (50/30) taking into account beta factor and power loss fraction";

public
  Modelica.SIunits.Power PFuel "Resulting fuel consumption";
  Real modulation(min=0, max=1) "Current modulation percentage";
  input Modelica.SIunits.Temperature THxIn "Condensor temperature";
  input Modelica.SIunits.Temperature TBoilerSet
    "Condensor setpoint temperature.  Not always possible to reach it";
  input Modelica.SIunits.MassFlowRate m_flowHx "Condensor mass flow rate";
  input Modelica.SIunits.Temperature TEnvironment
    "Temperature of environment for heat losses";

protected
  Real kgps2lph = 3600 / medium.rho * 1000 "Conversion from kg/s to l/h";

  Modelica.SIunits.HeatFlowRate QLossesToCompensate "Environment losses";
public
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort
    "heatPort connection to water in condensor"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));

equation
  QAsked = max(0, m_flowHx * medium.cp * (TBoilerSet - THxIn));
  modulation = 1;

  // compensation of heat losses (only when the hp is operating)
  QLossesToCompensate = if noEvent(QAsked > 0) then UALoss * (heatPort.T-TEnvironment) else 0;

  heatPort.Q_flow = - QAsked - QLossesToCompensate;
  PFuel = - heatPort.Q_flow;

  annotation (Diagram(graphics),
              Diagram(graphics));
end IdealHeatSource;

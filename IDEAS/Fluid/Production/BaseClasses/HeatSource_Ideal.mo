within IDEAS.Fluid.Production.BaseClasses;
model HeatSource_Ideal
  "Ideal heat source for the dynamic heater model.  No losses, no interpolation"

  //protected
  parameter Thermal.Data.Interfaces.Medium medium=Thermal.Data.Media.Water()
    "Medium in the component";

  Modelica.SIunits.Power QAsked(start=0);
  parameter Modelica.SIunits.ThermalConductance UALoss
    "UA of heat losses of HP to environment";

public
  Modelica.SIunits.Power PFuel "Resulting fuel consumption";

  input Modelica.SIunits.Temperature THxIn "Condensor temperature";
  input Modelica.SIunits.Temperature TBoilerSet
    "Condensor setpoint temperature.  Not always possible to reach it";
  input Modelica.SIunits.MassFlowRate m_flowHx "Condensor mass flow rate";
  input Modelica.SIunits.Temperature TEnvironment
    "Temperature of environment for heat losses";

protected
  Real kgps2lph=3600/medium.rho*1000 "Conversion from kg/s to l/h";

  Modelica.SIunits.HeatFlowRate QLossesToCompensate "Environment losses";
public
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort
    "heatPort connection to water in condensor"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));

equation
  QAsked = max(0, m_flowHx*medium.cp*(TBoilerSet - THxIn));

  // compensation of heat losses (only when the hp is operating)
  QLossesToCompensate = if noEvent(QAsked > 0) then UALoss*(heatPort.T -
    TEnvironment) else 0;

  heatPort.Q_flow = -QAsked - QLossesToCompensate;
  PFuel = -heatPort.Q_flow;

  annotation (Diagram(graphics), Documentation(info="<html>
<p>Heat source to be coupled to a <a href=\"modelica://IDEAS.Thermal.Components.Production.Interfaces.PartialDynamicHeaterWithLosses\">PartialDynamicHeaterWithLosses</a> in order to form an ideal heater.  See the documentation of the <a href=\"modelica://IDEAS.Thermal.Components.Production.IdealHeater\">IdealHeater</a> for more details.</p>
</html>"));
end HeatSource_Ideal;

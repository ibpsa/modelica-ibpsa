within IDEAS.Electric.Batteries;
model Battery
  extends Modelica.Blocks.Interfaces.BlockIcon;

  // Inputs and Outputs
  Modelica.Blocks.Interfaces.RealInput PIn
    annotation (Placement(transformation(extent={{-120,10},{-80,50}})));

  Modelica.Blocks.Interfaces.RealOutput SoC_out annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=180,
        origin={-100,-30})));
  Modelica.SIunits.Power P;

  // Parameters
protected
  parameter Modelica.SIunits.Efficiency eta_out=1;
  parameter Modelica.SIunits.Efficiency eta_in=1;
  parameter Modelica.SIunits.Efficiency eta_d=1;
  parameter Modelica.SIunits.Efficiency eta_c=1;
  parameter Modelica.SIunits.Efficiency delta_sd;
  parameter Modelica.SIunits.Efficiency SoC_start;
  parameter Modelica.SIunits.Conversions.NonSIunits.Energy_kWh EBat;

  // Variables
public
  Modelica.SIunits.Conversions.NonSIunits.Energy_kWh EExch;
  // Energy exchange vector [kW.h]
  Modelica.SIunits.Efficiency SoC(start=SoC_start);
  // State of Charge of battery capacity in [%/100]
  Modelica.SIunits.Efficiency SoCdelta;
  // Change in SOC in time interval

equation
  P = PIn;

  /* Efficiencies of battery */
  // Discharging batteries
  if noEvent(P >= 0) then
    EExch = P/(eta_out*eta_d*3600000);
    // Charging batteries
  else
    //if noEvent(P < 0) then
    EExch = P*(eta_in*eta_c)/3600000;
  end if;

  SoCdelta = -EExch/EBat;
  der(SoC) = SoCdelta - delta_sd;

  SoC_out = SoC;

  annotation (
    Placement(transformation(extent={{-120,-20},{-80,20}})),
    Diagram(graphics),
    Icon(graphics),
    defaultComponentName="battery",
    defaultComponentPrefixes="inner");
end Battery;

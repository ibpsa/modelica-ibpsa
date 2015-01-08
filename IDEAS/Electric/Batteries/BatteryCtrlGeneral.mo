within IDEAS.Electric.Batteries;
model BatteryCtrlGeneral
  /*
Surplus of PV-production to batteries, and discharging if the PV-production is not enough
 
Remark: should be working; only 1 phase!*/
  extends Modelica.Blocks.Interfaces.BlockIcon;

protected
  parameter Integer numPha=1
    "1 or 3, just indicates if it is a single or 3 phase battery system";

  // Inputs and outputs
public
  Modelica.Blocks.Interfaces.RealOutput PInit annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={100,30})));
  Modelica.Blocks.Interfaces.RealInput SoC annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=180,
        origin={100,-30})));
  Modelica.Blocks.Interfaces.RealOutput PFinal annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=180,
        origin={-100,30})));
  Modelica.Blocks.Interfaces.RealOutput QFinal annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=180,
        origin={-100,-30})));

  // Parameters battery
  parameter Modelica.SIunits.Efficiency DOD_max=0.8;
  parameter Modelica.SIunits.Conversions.NonSIunits.Energy_kWh EBat=1;
  // Total battery capacity in [kW.h]
  parameter Modelica.SIunits.Efficiency eta_out=1;
  parameter Modelica.SIunits.Efficiency eta_in=1;
  parameter Modelica.SIunits.Efficiency eta_d=1;
  parameter Modelica.SIunits.Efficiency eta_c=1;
  parameter Real e_c=1;
  parameter Real e_d=1;

  // Maximum powers
  parameter Modelica.SIunits.Power PMax=4600*numPha;
  // Max. charging power [W], limited by grid connection
  parameter Modelica.SIunits.Power PCharge=min(PMax, (EBat*1000*e_c));
  // Max. charging power [W], limited by battery type
  parameter Modelica.SIunits.Power PDischarge=min(PMax, (EBat*1000*e_d));
  // Max. discharging power [W], limited by battery type

  // Variables
  Modelica.SIunits.Power P;
  // Net power = difference Ppv and Phouseholds
  Modelica.SIunits.Power PBat;
  //Modelica.SIunits.Power P_Bat_limit;

equation
  // Limiting powers when battery almost full/empty
  // Discharging batteries
  if noEvent(P >= 0) then
    PBat = if noEvent(((SoC - (1 - DOD_max))*EBat) < (P/(eta_out*eta_d*3600000)))
       then ((SoC - (1 - DOD_max))*EBat*3600000) else min(P, PDischarge);
    // Charging batteries
  else
    //if noEvent(P < 0) then
    PBat = if noEvent(((1 - SoC)*EBat) < (abs(P)*eta_in*eta_c/3600000)) then ((
      SoC - 1)*EBat*3600000) else max(P, -PCharge);
  end if;

  PFinal = -PBat;
  QFinal = 0;
  PInit = PBat;

  annotation (Diagram(graphics));
end BatteryCtrlGeneral;

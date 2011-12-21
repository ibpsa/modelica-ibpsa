within IDEAS.Thermal.Control;
partial model PartialHPControl_SepDHW
  "Basis of the heat Pump control algorithm"

  /* 
  This partial class contains the temperature control algorithm. It has to be extended
  in order to be complete controller.  
  

  */

  //////////////////////////////////////////////////////////////////////////////////
  // Heating tank
  parameter Boolean heating = true "if true, the system has to foresee heating";
  input Modelica.SIunits.Temperature TTankTopHeating
    "Top (or near top) tank temperature";
  input Modelica.SIunits.Temperature TTankBotHeating
    "Bottom (or near bottom) tank temperature";

  Modelica.SIunits.Temperature TBotSetHeating(start=283.15)
    "Bottom temperature setpoint";
  Modelica.SIunits.Temperature TTopSetHeating(start=283.15)
    "Top temperature setpoint";
  Modelica.SIunits.Temperature TBotEmptyHeating(start=283.15)
    "Temperature in bottom corresponding to SOC = 0";

  Real SOCHeating(start = 0);
  output Real onOffHeating(min=0, max=1, start=0) "On/off signal as Real";

  ////////////////////////////////////////////////////////////////////////////////////
  // DHW tank
  parameter Boolean DHW = true "if true, the system has to foresee DHW";
  parameter Modelica.SIunits.Temperature TDHWSet=0
    "Setpoint temperature for the DHW outlet";
  parameter Modelica.SIunits.Temperature TColdWaterNom=273.15 + 10
    "Nominal cold water temperature";

  input Modelica.SIunits.Temperature TTankTopDHW
    "Top (or near top) tank temperature";
  input Modelica.SIunits.Temperature TTankBotDHW
    "Bottom (or near bottom) tank temperature";

  Modelica.SIunits.Temperature TBotSetDHW(start=283.15)
    "Bottom temperature setpoint";
  Modelica.SIunits.Temperature TTopSetDHW(start=283.15)
    "Top temperature setpoint";
  Modelica.SIunits.Temperature TBotEmptyDHW(start=283.15)
    "Temperature in bottom corresponding to SOC = 0";

  Real SOCDHW(start = 0);
  output Real onOffDHW(min=0, max=1, start=0) "On/off signal as Real";

  ////////////////////////////////////////////////////////////////////////////////////
  // General
  output Modelica.SIunits.Temperature THPSet(start=283.15)
    "Heat pump set temperature";

  parameter Modelica.SIunits.TemperatureDifference dTSupRetNom=10
    "Nominal difference between supply and return water temperatures";
  parameter Modelica.SIunits.TemperatureDifference dTSafetyTop=3
    "Safety margin on top temperature setpoint";
  parameter Modelica.SIunits.TemperatureDifference dTSafetyBot=3
    "Safety margin on bottom temperature setpoint";
  parameter Modelica.SIunits.TemperatureDifference dTHPTankSet(min=0)=2
    "Difference between tank setpoint and heat pump setpoint";

  HeatingCurve heatingCurve(
    redeclare Commons.Math.MovingAverage filter(period=heatingCurve.timeFilter),
    timeFilter = 43200,
    dTOutHeaBal = 0,
    TSup_nominal = 273.15+45,
    TRet_nominal = 273.15+35,
    TRoo_nominal = 273.15+21,
    TOut_nominal = 273.15-8)
    annotation (Placement(transformation(extent={{-54,44},{-34,64}})));
  outer Commons.SimInfoManager sim
    annotation (Placement(transformation(extent={{24,50},{44,70}})));
initial equation
  der(onOffHeating) = 0;
  der(onOffDHW) = 0;

equation
  heatingCurve.TOut = sim.Te;

  if heating then
    TBotEmptyHeating = TTopSetHeating - dTSupRetNom;
    //tankSOC is intentionally computed based only on 2 temperature sensors for practical reasons.  It is computed
    // with regard to TTopSet and TBotSet and a reference temperature (TBotEmpty)
    SOCHeating=0.5*(TTankBotHeating-TBotEmptyHeating)/(TBotSetHeating+dTSafetyBot-TBotEmptyHeating)+0.5*(TTankTopHeating-(TTopSetHeating+dTSafetyTop))/(dTSupRetNom-dTSafetyTop);
  else
    TBotEmptyHeating = 0;
    SOCHeating = 0;
  end if;

    if DHW then
    TBotEmptyDHW = TTopSetDHW - dTSupRetNom;
    //tankSOC is intentionally computed based only on 2 temperature sensors for practical reasons.  It is computed
    // with regard to TTopSet and TBotSet and a reference temperature (TBotEmpty)
    SOCDHW=0.5*(TTankBotDHW-TBotEmptyDHW)/(TBotSetDHW+dTSafetyBot-TBotEmptyDHW)+0.5*(TTankTopDHW-(TTopSetDHW+dTSafetyTop))/(dTSupRetNom-dTSafetyTop);
  else
    TBotEmptyDHW = 0;
    SOCDHW = 0;
  end if;
  annotation(Icon(Bitmap(extent=[-90,90; 90,-90], name="Control.tif")),
      Diagram(graphics));
end PartialHPControl_SepDHW;

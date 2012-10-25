within IDEAS.Thermal.Components.Production.Auxiliaries;
model HP_BW_CondensationPower_Losses
  "Brine/Water, Computation of theoretical condensation power of the refrigerant based on interpolation data.  Takes into account losses of the heat pump to the environment"

  /*
  This model is based on catalogue data from Viessmann for the vitocal 300-G, type BW/BWC 108 (8kW nominal power) 
  
  First, the thermal power and electricity consumption are interpolated for the 
  evaporator and condensing set temperature.  The results
  are rescaled to the nominal power of the modelled heatpump (with QNom/QNom_data).
    
  The heat pump is an on/off heat pump, and a hysteresis is foreseen around the condensor set temperature
  for on/off switching 
   
  ATTENTION
  This model takes into account environmental heat losses of the heat pump (at condensor side).
  In order to keep the same nominal COP's during operation of the heat pump, these heat losses are added
  to the computed power.  Therefore, the heat losses are only really 'losses' when the heat pump is 
  NOT operating. 
  
  The COP is calculated as the heat delivered to the condensor divided by the electrical consumption (P). 
  
  */
//protected
  parameter Thermal.Data.Interfaces.Medium medium=Data.Media.Water()
    "Medium in the condensor";
  parameter Thermal.Data.Interfaces.Medium mediumEvap=Data.Media.Water()
    "Medium in the evaporator";
  final parameter Modelica.SIunits.Power QNomRef=8270
    "Nominal power of the Viesmann Vitocal 300-G BW/BWC 108.  See datafile";
  parameter Modelica.SIunits.ThermalConductance UALoss
    "UA of heat losses of HP to environment";
  final parameter Modelica.SIunits.Power QNom=QDesign*betaFactor/
      fraLosDesNom
    "The power at nominal conditions (2/35) taking into account beta factor and power loss fraction";

public
  parameter Real fraLosDesNom = 1
    "Ratio of power at design conditions over power at 0/35degC";
  parameter Real betaFactor = 0.8
    "Relative sizing compared to design heat load";
  parameter Modelica.SIunits.Power QDesign=QNomRef "Design heat load";
  Modelica.SIunits.Power PEl "Resulting electrical power";
  Modelica.SIunits.Temperature TEvaporator "Evaporator temperature";
  input Modelica.SIunits.Temperature TCondensor_in "Condensor temperature";
  input Modelica.SIunits.Temperature TCondensor_set
    "Condensor setpoint temperature.  Not always possible to reach it";
  input Modelica.SIunits.MassFlowRate m_flowCondensor
    "Condensor mass flow rate";
  input Modelica.SIunits.Temperature TEnvironment
    "Temperature of environment for heat losses";
  Real modulation(min=0, max=100)
    "Current modulation percentage, has no function in this on/off heat pump";

protected
  Modelica.Blocks.Tables.CombiTable2D P100(
      smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative, table=[0,
        0,15; 35,1.8,1.99; 45,2.2,2.41; 55,2.72,2.98])
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  Modelica.Blocks.Tables.CombiTable2D Q100(
     smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative, table=[0,
        0,15; 35,8.27,12.25; 45,7.75,11.63; 55,7.38,11.07])
    annotation (Placement(transformation(extent={{20,60},{40,80}})));
  Modelica.Blocks.Tables.CombiTable2D evap100(smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
      table=[0,0,15; 35,6.6,10.73; 45,5.82,9.76; 55,5.06,8.63])
    "Evaporator power, in kW"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));

  Modelica.SIunits.HeatFlowRate QLossesToCompensate "Environment losses";
  Modelica.SIunits.HeatFlowRate QCond;
  Modelica.SIunits.HeatFlowRate QEvap;
  Modelica.SIunits.Power PComp;
public
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort
    "heatPort connection to water in condensor"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  IDEAS.BaseClasses.Control.Hyst_NoEvent onOff(
     uLow = -2.5,
    uHigh = 2.5,
    y(
    start = 0),
    enableRelease=true) "on-off, based on modulationInit"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));

  Thermal.Components.Interfaces.FlowPort_a flowPort_a(medium=mediumEvap)
    annotation (Placement(transformation(extent={{-50,-110},{-30,-90}})));
  Thermal.Components.Interfaces.FlowPort_b flowPort_b(medium=mediumEvap)
    annotation (Placement(transformation(extent={{10,-110},{30,-90}})));
  IDEAS.Thermal.Components.BaseClasses.Pipe_HeatPort
                                            evaporator(
    medium=mediumEvap,
    m=3,
    TInitial=283.15)
    annotation (Placement(transformation(extent={{-24,-46},{-4,-66}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow
    annotation (Placement(transformation(extent={{-46,-34},{-26,-14}})));
equation
  TEvaporator = flowPort_a.h/mediumEvap.cp;
  onOff.u = TCondensor_set-heatPort.T;
  onOff.release = noEvent(if m_flowCondensor > 0 then 1.0 else 0.0);
  //QAsked = m_flowCondensor * medium.cp * (TCondensor_set - TCondensor_in);
  P100.u1 = heatPort.T - 273.15;
  P100.u2 = TEvaporator - 273.15;
  Q100.u1 = heatPort.T - 273.15;
  Q100.u2 = TEvaporator - 273.15;
  evap100.u1 = heatPort.T - 273.15;
  evap100.u2 = TEvaporator - 273.15;

  // all these are in W

  QCond = Q100.y * QNom/QNomRef * 1000;
  PComp = P100.y * QNom/QNomRef * 1000;
  QEvap = evap100.y * QNom/QNomRef * 1000;

  // compensation of heat losses (only when the hp is operating)
  QLossesToCompensate = onOff.y * UALoss * (heatPort.T-TEnvironment);
  modulation = onOff.y * 100;
  heatPort.Q_flow = -onOff.y * QCond - QLossesToCompensate;
  PEl = onOff.y * PComp;
  prescribedHeatFlow.Q_flow = - onOff.y * QEvap;

  connect(flowPort_a,evaporator. flowPort_a) annotation (Line(
      points={{-40,-100},{-42,-100},{-42,-56},{-24,-56}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(evaporator.flowPort_b, flowPort_b) annotation (Line(
      points={{-4,-56},{20,-56},{20,-100}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(prescribedHeatFlow.port, evaporator.heatPort) annotation (Line(
      points={{-26,-24},{-14,-24},{-14,-46}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (Diagram(graphics),
              Diagram(graphics));
end HP_BW_CondensationPower_Losses;

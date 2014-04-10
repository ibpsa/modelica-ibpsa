within IDEAS.Controls.ControlHeating.Interfaces;
partial model Partial_Ctrl_Heating_TES
  "Partial for a TES based heating control algorithm"

  /* 
  This partial class contains the temperature control algorithm. It has to be extended
  in order to be complete controller.  
  

  input Modelica.SIunits.Temperature TTankTop 
    "Top (or near top) tank temperature";
  input Modelica.SIunits.Temperature TTankBot 
    "Bottom (or near bottom) tank temperature";

  */

  Modelica.SIunits.Temperature TBotSet(start=283.15)
    "Bottom temperature setpoint";
  Modelica.SIunits.Temperature TTopSet(start=283.15) "Top temperature setpoint";
  Modelica.SIunits.Temperature TBotEmpty(start=283.15)
    "Temperature in bottom corresponding to SOC = 0";

  Real SOC(start=0);

  //output SI.Temperature THPSet(start = 283.15) "Heat pump set temperature";
  //output Real onOff(start=0) "onoff signal as Real";

  parameter SI.Temperature TSupNom "Nominal heating curve supply temperature";
  parameter Modelica.SIunits.TemperatureDifference dTSupRetNom=10
    "Nominal difference between supply and return water temperatures";
  parameter Modelica.SIunits.TemperatureDifference dTSafetyTop=3
    "Safety margin on top temperature setpoint" annotation (Evaluate=false);
  parameter Modelica.SIunits.TemperatureDifference dTSafetyBot=dTSafetyTop
    "Safety margin on bottom temperature setpoint";
  parameter Modelica.SIunits.TemperatureDifference dTHPTankSet(min=0) = 2
    "Difference between tank setpoint and heat pump setpoint";

  parameter Boolean DHW=true "if true, the system has to foresee DHW";
  parameter Modelica.SIunits.Temperature TDHWSet=0
    "Setpoint temperature for the DHW outlet";
  parameter Modelica.SIunits.Temperature TColdWaterNom=273.15 + 10
    "Nominal cold water temperature";
  parameter Modelica.SIunits.Time timeFilter=43200
    "Time constant for filter on ambient temperature";

  HeatingCurve heatingCurve(
    timeFilter=timeFilter,
    dTOutHeaBal=0,
    TSup_nominal=TSupNom,
    TRet_nominal=TSupNom - dTSupRetNom,
    TRoo_nominal=273.15 + 21,
    TOut_nominal=273.15 - 8,
    redeclare IDEAS.Utilities.Math.MovingAverage filter(period=timeFilter))
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));
  outer IDEAS.SimInfoManager sim
    annotation (Placement(transformation(extent={{24,50},{44,70}})));
  Modelica.Blocks.Interfaces.RealOutput THPSet(start=283.15)
    "Heat pump set temperature" annotation (Placement(transformation(extent={{
            92,30},{112,50}}), iconTransformation(extent={{92,30},{112,50}})));
  Modelica.Blocks.Interfaces.RealOutput onOff(start=0) "onoff signal as Real"
    annotation (Placement(transformation(extent={{92,-10},{112,10}}),
        iconTransformation(extent={{92,-10},{112,10}})));
  Modelica.Blocks.Interfaces.RealOutput THeaCur "Heating curve setpoint"
    annotation (Placement(transformation(extent={{94,-50},{114,-30}}),
        iconTransformation(extent={{94,-50},{114,-30}})));
  Modelica.Blocks.Interfaces.RealInput TTankTop
    "Top (or near top) tank temperature" annotation (Placement(transformation(
          extent={{-94,30},{-74,50}}), iconTransformation(extent={{-94,30},{-74,
            50}})));
  Modelica.Blocks.Interfaces.RealInput TTankBot
    "Bottom (or near bottom) tank temperature" annotation (Placement(
        transformation(extent={{-94,-10},{-74,10}}), iconTransformation(extent=
            {{-94,-10},{-74,10}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=sim.Te)
    annotation (Placement(transformation(extent={{-60,46},{-40,66}})));
initial equation
  //der(onOff) = 0;

equation

  TBotEmpty = if DHW then TColdWaterNom else TTopSet - dTSupRetNom;
  //tankSOC is intentionally computed based only on 2 temperature sensors for practical reasons.  It is computed
  // with regard to TTopSet and TBotSet and a reference temperature (TBotEmpty)
  SOC = 0.5*(TTankBot - TBotEmpty)/(TBotSet + dTSafetyBot - TBotEmpty) + 0.5*(
    TTankTop - (TTopSet + dTSafetyTop))/(dTSupRetNom - dTSafetyTop);

  connect(realExpression.y, heatingCurve.TOut) annotation (Line(
      points={{-39,56},{-22,56}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Icon(coordinateSystem(extent={{-80,-80},{100,80}}), graphics={
        Rectangle(
          extent={{100,80},{-80,-80}},
          lineColor={100,100,100},
          fillPattern=FillPattern.Solid,
          fillColor={255,255,255}),
        Line(
          points={{20,80},{100,0},{20,-80}},
          color={100,100,100},
          smooth=Smooth.None),
        Text(
          extent={{-60,40},{60,-40}},
          lineColor={100,100,100},
          textString="hp ")}), Diagram(coordinateSystem(extent={{-80,-80},{100,
            80}}, preserveAspectRatio=true), graphics));
end Partial_Ctrl_Heating_TES;

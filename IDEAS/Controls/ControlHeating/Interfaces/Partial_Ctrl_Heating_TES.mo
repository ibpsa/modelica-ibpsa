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
  extends IDEAS.Controls.ControlHeating.Interfaces.Partial_Ctrl_Heating;

 parameter Modelica.SIunits.TemperatureDifference dTSafetyTop=3
    "Safety margin on top temperature setpoint" annotation (Evaluate=false);
  parameter Modelica.SIunits.TemperatureDifference dTSafetyBot=dTSafetyTop
    "Safety margin on bottom temperature setpoint";
  parameter Modelica.SIunits.TemperatureDifference dTHPTankSet(min=0) = 2
    "Difference between tank setpoint and heat pump setpoint";

  parameter Boolean DHW=true "if true, the system has to foresee DHW";
  parameter Modelica.SIunits.Temperature TDHWSet=273.15+60
    "Setpoint temperature for the DHW outlet";
  parameter Modelica.SIunits.Temperature TColdWaterNom=273.15 + 10
    "Nominal tap (cold) water temperature";

  // --- Interface
  Modelica.Blocks.Interfaces.RealOutput onOff(start=0)
    "onoff signal as Real for the charging of the storage tank"
    annotation (Placement(transformation(extent={{94,-70},{114,-50}}),
        iconTransformation(extent={{94,-70},{114,-50}})));
  Modelica.Blocks.Interfaces.RealInput TTankTop
    "Top (or near top) tank temperature" annotation (Placement(transformation(
          extent={{-106,42},{-70,78}}),iconTransformation(extent={{-108,40},{-70,
            78}})));
  Modelica.Blocks.Interfaces.RealInput TTankBot
    "Bottom (or near bottom) tank temperature" annotation (Placement(
        transformation(extent={{-108,-80},{-68,-40}}),
                                                     iconTransformation(extent={{-108,
            -80},{-68,-40}})));

  // --- Variables
  Modelica.Blocks.Sources.RealExpression realExpression(y=sim.Te)
    annotation (Placement(transformation(extent={{-60,46},{-40,66}})));
  Modelica.SIunits.Temperature TBotSet(start=283.15)
    "Bottom temperature setpoint";
  Modelica.SIunits.Temperature TTopSet(start=283.15) "Top temperature setpoint";
  Modelica.SIunits.Temperature TBotEmpty(start=283.15)
    "Temperature in bottom corresponding to SOC = 0";
  Real SOC(start=0);

protected
  Modelica.SIunits.Temperature THPSet;
public
  Modelica.Blocks.Sources.RealExpression realExpression1(y=THPSet)
    annotation (Placement(transformation(extent={{40,30},{60,50}})));
  Modelica.Blocks.Math.Add add2
    annotation (Placement(transformation(extent={{-8,-8},{8,8}},
        rotation=0,
        origin={64,0})));
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
  connect(realExpression1.y, THeaCur) annotation (Line(
      points={{61,40},{104,40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(corHeaCur.y, add2.u1) annotation (Line(
      points={{1,20},{36,20},{36,4.8},{54.4,4.8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(realExpression2.y, add2.u2) annotation (Line(
      points={{16.2,-3},{35.1,-3},{35.1,-4.8},{54.4,-4.8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(add2.y, THeaterSet) annotation (Line(
      points={{72.8,0},{104,0}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Icon(coordinateSystem(extent={{-80,-80},{100,80}},
          preserveAspectRatio=false),                             graphics={
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
            80}}, preserveAspectRatio=false),graphics));
end Partial_Ctrl_Heating_TES;

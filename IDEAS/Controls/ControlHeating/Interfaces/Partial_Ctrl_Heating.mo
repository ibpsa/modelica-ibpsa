within IDEAS.Controls.ControlHeating.Interfaces;
partial model Partial_Ctrl_Heating
  "Partial for a heating control algorithm without TES"

  /* 
  This partial class contains the temperature control algorithm. It has to be extended
  in order to be complete controller.  
  */

  parameter SI.Temperature TSupNom "Nominal heating curve supply temperature";
  parameter Modelica.SIunits.TemperatureDifference dTSupRetNom=10
    "Nominal difference between supply and return water temperatures";
  parameter Modelica.SIunits.TemperatureDifference dTHeaterSet(min=0) = 2
    "Difference between heating curve setpoint and heater setpoint";
  parameter Modelica.SIunits.Time timeFilter=43200
    "Time constant for filter on ambient temperature";

  HeatingCurve heatingCurve(
    timeFilter=timeFilter,
    dTOutHeaBal=0,
    TSup_nominal=TSupNom,
    TRet_nominal=TSupNom - dTSupRetNom,
    TRoo_nominal=273.15 + 21,
    TOut_nominal=273.15 - 8,
    redeclare IDEAS.BaseClasses.Math.MovingAverage filter(period=timeFilter))
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));
  outer IDEAS.SimInfoManager sim
    annotation (Placement(transformation(extent={{24,50},{44,70}})));
  Modelica.Blocks.Interfaces.RealOutput THeaterSet(start=283.15)
    "Heat pump set temperature" annotation (Placement(transformation(extent={{
            94,-10},{114,10}}), iconTransformation(extent={{94,-10},{114,10}})));

  Modelica.Blocks.Interfaces.RealOutput THeaCur "Heating curve setpoint"
    annotation (Placement(transformation(extent={{94,30},{114,50}}),
        iconTransformation(extent={{94,30},{114,50}})));

  Modelica.Blocks.Sources.RealExpression realExpression(y=sim.Te)
    annotation (Placement(transformation(extent={{-60,46},{-40,66}})));

equation
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
            80}}, preserveAspectRatio=false), graphics));
end Partial_Ctrl_Heating;

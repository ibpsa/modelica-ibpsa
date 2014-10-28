within IDEAS.Fluid.Production;
model HeatPumpTset "Heat pump using a temperature setpoint"
  extends IDEAS.Fluid.Production.BaseClasses.PartialHeatPump(redeclare replaceable parameter
      IDEAS.Fluid.Production.BaseClasses.OnOffHeatPumpData heatPumpData constrainedby
      IDEAS.Fluid.Production.BaseClasses.OnOffHeatPumpData);

  Modelica.Blocks.Sources.RealExpression realExpression4(y=Tset - condensor.heatPort.T)
    annotation (Placement(transformation(extent={{-76,-44},{-34,-64}})));
  Modelica.Blocks.Interfaces.RealInput Tset "Condensor temperature setpoint"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={40,108}), iconTransformation(
        extent={{-12,-12},{12,12}},
        rotation=270,
        origin={-50,100})));

  Modelica.Blocks.Logical.Hysteresis hysteresis(uLow=uLow, uHigh=uHigh)
    annotation (Placement(transformation(extent={{-22,-64},{-2,-44}})));
  parameter Real uLow=-2.5
    "Lower bound of the hysteresis in the tempeature controller";
  parameter Real uHigh=2.5
    "Upper bound of the hysteresis in the tempeature controller";
equation
  compressorOn = on_internal and tempProtection.y;

  connect(copTable.u2,powerTable. u2) annotation (Line(
      points={{-62,58},{-82,58},{-82,84},{-62,84}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(powerTable.u1, T_in_cond.T) annotation (Line(
      points={{-62,96},{-94,96},{-94,80},{16,80},{16,56},{78,56},{78,-29}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(copTable.u1, T_in_cond.T) annotation (Line(
      points={{-62,70},{-94,70},{-94,80},{16,80},{16,56},{78,56},{78,-29}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(T_in_evap.T,powerTable. u2) annotation (Line(
      points={{-82,51},{-82,84},{-62,84}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(realExpression4.y, hysteresis.u) annotation (Line(
      points={{-31.9,-54},{-24,-54}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics));
end HeatPumpTset;

within IDEAS.Fluid.Production;
model HeatPumpTset "Heat pump using a temperature setpoint"
  extends IDEAS.Fluid.Production.BaseClasses.PartialHeatPump(redeclare replaceable parameter
      IDEAS.Fluid.Production.BaseClasses.OnOffHeatPumpData heatPumpData constrainedby
      IDEAS.Fluid.Production.BaseClasses.OnOffHeatPumpData);

  Modelica.Blocks.Sources.RealExpression realExpression4(y=Tset - condensor.heatPort.T)
    annotation (Placement(transformation(extent={{-70,-26},{-28,-46}})));
  Modelica.Blocks.Interfaces.RealInput Tset "Condensor temperature setpoint"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={40,108}), iconTransformation(
        extent={{-12,-12},{12,12}},
        rotation=270,
        origin={-50,100})));

  Modelica.Blocks.Logical.Hysteresis hysteresis(uLow=uLow, uHigh=uHigh)
    annotation (Placement(transformation(extent={{-16,-46},{4,-26}})));
  parameter Real uLow=-2.5
    "Lower bound of the hysteresis in the tempeature controller";
  parameter Real uHigh=2.5
    "Upper bound of the hysteresis in the tempeature controller";
equation
  compressorOn = on_internal and tempProtection.y and hysteresis.y;

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
      points={{-25.9,-36},{-18,-36}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics),
    Documentation(info="<html>
<p>This model implements a heat pump as described in<a href=\"modelica://IDEAS.Fluid.Production.BaseClasses.PartialHeatPump\"> IDEAS.Fluid.Production.BaseClasses.PartialHeatPump</a>. The heat pump is switched on or off based on a temperature set point.</p>
</html>", revisions="<html>
<ul>
<li>November 2014 by Filip Jorissen:<br/> 
Added documentation
</li>
</ul>
</html>"));
end HeatPumpTset;

within IDEAS.Fluid.Production;
model HP_WaterWater_OnOff
  "A water (or brine) to water heat pump with on/off input"
  extends IDEAS.Fluid.Production.BaseClasses.PartialHeatPump(redeclare replaceable parameter
      IDEAS.Fluid.Production.BaseClasses.HeatPumpData heatPumpData constrainedby
      IDEAS.Fluid.Production.BaseClasses.HeatPumpData);

  // check https://github.com/open-ideas/IDEAS/issues/17 for a discussion on why CombiTable2D is used

equation
   compressorOn = on_internal and tempProtection.y;
  connect(copTable.u2, powerTable.u2) annotation (Line(
      points={{-62,58},{-82,58},{-82,84},{-62,84}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(powerTable.u1, T_in_cond.T) annotation (Line(
      points={{-62,96},{-94,96},{-94,80},{16,80},{16,56},{78,56},{78,-49}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(copTable.u1, T_in_cond.T) annotation (Line(
      points={{-62,70},{-94,70},{-94,80},{16,80},{16,56},{78,56},{78,-49}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(T_in_evap.T, powerTable.u2) annotation (Line(
      points={{-82,71},{-82,84},{-62,84}},
      color={0,0,127},
      smooth=Smooth.None));

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Icon(graphics={
        Rectangle(extent={{-60,60},{60,-60}}, lineColor={0,0,255}),
        Line(
          points={{-100,40},{-20,40},{-40,20},{-20,0},{-40,-20},{-20,-40},{-100,
              -40}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{100,40},{20,40},{40,20},{20,0},{40,-20},{20,-40},{100,-40}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{-20,20},{20,20}},
          color={255,0,0},
          smooth=Smooth.None),
        Line(
          points={{10,30},{20,20},{10,10}},
          color={255,0,0},
          smooth=Smooth.None),
        Rectangle(extent={{-100,100},{100,-100}}, lineColor={135,135,135})}),
    Documentation(revisions="<html>
<ul>
<li>November 2014 by Filip Jorissen:<br/> 
Added documentation
</li>
<li>March 2014 by Filip Jorissen:<br/> 
Initial version
</li>
</ul>
</html>", info="<html>
<p>This model implements a heat pump as described in<a href=\"modelica://IDEAS.Fluid.Production.BaseClasses.PartialHeatPump\"> IDEAS.Fluid.Production.BaseClasses.PartialHeatPump</a>. The heat pump can be switching on or off using an external control signal.</p>
</html>"));
end HP_WaterWater_OnOff;

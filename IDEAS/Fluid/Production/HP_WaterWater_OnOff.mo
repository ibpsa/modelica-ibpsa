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
      points={{-76,-12},{-82,-12},{-82,14},{-76,14}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(T_in_evap.T, powerTable.u2) annotation (Line(
      points={{-80,49},{-80,14},{-76,14}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(T_out_cond.T, powerTable.u1) annotation (Line(
      points={{-80,-49},{2,-49},{2,76},{-74,76},{-74,26},{-76,26}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(copTable.u1, powerTable.u1) annotation (Line(
      points={{-76,0},{-74,0},{-74,26},{-76,26}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Icon(graphics={
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

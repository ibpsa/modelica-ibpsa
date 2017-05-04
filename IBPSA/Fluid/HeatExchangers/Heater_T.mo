within IBPSA.Fluid.HeatExchangers;
model Heater_T "Heater with prescribed outlet temperature"
  extends IBPSA.Fluid.HeatExchangers.PrescribedOutlet(
    final Q_flow_maxCool = 0);
    annotation (
    defaultComponentName="hea",
Documentation(info="<html>
<p>
Model for an ideal heater with a prescribed outlet temperature.
</p>
<p>
This model forces the outlet temperature at <code>port_b</code> to be no lower than the temperature
of the input signal <code>TSet</code>, subject to optional limits on the
capacity.
By default, the model has unlimited capacity.
</p>
<p>
The output signal <code>Q_flow</code> is the heat added
to the medium if the flow rate is from <code>port_a</code> to <code>port_b</code>.
If the flow is reversed, then <code>Q_flow=0</code>.
</p>
<p>
The outlet conditions at <code>port_a</code> are not affected by this model.
</p>
<p>
If the parameter <code>energyDynamics</code> is not equal to
<code>Modelica.Fluid.Types.Dynamics.SteadyState</code>,
the component models the dynamic response using a first order differential equation.
The time constant of the component is equal to the parameter <code>tau</code>.
This time constant is adjusted based on the mass flow rate using
</p>
<p align=\"center\" style=\"font-style:italic;\">
&tau;<sub>eff</sub> = &tau; |m&#775;| &frasl; m&#775;<sub>nom</sub>
</p>
<p>
where
<i>&tau;<sub>eff</sub></i> is the effective time constant for the given mass flow rate
<i>m&#775;</i> and
<i>&tau;</i> is the time constant at the nominal mass flow rate
<i>m&#775;<sub>nom</sub></i>.
This type of dynamics is equal to the dynamics that a completely mixed
control volume would have.
</p>
<p>
Optionally, this model can have a flow resistance.
If no flow resistance is requested, set <code>dp_nominal=0</code>.
</p>
<p>
For a similar model that is a sensible cooling device, use
<a href=\"modelica://IBPSA.Fluid.HeatExchangers.SensibleCooler_T\">
IBPSA.Fluid.HeatExchangers.SensibleCooler_T</a>.
For a model that uses a control signal <i>u &isin; [0, 1]</i> and multiplies
this with the nominal heating or cooling power, use
<a href=\"modelica://IBPSA.Fluid.HeatExchangers.HeaterCooler_u\">
IBPSA.Fluid.HeatExchangers.HeaterCooler_u</a>

</p>
<h4>Limitations</h4>
<p>
If the flow is from <code>port_b</code> to <code>port_a</code>,
then the enthalpy of the medium is not affected by this model.
</p>
<p>
This model does not affect the humidity of the air. Therefore,
if used to cool air below the dew point temperature, the water mass fraction
will not change.
</p>
<h4>Validation</h4>
<p>
The model has been validated against the analytical solution in
the examples
<a href=\"modelica://IBPSA.Fluid.HeatExchangers.Validation.PrescribedOutlet\">
IBPSA.Fluid.HeatExchangers.Validation.PrescribedOutlet</a>
and
<a href=\"modelica://IBPSA.Fluid.HeatExchangers.Validation.PrescribedOutlet_dynamic\">
IBPSA.Fluid.HeatExchangers.Validation.PrescribedOutlet_dynamic</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
May 3, 2017, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(graphics={Text(
          extent={{14,-8},{58,-54}},
          lineColor={255,255,255},
          textString="+")}));
end Heater_T;

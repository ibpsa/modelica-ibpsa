within Annex60.Fluid.Sensors;
model SpecificEnthalpyTwoPort "Ideal two port sensor for the specific enthalpy"
  extends Annex60.Fluid.Sensors.BaseClasses.PartialDynamicFlowSensor;
  extends Modelica.Icons.RotationalSensor;
  parameter Modelica.SIunits.SpecificEnthalpy h_out_start=
    Medium.specificEnthalpy_pTX(p=Medium.p_default, T=Medium.T_default, X=Medium.X_default)
    "Initial or guess value of output (= state)"
    annotation (Dialog(group="Initialization"));
  Modelica.Blocks.Interfaces.RealOutput h_out(final quantity="SpecificEnergy",
                                              final unit="J/kg",
                                              start=h_out_start)
    "Specific enthalpy of the passing fluid"
    annotation (Placement(transformation(
        origin={0,110},
        extent={{10,-10},{-10,10}},
        rotation=270)));
protected
  Modelica.SIunits.SpecificEnthalpy hMed_out(start=h_out_start)
    "Medium enthalpy to which the sensor is exposed";
initial equation
  if dynamic then
    if initType == Modelica.Blocks.Types.Init.SteadyState then
      der(h_out) = 0;
    elseif initType == Modelica.Blocks.Types.Init.InitialState or
           initType == Modelica.Blocks.Types.Init.InitialOutput then
      h_out = h_out_start;
    end if;
  end if;
equation
  if allowFlowReversal then
    hMed_out = Modelica.Fluid.Utilities.regStep(
                 x=port_a.m_flow,
                 y1=Medium.specificEnthalpy(
                      Medium.setState_pTX(
                        p=port_b.p,
                        T=port_b.T_outflow,
                        X=port_b.Xi_outflow)),
                 y2=Medium.specificEnthalpy(
                      Medium.setState_pTX(
                        p=port_a.p,
                        T=port_a.T_outflow,
                        X=port_a.Xi_outflow)),
                 x_small=m_flow_small);
  else
    hMed_out = Medium.specificEnthalpy(
                      Medium.setState_pTX(
                        p=port_b.p,
                        T=port_b.T_outflow,
                        X=port_b.Xi_outflow));
  end if;
  // Output signal of sensor
  if dynamic then
    der(h_out) = (hMed_out-h_out)*k/tau;
  else
    h_out = hMed_out;
  end if;
annotation (defaultComponentName="senSpeEnt",
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={
        Text(
          extent={{102,120},{0,90}},
          lineColor={0,0,0},
          textString="h"),
        Line(points={{0,100},{0,70}}, color={0,0,127}),
        Line(points={{-100,0},{-70,0}}, color={0,128,255}),
        Line(points={{70,0},{100,0}}, color={0,128,255})}),
  Documentation(info="<html>
<p>
This model outputs the specific enthalpy of a passing fluid.
The sensor is ideal, i.e. it does not influence the fluid.
If the parameter <code>tau</code> is non-zero, then its output
is computed using a first order differential equation.
Setting <code>tau=0</code> is <i>not</i> recommend. See
<a href=\"modelica://Annex60.Fluid.Sensors.UsersGuide\">
Annex60.Fluid.Sensors.UsersGuide</a> for an explanation.
</p>
</html>",
revisions="<html>
<ul>
<li>
January 23, 2014, by Michael Wetter:<br/>
Changed fluid port from using <code>h_outflow</code> to <code>T_outflow</code>.
</li>
<li>
June 3, 2011 by Michael Wetter:<br/>
Revised implementation to add dynamics in such a way that
the time constant increases as the mass flow rate tends to zero.
This significantly improves the numerics.
</li>
<li>
September 29, 2009, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end SpecificEnthalpyTwoPort;

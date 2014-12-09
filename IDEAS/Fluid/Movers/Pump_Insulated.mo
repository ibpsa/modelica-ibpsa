within IDEAS.Fluid.Movers;
model Pump_Insulated
  "Prescribed mass flow rate, with UA-value for environmental heat exchange."

   extends IDEAS.Fluid.Movers.Pump;

  parameter SI.ThermalConductance UA "Thermal conductance of the insulation";

  Modelica.Thermal.HeatTransfer.Components.ThermalConductor thermalConductor(G=
        UA) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-22,-30})));

public
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort annotation (
      Placement(transformation(extent={{-20,-90},{0,-70}}), iconTransformation(
          extent={{-20,-90},{0,-70}})));

equation
  connect(thermalConductor.port_a, heatPort) annotation (Line(
      points={{-22,-40},{-10,-40},{-10,-80}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(thermalConductor.port_b, vol.heatPort) annotation (Line(
      points={{-22,-20},{-23,-20},{-23,10},{-44,10}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(extent={{-100,-80},{100,100}},preserveAspectRatio=true),
                   graphics),
    Icon(coordinateSystem(extent={{-100,-80},{100,100}},preserveAspectRatio=
            true), graphics),
    Documentation(info="<html>
<p><b>Description</b> </p>
<p>Basic pump model with UA-value for heat exchange to environment. This model sets the mass flow rate, either as a constant or based on an input. The thermal equations are identical to the <a href=\"modelica://IDEAS.Thermal.Components.BaseClasses.Pipe_Insulated\">Pipe_Insulated</a> model.</p>
<p>If an input is used (<code>useInput&nbsp;=&nbsp;true)</code>, <code>m_flowSet</code> is supposed to be a real value between 0 and 1, and the flowrate is then <code>m_flowSet * m_flowNom.</code></p>
<p>The model calculates the electricity consumption of the pump in a very simplified way: a fixed pressure drop and an efficiency are given as parameters, and the electricity consumption is computed as:</p>
<pre>PEl&nbsp;=&nbsp;m_flow&nbsp;/&nbsp;medium.rho&nbsp;*&nbsp;dpFix&nbsp;/&nbsp;etaTot;</pre>
<p><h4>Assumptions and limitations </h4></p>
<p><ol>
<li>This model does not specify a relation between pressure and flowrate, the flowrate is IMPOSED</li>
<li>If the water content of the pump, m, is zero, there are no thermal dynamics. </li>
<li>The electricity consumption is computed based on a FIXED efficiency and FIXED pressure drop AS PARAMETERS</li>
<li>The inefficiency of the pump does NOT lead to an enthalpy increase of the outlet flow.</li>
</ol></p>
<p><h4>Model use</h4></p>
<p><ol>
<li>Decide if the pump will be controlled through an input or if the flowrate is a constant</li>
<li>Set medium and water content of the pump</li>
<li>Specify the parameters for computing the electricity consumption</li>
<li>Set the UA value and connect the heatPort</li>
</ol></p>
<p><h4>Validation </h4></p>
<p>None</p>
<p><h4>Example </h4></p>
<p>The <a href=\"modelica://IDEAS.Thermal.Components.Examples.HydraulicCircuit\">HydraulicCircuit</a> example uses <a href=\"modelica://IDEAS.Thermal.Components.BaseClasses.Pump\">Pump</a> models but they can easily be replaced with this Pump_Insulated model.</p>
</html>", revisions="<html>
<p><ul>
<li>March 2014, Filip Jorissen, Annex60 compatibility and extended from Pump</li>
<li>May 2013, Roel De Coninck, documentation</li>
<li>March 2013, Ruben Baetens, graphics</li>
<li>October 2012, Roel De Coninck, first version.</li>
</ul></p>
</html>"));
end Pump_Insulated;

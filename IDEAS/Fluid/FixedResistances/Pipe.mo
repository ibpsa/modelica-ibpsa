within IDEAS.Fluid.FixedResistances;
model Pipe "Pipe without heat exchange or pressure drop"

  extends IDEAS.Fluid.Interfaces.Partials.TwoPort;

equation
  Q_flow = 0;

  annotation (
    Documentation(info="<html>
<p><b>Description</b> </p>
<p>Model for fluid flow through a pipe, without heat exchange nor pressure drop. A dynamic heat balance is included, based on the in- and outlet enthalpy flow and the internal mass m of the fluid content in the pipe. A stationary model is obtained when m=0 </p>
<p>m.cv.der(T) = h_flow_in - h_flow_out </p>
<p><h4>Assumptions and limitations</h4></p>
<p><ol>
<li>No pressure drop</li>
<li>Conservation of mass</li>
<li>No heat exchange with environment</li>
</ol></p>
<p><h4>Model use</h4></p>
<p>The following parameters have to be set by the user:</p>
<p><ol>
<li>medium</li>
<li>mass of fluid in the pipe (<b>Note:</b> Setting parameter m to zero leads to neglection of temperature transient cv.m.der(T).)</li>
<li>initial temperature of the fluid (defaults to 20&deg;C)</li>
</ol></p>
<p><h4>Validation </h4></p>
<p>No validation performed; the model is based on physical principles</p>
<p><h4>Examples</h4></p>
<p>Many models use a pipe, often a variant with <a href=\"modelica://IDEAS.Thermal.Components.BaseClasses.Pipe_HeatPort\">heatPort</a> or <a href=\"modelica://IDEAS.Thermal.Components.BaseClasses.Pipe_Insulated\">insulation</a>. A basic example is the <a href=\"modelica://IDEAS.Thermal.Components.Examples.HydraulicCircuit\">HydraulicCircuit</a>.</p>
</html>", revisions="<html>
<p><ul>
<li>2014 March, Filip Jorissen, Annex60 compatibility</li>
<li>2013 May 23, Roel De Coninck, documentation;</li>
<li>2010 November, Roel De Coninck, first implementation. </li>
</ul></p>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-40},{100,40}}),
        graphics={
        Line(
          points={{-68,20},{-68,-20}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{-60,20},{-60,-20}},
          color={100,100,100},
          smooth=Smooth.None),
        Line(
          points={{60,20},{60,-20}},
          color={100,100,100},
          smooth=Smooth.None),
        Line(
          points={{68,20},{68,-20}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{-68,0},{-100,0}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{68,0},{100,0}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{-60,0},{60,0}},
          color={100,100,100},
          smooth=Smooth.None)}),
    Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{100,
            100}}), graphics));
end Pipe;

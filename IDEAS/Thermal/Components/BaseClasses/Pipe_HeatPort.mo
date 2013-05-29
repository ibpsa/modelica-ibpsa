within IDEAS.Thermal.Components.BaseClasses;
model Pipe_HeatPort "Pipe with HeatPort"

  extends Thermal.Components.Interfaces.Partials.TwoPort;
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}},
          rotation=0)));
equation
  // energy exchange with medium
  Q_flow = heatPort.Q_flow;
  // defines heatPort's temperature
  heatPort.T = T;
  // pressure drop = none
  flowPort_a.p = flowPort_b.p;
annotation (Documentation(info="<html>
<p><b>Description</b> </p>
<p>Model for fluid flow through a pipe, including heat exchange with the environment. A dynamic heat balance is included, based on the in- and outlet enthalpy flow, the heat flux to/from environment and the internal mass m of the fluid content in the pipe. A stationary model is obtained when m=0 </p>
<p>m.cv.der(T) = heatPort.Q_flow + ( h_flow_in - h_flow_out) </p>
<p><b>Note:</b> as can be seen from the equation, injecting heat into a pipe with zero mass flow rate causes temperature rise defined by storing heat in medium&apos;s mass. </p>
<p><h5><font color=\"#008000\">Assumptions and limitations</font></h5></p>
<p><ol>
<li>No pressure drop</li>
<li>Conservation of mass</li>
<li>Heat exchange with environment</li>
</ol></p>
<p><h4>Parameters</h4></p>
<p>The following parameters have to be set by the user</p>
<p><ol>
<li>medium</li>
<li>mass of fluid in the pipe (<b>Note:</b> Setting parameter m to zero leads to neglection of temperature transient cv.m.der(T).)</li>
<li>initial temperature of the fluid (defaults to 20&deg;C)</li>
</ol></p>
<p><h4>Validation </h4></p>
<p>No validation performed; the model is based on physical principles</p>
<p><h4><font color=\"#008000\">Examples</font></h4></p>
<p>An example in which this model is used is the <a href=\"modelica://IDEAS.Thermal.Components.Examples.PumpePipeTester\">PumpPipeTester</a>.</p>
</html>", revisions="<html>
<p><ul>
<li>2013 May 23, Roel De Coninck, documentation;</li>
<li>2012 November, Roel De Coninck, first implementation. </li>
</ul></p>
</html>"),
  Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={
        Text(extent={{-150,100},{150,40}}, textString="%name"),
        Polygon(
          points={{-10,-90},{-10,-40},{0,-20},{10,-40},{10,-90},{-10,-90}},
          lineColor={255,0,0},
          fillPattern=FillPattern.Forward,
          fillColor={255,255,255}),
                              Rectangle(
          extent={{-100,20},{100,-20}},
          lineColor={255,255,255},
          fillColor={85,170,255},
          fillPattern=FillPattern.HorizontalCylinder)}),
                            Diagram(coordinateSystem(preserveAspectRatio=
            false, extent={{-100,-100},{100,100}}),
                                    graphics));
end Pipe_HeatPort;

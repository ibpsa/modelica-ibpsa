within IDEAS.Fluid.FixedResistances;
model Pipe_HeatPort "Pipe with HeatPort"

  extends IDEAS.Fluid.Interfaces.Partials.PipeTwoPort(vol(
        prescribedHeatFlowRate=prescribedHeatFlowRate));

  parameter Boolean prescribedHeatFlowRate=false
    "Set to true if the model has a prescribed heat flow at its heatPort"
   annotation(Evaluate=true, Dialog(tab="Assumptions",
      enable=use_HeatTransfer,
      group="Heat transfer"));

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort
    "Port for heat exchange with mixing volume" annotation (Placement(
        transformation(extent={{-10,90},{10,110}}), iconTransformation(extent={{-10,90},
            {10,110}})));

equation
  connect(heatPort,heatPort)  annotation (Line(
      points={{0,100},{0,100}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(vol.ports[2], res.port_a) annotation (Line(
      points={{-54,0},{4,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(res.port_b, port_b) annotation (Line(
      points={{24,0},{100,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(vol.heatPort, heatPort) annotation (Line(
      points={{-44,10},{0,10},{0,100}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (
    Documentation(info="<html>
<p><b>Description</b> </p>
<p>Model for fluid flow through a pipe, including heat exchange with the environment. A dynamic heat balance is included, based on the in- and outlet enthalpy flow, the heat flux to/from environment and the internal mass m of the fluid content in the pipe. A stationary model is obtained when m=0 </p>
<p>m.cv.der(T) = heatPort.Q_flow + ( h_flow_in - h_flow_out) </p>
<p><b>Note:</b> as can be seen from the equation, injecting heat into a pipe with zero mass flow rate causes temperature rise defined by storing heat in medium&apos;s mass. </p>
<p><h4>Assumptions and limitations</h4></p>
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
<p><h4>Examples</h4></p>
<p>An example in which this model is used is the <a href=\"modelica://IDEAS.Thermal.Components.Examples.HydraulicCircuit\">HydraulicCircuit</a>.</p>
</html>", revisions="<html>
<p><ul>
<li>2014 March, Filip Jorissen, Annex60 compatibility</li>
<li>2013 May 23, Roel De Coninck, documentation;</li>
<li>2012 November, Roel De Coninck, first implementation. </li>
</ul></p>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{100,
            100}}),                                                                              graphics={                                                          Polygon(          points={{
              -10,-35},{-10,15},{0,35},{10,15},{10,-35},{-10,-35}},                                                                                                    lineColor={255,0,0},
            fillPattern =                                                                                                   FillPattern.Forward,          fillColor={255,255,255},
          origin={0,55},
          rotation=180),                                                                                                    Rectangle(          extent={{-100,20},{100,-20}},          lineColor={255,255,255},          fillColor={85,170,255},
            fillPattern =                                                                                                   FillPattern.HorizontalCylinder)}),    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),                                                                                                    graphics));
end Pipe_HeatPort;

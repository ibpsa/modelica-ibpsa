within Annex60.Fluid.Sensors.BaseClasses;
partial model PartialAbsoluteSensor
  "Partial component to model a sensor that measures a potential variable"

  replaceable package Medium=Modelica.Media.Interfaces.PartialMedium
    "Medium in the sensor"
    annotation(choicesAllMatching=true);

  Annex60.Fluid.Interfaces.FluidPort_a port(redeclare package Medium=Medium, m_flow(min=0))
    annotation (Placement(transformation(
        origin={0,-100},
        extent={{-10,-10},{10,10}},
        rotation=90)));

equation
  port.m_flow = 0;
  port.T_outflow = Medium.T_default;
  port.Xi_outflow = Medium.X_default[1:Medium.nXi];
  port.C_outflow = zeros(Medium.nC);
  annotation (Documentation(info="<html>
<p>
Partial component to model an absolute sensor.
The component can be used for pressure sensor models.
Use for other properties such as temperature or density is discouraged, because the enthalpy at the connector can have different meanings, depending on the connection topology. For these properties, use
<a href=\"modelica://Annex60.Fluid.Sensors.BaseClasses.PartialFlowSensor\">
Annex60.Fluid.Sensors.BaseClasses.PartialFlowSensor</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
January 23, 2014, by Michael Wetter:<br/>
Changed fluid port from using <code>h_outflow</code> to <code>T_outflow</code>.
</li>
<li>
February 12, 2011, by Michael Wetter:<br/>
First implementation.
Implementation is based on <code>Modelica.Fluid</code>.
</li>
</ul>
</html>"));
end PartialAbsoluteSensor;

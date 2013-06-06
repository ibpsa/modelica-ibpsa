within IDEAS.Thermal.Components.BaseClasses;
model AbsolutePressure "Defines absolute pressure level"

  parameter Thermal.Data.Interfaces.Medium medium=Data.Media.Water() "medium"
    annotation(__Dymola_choicesAllMatching=true);
  parameter Modelica.SIunits.Pressure p(start=0) "Pressure ground";
  Thermal.Components.Interfaces.FlowPort_a flowPort(final medium=medium)
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}},
          rotation=0)));
equation
  // defining pressure
  flowPort.p = p;
  // no energy exchange; no mass flow by default
  flowPort.H_flow = 0;
annotation (Documentation(info="<html>
<p><h4>Description</h4></p>
<p><br/>This model sets an absolute pressure at the flowPort. It takes the role of an expansion vessel in an hydraulic system. </p>
<p>The function of this model can also be compared to a grounding in electrical circuits. </p>
<p><h4>Assumptions and limitations </h4></p>
<p><ol>
<li>There is no enthalpy flowrate (nor mass flow) through the flowPort, so this model does not influence the thermal behaviour of the system. </li>
</ol></p>
<p><h4>Model use</h4></p>
<p>It is important that the absolute pressure is known in EVERY branch of an hydraulic system. All hydraulic components will simply pass the pressure through all their ports, except the pumps. There are two components that can set the pressure: the <a href=\"modelica://IDEAS.Thermal.Components.BaseClasses.Ambient\">IDEAS.Thermal.Components.BaseClasses.Ambient</a> and this one.  Therefore, the model will be balanced if one of these components determines the pressure in every section of the hydraulic circuitry which is isolated by pumps.</p>
<p>The following parameters have to be set:</p>
<p><ol>
<li>medium</li>
<li>the absolute pressure is to be specified, but the value is generally of no importance. </li>
</ol></p>
<p><h4>Validation </h4></p>
<p>None</p>
<p><h4>Example</h4></p>
<p>An example in which this model is used is the <a href=\"modelica://IDEAS.Thermal.Components.Examples.PumpePipeTester\">PumpPipeTester</a>.</p>
</html>"), Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}),
                   graphics),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}),     graphics={
        Line(
          points={{-70,20},{-70,-20}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{-70,0},{-100,0}},
          color={0,0,127},
          smooth=Smooth.None),
        Ellipse(extent={{-60,60},{60,-60}}, lineColor={100,100,100},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}));
end AbsolutePressure;

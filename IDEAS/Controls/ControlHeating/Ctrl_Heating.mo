within IDEAS.Controls.ControlHeating;
model Ctrl_Heating "Basic heating curve control for heater and mixing valve"
  extends Interfaces.Partial_Ctrl_Heating;

equation
  THeaterSet = heatingCurve.TSup + dTHeaterSet;
  connect(heatingCurve.TSup, THeaCur) annotation (Line(
      points={{1,56},{24,56},{24,40},{104,40}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-80,
            -80},{100,80}}), graphics), Documentation(info="<html>
<p><b>Description</b> </p>
<p>Heating curve based control of a heater. This component is nothing more than a wrapper around the <a href=\"modelica://IDEAS.Thermal.Control.HeatingCurve\">IDEAS.Thermal.Control.HeatingCurve</a>. The set point temperature for the heater is <i>dTHeaterSet</i> Kelvin higher than the heating curve output in order to make sure that the heating curve temperature is met also when thermal losses are present in the circuit. </p>
<p><h4>Model use</h4></p>
<p><ol>
<li>Use this controller in a heating system without DHW where you want to follow a heating curve.</li>
</ol></p>
<p><h4>Validation </h4></p>
<p>No validation performed.</p>
<p><h4>Example </h4></p>
<p>This controller is used in<a href=\"modelica://IDEAS.Thermal.HeatingSystems.Heating_Radiators\"> IDEAS.Thermal.HeatingSystems.Heating_Radiators</a> and<a href=\"modelica://IDEAS.Thermal.HeatingSystems.Heating_Embedded\"> IDEAS.Thermal.HeatingSystems.Heating_Embedded</a>.</p>
</html>", revisions="<html>
<p><ul>
<li>2013 May, Roel De Coninck: documentation</li>
<li>2011, Roel De Coninck: first version and validation</li>
</ul></p>
</html>"));
end Ctrl_Heating;

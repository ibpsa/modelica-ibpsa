within Annex60.Fluid.Sensors;
model TraceSubstancesPpm
  "Ideal one port trace substances sensor outputting in parts per million"
  extends Annex60.Fluid.Sensors.BaseClasses.PartialAbsoluteSensor;
  extends Modelica.Icons.RotationalSensor;
  parameter String substanceName = "CO2" "Name of trace substance";

  parameter Real MM_fraction = 44/29
    "Molar mass of the trace substance divided by molar mass of medium";

  Modelica.Blocks.Interfaces.RealOutput ppm(min=0)
    "Trace substance in port medium in ppm"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

protected
  parameter Real s[:]= {
    if ( Modelica.Utilities.Strings.isEqual(string1=Medium.extraPropertiesNames[i],
                                            string2=substanceName,
                                            caseSensitive=false))
    then 1 else 0 for i in 1:Medium.nC}
    "Vector with zero everywhere except where species is";

    parameter Real coeff = MM_fraction*1e6;

initial equation
  assert(max(s) > 0.9, "Trace substance '" + substanceName + "' is not present in medium '"
         + Medium.mediumName + "'.\n"
         + "Check sensor parameter and medium model.");
equation
  // We obtain the species concentration with a vector multiplication
  // because Dymola 7.3 cannot find the derivative in the model
  // Buildings.Examples.VAVSystemCTControl.mo
  // if we set C = CVec[ind];
  ppm = s*inStream(port.C_outflow)*coeff;
annotation (defaultComponentName="senTraSub",
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={
        Line(points={{0,-70},{0,-100}}, color={0,0,127}),
        Text(
          extent={{-150,80},{150,120}},
          textString="%name",
          lineColor={0,0,255}),
        Text(
          extent={{160,-30},{60,-60}},
          lineColor={0,0,0},
          textString="ppm"),
        Line(points={{70,0},{100,0}}, color={0,0,127})}),
  Documentation(info="<html>
<p>
This model outputs the trace substance concentration in ppm contained in the fluid connected to its port.
The sensor is ideal, i.e., it does not influence the fluid.
</p>
<p>
Read the
<a href=\"modelica://Annex60.Fluid.Sensors.UsersGuide\">
Annex60.Fluid.Sensors.UsersGuide</a>
prior to using this model with one fluid port.
</p>
</html>", revisions="<html>
<ul>
<li>
December 2, 2015, by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})));
end TraceSubstancesPpm;

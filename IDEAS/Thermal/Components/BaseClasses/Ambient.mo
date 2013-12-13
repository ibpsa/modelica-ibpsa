within IDEAS.Thermal.Components.BaseClasses;
model Ambient "Ambient with constant properties"

  extends Thermal.Components.Interfaces.Partials.Ambient;
  parameter Boolean usePressureInput=false "Enable / disable pressure input"
    annotation (Evaluate=true);
  parameter Modelica.SIunits.Pressure constantAmbientPressure(start=0)
    "Ambient pressure" annotation (Dialog(enable=not usePressureInput));
  parameter Boolean useTemperatureInput=false
    "Enable / disable temperature input" annotation (Evaluate=true);
  parameter Modelica.SIunits.Temperature constantAmbientTemperature(start=
        293.15, displayUnit="degC") "Ambient temperature"
    annotation (Dialog(enable=not useTemperatureInput));
  Modelica.Blocks.Interfaces.RealInput ambientPressure=pAmbient if
    usePressureInput annotation (Placement(transformation(extent={{110,60},{90,
            80}}, rotation=0)));
  Modelica.Blocks.Interfaces.RealInput ambientTemperature=TAmbient if
    useTemperatureInput annotation (Placement(transformation(extent={{110,-60},
            {90,-80}}, rotation=0)));
protected
  Modelica.SIunits.Pressure pAmbient;
  Modelica.SIunits.Temperature TAmbient;
equation
  if not usePressureInput then
    pAmbient = constantAmbientPressure;
  end if;
  if not useTemperatureInput then
    TAmbient = constantAmbientTemperature;
  end if;
  flowPort.p = pAmbient;
  T = TAmbient;
  annotation (
    Documentation(info="<html>
<p><b>Description</b> </p>
<p>Model to specify pressure and temperature at boundaries of fluid flow systems.</p>
<p>Thermodynamic equations are defined by Partials.Ambient. </p>
<p><h5>Assumptions and limitations </h5></p>
<p><ol>
<li>both pressure and temperature can be constant or defined by a realInput connector</li>
</ol></p>
<p><h4>Parameters</h4></p>
<p>The following parameters have to be set by the user</p>
<p><ol>
<li>medium</li>
<li>pressure (constant) or as input</li>
<li>temperatur (constant) or as input</li>
</ol></p>
<p><h4>Validation </h4></p>
<p>No validation performed; the model is based on physical principles </p>
<p><h4>Examples</h4></p>
<p>This model is tested in<a href=\"modelica://IDEAS.Thermal.Components.Examples.OpenHydraulicSystem\"> IDEAS.Thermal.Components.Examples.OpenHydraulicSystem</a> and<a href=\"modelica://IDEAS.Thermal.Components.Examples.MixingVolume\"> IDEAS.Thermal.Components.Examples.MixingVolume</a></p>
</html>", revisions="<html>
<p><ul>
<li>2013 May 23, Roel De Coninck, documentation;</li>
<li>Model is taken from Modelica.Thermal.FluidHeatFlow.Sources.Ambient</li>
</ul></p>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={Text(
          extent={{20,80},{80,20}},
          lineColor={0,0,0},
          textString="p"),Text(
          extent={{20,-20},{80,-80}},
          lineColor={0,0,0},
          textString="T")}));
end Ambient;

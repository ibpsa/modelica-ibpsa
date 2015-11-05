within Annex60.Utilities.Psychrometrics.Functions.Examples;
model SaturationPressure "Model to test the saturationPressure function"
  extends Modelica.Icons.Example;
  parameter SI.Temperature TMin = 190 "Temperature";
  parameter SI.Temperature TMax = 373.16 "Temperature";
  SI.Temperature T "Temperature";
  SI.AbsolutePressure pSat "Saturation pressure";
  constant Real conv(unit="1/s") = 1 "Conversion factor";
equation
  T = TMin + conv*time * (TMax-TMin);
  pSat = Annex60.Utilities.Psychrometrics.Functions.saturationPressure(T);
  annotation (
experiment(StopTime=1.0),
__Dymola_Commands(file="modelica://Annex60/Resources/Scripts/Dymola/Utilities/Psychrometrics/Functions/Examples/saturationPressure.mos"
        "Simulate and plot"), Documentation(info="<html>
<p>
This example computes the saturation pressure of water.
</p>
</html>", revisions="<html>
<ul>
<li>
November 20, 2013, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end SaturationPressure;

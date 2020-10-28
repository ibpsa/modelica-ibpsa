within IBPSA.Media.Examples;
model SteamSaturationTemperaturePressureInversion
  "Model to check computation of pSat(TSat) and its inverse"
  extends Modelica.Icons.Example;
  package Medium = IBPSA.Media.Steam "Medium model";

  parameter Modelica.SIunits.Temperature TSat0=273.15+100 "Saturation temperature";
  parameter Real tol = 1E-8 "Numerical tolerance";
  Modelica.SIunits.Temperature TSat "Saturation temperature";
  Modelica.SIunits.AbsolutePressure pSat "Saturation pressure";

equation
  pSat = Medium.saturationPressure(TSat0);
  TSat = Medium.saturationTemperature(pSat);
  if (time>0.1) then
  assert(abs(TSat-TSat0)<tol, "Error in implementation of functions.\n"
     + "   TSat0 = " + String(TSat0) + "\n"
     + "   TSat  = " + String(TSat) + "\n"
     + "   Absolute error: " + String(abs(TSat-TSat0)) + " K");
  end if;
  annotation (
experiment(Tolerance=1e-6, StopTime=1.0),
__Dymola_Commands(file="modelica://IBPSA/Resources/Scripts/Dymola/Media/Examples/SteamSaturationTemperaturePressureInversion.mos"
        "Simulate and plot"));
end SteamSaturationTemperaturePressureInversion;

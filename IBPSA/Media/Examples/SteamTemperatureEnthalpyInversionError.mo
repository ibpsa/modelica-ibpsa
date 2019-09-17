within IBPSA.Media.Examples;
model SteamTemperatureEnthalpyInversionError
  "Model to check computation of h(T) and its inverse"
  extends Modelica.Icons.Example;
  extends IBPSA.Media.Examples.BaseClasses.TestTemperatureEnthalpyInversionError(
     redeclare package Medium = IBPSA.Media.Steam,
     tol = 1E-02,
     T0 = 273.15 + 120);
  annotation (
experiment(Tolerance=1e-6, StopTime=1.0),
__Dymola_Commands(file="modelica://IBPSA/Resources/Scripts/Dymola/Media/Examples/SteamTemperatureEnthalpyInversion.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This model tests whether the inversion of temperature and enthalpy
is implemented correctly for the steam model. 
If <i>T &ne; T(h(T))</i>, the model stops with an error.
The error tolerance is set to 1E-02, because the steam model uses different equations to 
calculate the temperature from the enthalpy and the enthalpy from the temperature.
The details can be referred to <a href=\"IBPSA.Media.Steam\">IBPSA.Media.Steam</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
September 12, 2019, by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"));
end SteamTemperatureEnthalpyInversionError;

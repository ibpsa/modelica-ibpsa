within IBPSA.Media.Examples;
model SteamTemperatureEnthalpyInversion
  "Model to check computation of h(T) and its inverse"
  extends Modelica.Icons.Example;
//  extends IBPSA.Media.Examples.BaseClasses.TestTemperatureEnthalpyInversion(
//    redeclare package Medium = IBPSA.Media.Steam,
//    T0=273.15 + 200,
//    tol=1e-3);

   package Medium = IBPSA.Media.Steam;
   parameter Modelica.SIunits.Temperature T0=273.15+200 "Temperature";
   parameter Real tol = 1e-3 "Numerical tolerance";
   Modelica.SIunits.Temperature T "Temperature";
   Modelica.SIunits.SpecificEnthalpy h "Enthalpy";
//   Medium.MassFraction Xi[:] = Medium.reference_X "Mass fraction";
equation
    h = Medium.specificEnthalpy_pT(p=101325, T=T0);
    T = Medium.temperature_ph(p=101325, h=h);
    if (time>0.1) then
    assert(abs(T-T0)<tol, "Error in implementation of functions.\n"
       + "   T0 = " + String(T0) + "\n"
       + "   T  = " + String(T) + "\n"
       + "   Absolute error: " + String(abs(T-T0)) + " K");
    end if;

  annotation (
experiment(Tolerance=1e-6, StopTime=1.0),
__Dymola_Commands(file="modelica://IBPSA/Resources/Scripts/Dymola/Media/Examples/SteamTemperatureEnthalpyInversion.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This model tests whether the inversion of temperature and enthalpy
is implemented correctly for the steam model. 
</p>
</html>", revisions="<html>
<ul>
<li>
March 24, 2020, by Kathryn Hinkelman:<br/>
Relaxed absolute error tolerance.
</li>
<li>
January 16, 2020, by Kathryn Hinkelman:<br/>
Change medium to ideal steam to eliminate property discontinuities.
</li>
<li>
September 12, 2019, by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"));
end SteamTemperatureEnthalpyInversion;

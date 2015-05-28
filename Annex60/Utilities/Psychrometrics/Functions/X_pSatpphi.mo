within Annex60.Utilities.Psychrometrics.Functions;
function X_pSatpphi "Humidity ratio for given water vapor pressure"
  extends Modelica.Icons.Function;
  input Modelica.SIunits.AbsolutePressure pSat "Saturation pressure";
  input Modelica.SIunits.Pressure p "Pressure of the fluid";
  input Real phi(min=0, max=1) "Relative humidity";
  output Modelica.SIunits.MassFraction X_w(
    min=0,
    max=1,
    nominal=0.01) "Water vapor mass fraction per unit mass of dry air";

algorithm
  X_w := Annex60.Utilities.Psychrometrics.Constants.k_mair*phi/(p/pSat-phi);
  annotation (
    smoothOrder=99,
    Inline=true,
    Documentation(info="<html>
<p>
Function to compute the water vapor concentration based on
saturation pressure, absolute pressure and relative humidity.
</p>
</html>", revisions="<html>
<ul>
<li>
May 28, 2015 by Filip Jorissen:<br/>
Revised implementation due to new convention for definition of
<code>X_w</code>. 
This is for 
<a href=\"https://github.com/iea-annex60/modelica-annex60/issues/247\">#247</a>.
</li>
<li>
August 21, 2012 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end X_pSatpphi;

within Annex60.Utilities.Psychrometrics.Functions;
function phi_pTX
  "Relative humidity for given pressure, dry bulb temperature and moisture mass fraction"
  extends Modelica.Icons.Function;
  input Modelica.SIunits.Pressure p=101325 "Absolute pressure of the medium";
  input Modelica.SIunits.Temperature T "Dry bulb temperature";
  input Modelica.SIunits.MassFraction X_w
    "Water vapor mass fraction per unit mass of dry air";
  output Real phi(unit="1") "Relative humidity";
algorithm
  phi :=Annex60.Utilities.Psychrometrics.Functions.pW_X(X_w=X_w, p=p)/
        Annex60.Utilities.Psychrometrics.Functions.saturationPressure(T);
  annotation (
    smoothOrder=1,
    Documentation(info="<html>
<p>
Relative humidity of air for given
pressure, temperature and water vapor mass fraction.
</p>
<p>
Note that the water vapor mass fraction must be in <i>kg/kg</i>
total air, and not dry air.
</p>
</html>",
revisions="<html>
<ul>
<li>
May 28, 2015 by Filip Jorissen:<br/>
Revised implementation due to new convention for definition of
<code>X_w</code>. 
This is for 
<a href=\"https://github.com/iea-annex60/modelica-annex60/issues/247\">#247</a>.
</li>
<li>
November 17, 2014 by Michael Wetter:<br/>
Removed test that constrains the saturation pressure to be
lower than <code>p</code>.
I do not see any numerical problems without this test.
</li>
<li>
November 13, 2014 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end phi_pTX;

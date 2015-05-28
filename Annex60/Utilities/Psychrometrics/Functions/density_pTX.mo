within Annex60.Utilities.Psychrometrics.Functions;
function density_pTX
  "Density of air as a function of pressure, temperature and species concentration"
  extends Modelica.Icons.Function;
  input Modelica.SIunits.Pressure p "Absolute pressure of the medium";
  input Modelica.SIunits.Temperature T "Dry bulb temperature";
  input Modelica.SIunits.MassFraction X_w
    "Water vapor mass fraction per unit mass of dry air";
  output Modelica.SIunits.Density d "Mass density";
protected
  Modelica.SIunits.SpecificHeatCapacity R
    "Gas constant (of mixture if applicable)";
algorithm
  R := Modelica.Media.IdealGases.Common.SingleGasesData.Air.R/(1 + X_w)
     + Modelica.Media.IdealGases.Common.SingleGasesData.H2O.R*X_w/(1 + X_w);
  d := p/(R*T);

  annotation (Documentation(info="<html>
<p>
Function to compute the density of moist air for given
pressure, temperature and water vapor mass fraction.
</p>
<p>
Note that the water vapor mass fraction is in <i>kg/kg</i>
total air.
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
February 24, 2015 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end density_pTX;

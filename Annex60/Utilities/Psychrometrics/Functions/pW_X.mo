within Annex60.Utilities.Psychrometrics.Functions;
function pW_X "Water vapor pressure for given humidity ratio"
  extends Modelica.Icons.Function;
  input Modelica.SIunits.MassFraction X_w(
    min=0,
    max=1,
    nominal=0.01) "Water vapor mass fraction per unit mass of dry air";
  input Modelica.SIunits.Pressure p=101325 "Total pressure";
  output Modelica.SIunits.Pressure p_w(displayUnit="Pa") "Water vapor pressure";

algorithm
  p_w := p*X_w/(X_w + Annex60.Utilities.Psychrometrics.Constants.k_mair);
  annotation (
    Inline=true,
    smoothOrder=99,
    derivative=BaseClasses.der_pW_X,
    Documentation(info="<html>
<p>
Function to compute the water vapor partial pressure for a given humidity ratio.
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
March 9, 2012 by Michael Wetter:<br/>
Added <code>smoothOrder=99</code> and <code>displayUnit</code> for pressure.
</li>
<li>
February 17, 2010 by Michael Wetter:<br/>
Renamed block from <code>VaporPressure_X</code> to <code>pW_X</code>.
</li>
<li>
April 14, 2009 by Michael Wetter:<br/>
Converted model to block because <code>RealInput</code> are obsolete in Modelica 3.0.
</li>
<li>
August 7, 2008 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end pW_X;

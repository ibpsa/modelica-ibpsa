within IDEAS.Media.Water;
function enthalpyOfLiquid "Return the specific enthalpy of liquid"
  extends Modelica.Icons.Function;
  input Modelica.SIunits.Temperature T "Temperature";
  output Modelica.SIunits.SpecificEnthalpy h "Specific enthalpy";
algorithm
  h := (T - reference_T)*cp_const;
  annotation(smoothOrder=5, derivative=der_enthalpyOfLiquid,
Documentation(info="<html>
<p>
This function computes the specific enthalpy of liquid water.
</p>
</html>",
revisions="<html>
<ul>
<li>
December 2, 2013, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end enthalpyOfLiquid;

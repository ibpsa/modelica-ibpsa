within IBPSA.Electrical.BaseClasses.PV.BaseClasses;
function lambertWSimple
  "Simple approximation for Lambert W function for x >= 2, should only be used for large input values as error decreases for increasing input values"
  extends Modelica.Icons.Function;
   input Real x(min=2);
   output Real W;

algorithm
  W:= log(x)*(1-log(log(x))/(log(x)+1));
  annotation (Documentation(info="<html>
<p>The Lambert W function solves mathematical equations in which the unknown is both inside and outside of an exponential function or a logarithm. </p>
<p>This function is a simple approximation for Lambert W function following Batzelis, 2016. </p>
<h4>References</h4>
<p>Duffie, John A. and Beckman, W. A. Non-Iterative Methods for the Extraction of the Single-Diode Model Parameters of Photovoltaic Modules: A Review and Comparative Assessment. In: Energies 12 (2019), Nr. 3, S. 358. http://dx.doi.org/10.3390/en12030358. &ndash; DOI 10.3390/en12030358 </p>
</html>", revisions="<html>
<ul>
<li>
Nov 17, 2022, by Laura Maier:<br/>
First implementation.
</li>
</ul>
</html>"));
end lambertWSimple;

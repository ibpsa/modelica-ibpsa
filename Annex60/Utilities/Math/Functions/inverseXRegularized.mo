within Annex60.Utilities.Math.Functions;
function inverseXRegularized
  "Function that approximates 1/x by a twice continuously differentiable function"
 input Real x "Abscissa value";
 input Real delta(min=Modelica.Constants.eps)
    "Abscissa value below which approximation occurs";
 output Real y "Function value";
protected
   Real x2 "= x^2";
   Real x4 "= x^2";
   Real dInv "= 1/delta";
   Real dInv2 "= 1/delta^2";
   Real dInv4 "= 1/delta^4";
   Real ex "Common subexpression";
algorithm
  if (abs(x) > delta) then
    y := 1/x;
  else
    // Evaluate the following equation:
    // a := 7/(2*delta^5);
    // b := -6/delta^7;
    // c := 5/(2*delta^9);
    // y := x/delta^2 + sign(x)*(a*x^4 + b*x^6 + c*x^8);
    x2    := x*x;
    x4    := x2*x2;
    dInv  := 1/delta;
    dInv2 := dInv*dInv;
    dInv4 := dInv2*dInv2;
    ex    := dInv*dInv4*x4*(3.5 - 6*x2*dInv2 + 2.5*x4*dInv4);
    y     := x*dInv2 + (if x > 0 then ex else -ex);
  end if;

  annotation (smoothOrder=2,
              Inline=true,
Documentation(info="<html>
<p>
Function that approximates <i>y=1 &frasl; x</i>
inside the interval <i>-&delta; &le; x &le; &delta;</i>.
The approximation is twice continuously differentiable with a bounded derivative on the whole
real line.
</p>
<p>
See the plot of
<a href=\"modelica://Annex60.Utilities.Math.Functions.Examples.InverseXRegularized\">
Annex60.Utilities.Math.Functions.Examples.InverseXRegularized</a>
for the graph.
</p>
</html>", revisions="<html>
<ul>
<li>
August 10, 2015, by Michael Wetter:<br/>
Removed dublicate entry <code>smoothOrder = 1</code>
and reimplmented the function so it is twice continuously differentiable.
This is for
<a href=\"https://github.com/iea-annex60/modelica-annex60/issues/302\">issue 302</a>.
</li>
<li>
February 5, 2015, by Filip Jorissen:<br/>
Added <code>smoothOrder = 1</code>.
</li>
<li>
May 10, 2013, by Michael Wetter:<br/>
Reformulated implementation to avoid unrequired computations.
</li>
<li>
April 18, 2011, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end inverseXRegularized;

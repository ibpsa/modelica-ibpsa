within IBPSA.Utilities.Math.Functions;
function factorial "Returns the value n! as an integer"
  extends Modelica.Icons.Function;

  input Integer n "Integer number";
  output Integer f "Factorial of n";

algorithm
  assert(n >= 0, "n must be 0 or greater.");
  f := 1;
  for k in 1:n loop
    f := k*f;
  end for;

annotation (Documentation(info="<html>
<p>
Function that evaluates the factorial of the input.
</p>
</html>", revisions="<html>
<ul>
<li>
February 9, 2018, by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));
end factorial;

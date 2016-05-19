within Annex60.Experimental.Pipe.Examples.UseCases;
package TypeS_Development "Special use cases for development"
extends Modelica.Icons.ExamplesPackage;


annotation (Documentation(info="<html>
<h2 id=\"type-s-special-use-cases-for-development\">Type S: Special use cases for development</h2>
<p>These use cases demonstrate detailed behavior within the context of model
development</p>
<h3 id=\"ucpipes01\">UCPipeS01</h3>
<p>This use case aims at demonstrating the pressure loss behavior of the pipe
model. In theory, two pipe models of length 50 m in series should behave the
same as one pipe model with length of 100 m. To demonstrate this behavior, the
two 50 m pipe models are placed in parallel to one 100 m pipe between a <code>source</code>
and a <code>sink</code> model. The pressure difference between <code>source</code> and <code>sink</code> is
varied following a sine function. As temperature is not relevant for this use
case, it is kept constant.</p>
</html>"));
end TypeS_Development;

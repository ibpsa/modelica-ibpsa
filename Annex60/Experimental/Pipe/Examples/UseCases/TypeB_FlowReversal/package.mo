within Annex60.Experimental.Pipe.Examples.UseCases;
package TypeB_FlowReversal "Use cases with flow reversal"
extends Modelica.Icons.ExamplesPackage;


annotation (Documentation(info="<html>
<h2 id=\"type-b-flow-reversal\">Type B: Flow reversal</h2>
<h3 id=\"ucpipeb01\">UCPipeB01</h3>
<p>This use case aims at demonstrating the correct behavior of the pipe model for
flow reversal. It is similar to <em>UCPipeA04</em>, with the addition that the pressure
at <code>source</code> can be lower than the pressure at <code>sink</code>, causing the flow direction
to reverse.</p>
<p>In the case of flow reversal, the temperatures at both sides of the pipe should
exhibit realistic behavior.</p>
<h3 id=\"ucpipeb02\">UCPipeB02</h3>
<p>This use case aims at demonstrating the behavior of the pipe with flow reversals
and varying temperatures. It is similar to <em>UCPipeB01</em>, with the addition of
temperature waves caused by varying temperatures at <code>source</code> and <code>sink</code>.</p>
<p>Temperature waves should be propagated correctly through the pipe.</p>
</html>"));
end TypeB_FlowReversal;

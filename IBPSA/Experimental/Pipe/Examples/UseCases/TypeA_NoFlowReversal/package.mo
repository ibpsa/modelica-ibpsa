within IBPSA.Experimental.Pipe.Examples.UseCases;
package TypeA_NoFlowReversal "Verifying the temperature wave propagation for single pipes without flow reversal"
extends Modelica.Icons.ExamplesPackage;


annotation (Documentation(info="<html>
<p><em>Type A</em> cases aim at verifying the temperature wave propagation behavior in the
simplest case for single pipes without flow reversal.</p>
<p>All use cases put 1-5 individual pipe elements in between two ideal source/sink
models. The pressure difference between <code>source</code> and <code>sink</code> may vary to drive
different flow regimes with flow velocities ranging between 0 and 5 m/s. The
temperature supplied by the <code>source</code> model may vary to send temperature waves
propagating through the pipe element(s).</p>
<h3 id=\"ucpipea01\">UCPipeA01</h3>
<p>This use case aims at demonstrating most basic functionalities of the pipe
model. The pressure difference between <code>source</code> and <code>sink</code> is kept constant, as
is the supply temperature at <code>source</code>.</p>
<p>The main focus of this use case is that the model checks <code>True</code> in pedantic mode
and simulates without warnings or errors.</p>
<h3 id=\"ucpipea02\">UCPipeA02</h3>
<p>This use case aims at demonstrating the functionality of the pipe with varying
flow velocities. The pressure difference between <code>source</code> and <code>sink</code> is varied
as a sine function to reach flow velocities between 0 and 5 m/s.The supply
temperature at <code>source</code> is kept constant.</p>
<p>The pipe model should vary mass flows according to the pressure states at both
its ends, with larger pressure differences leading to higher mass flow rates.</p>
<h3 id=\"ucpipea03\">UCPipeA03</h3>
<p>This use case aims at demonstrating the functionality of the pipe with varying
temperatures. The pressure difference between <code>source</code> and <code>sink</code> is kept
constant.The supply temperature is varied as a ramp function between 1 and 200
°C.</p>
<p>The pipe model should simulate successfully over the whole temperature range. In
the case with heat losses taken into account, higher temperatures should lead to
higher heat losses.</p>
<h3 id=\"ucpipea04\">UCPipeA04</h3>
<p>This use case aims at showing the model behavior with longer intervals of zero
mass flow. Therefore, the pressure difference between <code>source</code> and <code>sink</code> varies
pseudo-randomly between intervals of different values for different lengths,
some of them with a pressure difference of 0 resulting in zero mass flow. The
supply temperature at <code>source</code> is kept constant.</p>
<p>In the case with heat losses taken into account, there should be realistic heat
losses also during intervals of zero mass flow.</p>
</html>"));
end TypeA_NoFlowReversal;

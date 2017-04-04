within IBPSA.Experimental.Pipe.Examples;
package UseCases "A collection of use cases to systematically test the pipe model - see info section"
extends Modelica.Icons.ExamplesPackage;


annotation (Documentation(info="<html>
<h1 id=\"use-cases-for-pipe-model\">Use cases for pipe model</h1>
<p>This documentation defines use cases for the development of a new pipe model with
first priority on applications in district heating and cooling network models.
There are 5 types of use cases:</p>
<ul>
<li><em>Type A</em>: Use cases including 1-5 pipes with no flow reversal (zero mass flow
is possible)</li>
<li><em>Type B</em>: Use cases including 1-5 pipes with flow reversal and possible zero
mass flow</li>
<li><em>Type C</em>: Use cases including a larger number of pipes in a supply network</li>
<li><em>Type D</em>: Use cases including a larger number of pipes including supply and
return pipes to form a closed loop</li>
<li><em>Type S</em>: Special use cases needed for development</li>
</ul>
<p><em>Type A</em> cases aim at verifying the temperature wave propagation behavior in the
simplest case without flow reversal. <em>Type B</em> cases aim at demonstrating a
fully functional pipe model for all flow regimes. <em>Type C</em> and <em>Type D</em> cases
aim at improving numerical behavior in a larger network context. Should
development require additional special use cases, these can be grouped as <em>Type
S</em>.</p>
<p>All of these types can be further distinguished for cases without modeling heat
losses (identified as <em>AD</em> for &quot;adiabatic&quot;) and including heat loss modeling
(identified as <em>HL</em> for &quot;heat losses&quot;). For example models using the pipe model from the <em>Modelica Standard Library</em>, the suffix <em>_MSL</em> can be appended additionally.</p>
<p>All use cases of a certain type are numbered with two digits.</p>
<p>Thus, a unique identifier for a use case follows the format <em>UCPipe</em> + <em>type</em> +
<em>two-digit-number</em> + <em>heat-loss-id</em> , which results in e.g. <em>UCPipeA01HL</em></p>
<p>All models should check <code>True</code> in pedantic mode and simulate without warnings or
errors.</p>
<h2 id=\"range-of-applications\">Range of applications</h2>
<p>With the pipe model designed for applications in district heating and cooling
network modeling, it is intended for a temperature range between 0 and 200 degC.
Yet, as the current <em>IBPSA</em> media implementation for water does not allow
temperatures above 130 degC, this is used as the upper limit for the use case
models. It is assumed, that the pressure level is always sufficient to ensure
that the medium is always liquid, i.e. no phase changes are accounted for in the
model. The main applications regarding flow velocities range from 0 to 5 m/s.
The pipe model should be usable in large networks with at least 1000 individual
pipe elements, which may include loops in the network topology.</p>
<h2 id=\"type-a-no-flow-reversal\">Type A: No flow reversal</h2>
<p><em>Type A</em> cases aim at verifying the temperature wave propagation behavior in the
simplest case for single pipes without flow reversal.</p>
<p>All use cases put 1-5 individual pipe elements in between two ideal source/sink
models. The pressure difference between <code>source</code> and <code>sink</code> may vary to drive
different flow regimes with flow velocities ranging between 0 and 5 m/s. The
temperature supplied by the <code>source</code> model may vary to send temperature waves
propagating through the pipe element(s).</p>
<h3 id=\"ucpipea01-basic-\">UCPipeA01 &quot;Basic&quot;</h3>
<p>This use case aims at demonstrating most basic functionalities of the pipe
model. The pressure difference between <code>source</code> and <code>sink</code> is kept constant, as
is the supply temperature at <code>source</code>.</p>
<p>The main focus of this use case is that the model checks <code>True</code> in pedantic mode
and simulates without warnings or errors.</p>
<h3 id=\"ucpipea02-flow-\">UCPipeA02 &quot;Flow&quot;</h3>
<p>This use case aims at demonstrating the functionality of the pipe with varying
flow velocities. The pressure difference between <code>source</code> and <code>sink</code> is varied
as a sine function to reach flow velocities between 0 and 5 m/s.The supply
temperature at <code>source</code> is kept constant.</p>
<p>The pipe model should vary mass flows according to the pressure states at both
its ends, with larger pressure differences leading to higher mass flow rates.</p>
<h3 id=\"ucpipea03-temperature-\">UCPipeA03 &quot;Temperature&quot;</h3>
<p>This use case aims at demonstrating the functionality of the pipe with varying
temperatures. The pressure difference between <code>source</code> and <code>sink</code> is kept
constant. The supply temperature is varied as a ramp function between 0 and 130
degC, as the current <em>IBPSA</em> media implementation does not allow temperatures
higher than 129 degC.</p>
<p>The pipe model should simulate successfully over the whole temperature range. In
the case with heat losses taken into account, higher temperatures should lead to
higher heat losses.</p>
<h3 id=\"ucpipea04-zero-flow-\">UCPipeA04 &quot;Zero Flow&quot;</h3>
<p>This use case aims at showing the model behavior with longer intervals of zero
mass flow. Therefore, the pressure difference between <code>source</code> and <code>sink</code> varies
pseudo-randomly between intervals of different values for different lengths,
some of them with a pressure difference of 0 resulting in zero mass flow. The
supply temperature at <code>source</code> is kept constant.</p>
<p>In the case with heat losses taken into account, there should be realistic heat
losses also during intervals of zero mass flow.</p>
<h3 id=\"ucpipea05-temperature-step-\">UCPipeA05 &quot;Temperature Step&quot;</h3>
<p>This use case aims at showing the model behavior for a simple temperature wave propagation. The pressure difference between <code>source</code> and <code>sink</code> is kept
constant, while the supply temperature gets increased by a step of 10 K, so that a temperature wave can propagate through the pipe.</p>
<p>Temperature waves should be propagated correctly through the pipe.</p>
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
<h2 id=\"type-c-pipe-networks-source-to-sinks-\">Type C: Pipe networks (source to sinks)</h2>
<p>These use cases use a special notation for the two-digit-identifier at the end
of the use case name. The last digit is used to denote the number of loops
present in the network. The first digit identifies the boundary conditions as
described in the following use case descriptions.</p>
<h3 id=\"ucpipec00-ucpipec05\">UCPipeC00 - UCPipeC05</h3>
<p>These use cases aim at testing the pipe model and its numeric performance in a
realistic network context. To achieve this, an example network with 1 supply and
around 50 sinks is created using the Python packages <em>uesgraphs</em> and
<em>uesmodels</em>. The same network is created with 0 - 5 loops, as indicated by the
last digit of the use case identifier.</p>
<p>In this first <em>Type C</em> setup, the pressure at the <code>source</code> and the <code>sinks</code> is
kept constant, as is the supply temperature.</p>
<h3 id=\"ucpipec10-ucpipec15\">UCPipeC10 - UCPipeC15</h3>
<p>These use cases use the same network topology as <em>UCPipeC00</em> - <em>UCPipeC05</em>, but
with different boundary conditions. The pressure at the <code>source</code> and the <code>sinks</code>
is kept constant, but supply temperature varies with a heating curve that
adjusts supply temperature according to a given outdoor air temperature.</p>
<h2 id=\"type-d-pipe-networks-closed-loop-\">Type D: Pipe networks (closed loop)</h2>
<p>These use cases use a special notation for the two-digit-identifier at the end
of the use case name. The last digit is used to denote the number of loops
present in the network. The first digit identifies the boundary conditions as
described in the use case descriptions.</p>
<p>In  contrast to the <em>Type C</em> use cases, <em>Type D</em> use cases model the heating or
cooling network as a closed loop, including supply and return lines. These
models require additional models such as a supply unit with some kind of pump
behavior as well as substations with heat transfer and possibly pressure drops.
The use cases will be defined in more detail once these models are available.</p>
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
</html>", revisions="<html>
<ul>
<li>May 18, 2016 by Marcus Fuchs: <br>
First draft of use case descriptions</li>
</ul>
</html>"));
end UseCases;

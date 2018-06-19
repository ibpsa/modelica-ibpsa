within IBPSA.Utilities.IO;
package UsersGuide "User's Guide"
  extends Modelica.Icons.Information;

  annotation (preferredView="info",
  Documentation(info="<html>
<p>The package <code>IBPSA.Utilities.IO</code> consists of models that send/receive information to/from an external socket server in run time. Those models allow for example to sample the simulation data as the inputs for external conntrol deployment, or overwrite the control signals. </p>
<h4>Usage</h4>
<p>First, a socket server should be started and <a href=\"modelica://IBPSA.Resources.src.SocketServer\"> one python script</a> is provided as an example to show how to do so. </p>
<p>Then, drag at the top-level of the model an instance of <a href=\"modelica://IBPSA.Utilities.IO.Configuration\">IBPSA.Utilities.IO.Configuration</a> and enter a value for its <code>samplePeriod</code>, which is the frequency with which data will be sampled or overwritten. This global configuration block is required for the blocks to work. This global configuration block also allows to specify other optional global configurations that are by default. </p>
<p>Next, to create an sampler for providing simulation data to external software, drag as many instances of <a href=\"modelica://IBPSA.Utilities.IO.Sampler\"> /IBPSA.Utilities.IO.Sampler </a> and specify the host and TCP ip port number for the external socker server. </p>
<p>Likewise, one can also create an overwritten block using <a href=\"modelica://IBPSA.Utilities.IO.OverWritten\">IBPSA.Utilities.IO.OverWritten</a>.

<h4>Activating and deactivating plotters</h4>
As with the other parameters, the socket inherit from the global configuration, but this value can locally be overwritten. </p>
<p>Various examples that illustrate the use of the blocks can be found in <a href=\"modelica:/IBPSA.Resources.IP.Examples\">IBPSA.Resources.IP.Examples</a>. </p>
</html>"));

end UsersGuide;

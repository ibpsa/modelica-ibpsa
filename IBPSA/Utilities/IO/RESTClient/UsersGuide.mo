within IBPSA.Utilities.IO.RESTClient;
package UsersGuide "User's Guide"
extends Modelica.Icons.Information;

annotation (preferredView="info", Documentation(info="<html>
<p>The package IBPSA.Utilities.IO.RESTClient consists of models that send/receive information to/from external parties via socket communication during run-time. Those models allow, for example, to sample the simulation data as the inputs for external control deployment, or overwrite the control signals with the output from external controllers. </p>
<h4>Usage and settings </h4>
<p>First, a socket server should be started and one python script (see IBPSA/Resources/src/SocketServer/Utilities/IO/RESTClient/Examples/Server.py) is provided as an example to show how to do so. </p>
<p>Then, drag at the top-level of the model an instance of IBPSA.Utilities.IO.RESTClient.Configuration and specify its sample period, which is the frequency with which data will be sampled or overwritten, and the host id/ port, which are used to establish the socket connection. This global configuration block is required for other blocks in this package to work and it allows to specify optional global configurations. </p>
<p>Next, to create sampling blocks for providing simulation data to external parties, drag as many instances of /IBPSA.Utilities.IO.RESTClient.Send_Real and specify the local settings, such as the sample periods. Users can also select whether global or local settings are actually used for communication. </p>
<p>Likewise, one can also create overwriting blocks to receive inputs from external parties using IBPSA.Utilities.IO.RESTClient.Read_Real. In addition, for overwriting blocks, besides the global/local settings, the user can also dynamically change their setting via the communicated message directly. </p>
<p>More information about this socket communication can be found in Comer <i>et al</i> .(2003).</p>
<h4>References</h4>
<p>Douglas E. Comer,Ralph E. Droms. Computer Networks and Internets,2003, Prentice-Hall, Inc. Upper Saddle River, NJ, USA </p>
</html>", revisions="<html>
<ul>
<li>
Nov 12, 2018 by Sen Huang:<br/>
First implementation.
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/926\">#926</a>.
</li>
</ul>
</html>"));

end UsersGuide;

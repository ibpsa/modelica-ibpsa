within IBPSA.Utilities.IO.RESTClient.BaseClasses;
function SocClientReci "Socket client for receieving information"
  extends Modelica.Icons.Function;
  input Integer numOut "Number of points to be read by the created socket client";
  input String varName[numOut] "Variable name";
  input Real simTime "Simulation time";
  input String hostAddress "Host id for the socket server";
  input Integer tcpPort "TCP port for the socket connection";
  output Real oveSig[numOut] "Array with points to be write by the created socket client";
  output Real ovesamplePeriod "User defined sample period";
  output Boolean enableFlag[numOut] "Flags to show if the overwritten is diabled";
  output Real derSig[numOut] "Derivative information present";
  external "C" recimessage(numOut,varName,simTime,hostAddress,tcpPort,oveSig,ovesamplePeriod,derSig,enableFlag)
    annotation(Library="socketclient");

  annotation (Documentation(revisions="<html>
<ul>
<li>
Nov 12, 2018 by Sen Huang:<br/>
First implementation.
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/926\">#926</a>.
</li>
</ul>
</html>", info="<html>
<p>Function that establishes a client with a Socket socker server and receives the information from external parties</p>
</html>"));
end SocClientReci;

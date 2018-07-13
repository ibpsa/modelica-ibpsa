within IBPSA.Utilities.IO.RESTClient.BaseClasses;
function SocClient
  "Function that establishes a client for a TCP socker server and communicates witht the desired server"
  extends Modelica.Icons.Function;
  input Integer numOut "Number of points to be read by the created socket client";
  input Real out[numOut] "Array with points to be read by the created socket client";
  input String hostAddress "Host id for the socket server";
  input Integer tcpPort "TCP port for the socket connection";
  output Real oveSig[numOut] "Number of overwritten points to be written by the created socket client";
  output Integer resSoc "Return value for the socket client function to indicate if the socket communication is successfully done";
  external "C" resSoc = swap(numOut,out,hostAddress,tcpPort,oveSig);

annotation(Include="#include <sockclient.c>",
  IncludeDirectory="modelica://IBPSA/Resources/C-Sources",
  Documentation(info="<html>
<p>
External function that sets up a socket client for receiving and sending data.
</p>
</html>"));
end SocClient;

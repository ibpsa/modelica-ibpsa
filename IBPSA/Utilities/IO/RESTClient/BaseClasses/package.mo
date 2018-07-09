within IBPSA.Utilities.IO.RESTClient;
package BaseClasses "Package with base classes for IBPSA.Utilities.IO.RESTClient"
  extends Modelica.Icons.BasesPackage;

  function SocClient
    "\"Function that establishes a client for a TCP socker server and communicates witht the desired server\""
    extends Modelica.Icons.Function;
    input Integer numOut "number of points to be read by the created socket client";
    input Real out[numOut] "array contains points to be read by the created socket client";
    input String hostAddress "the host id for the socket server";
    input Integer tcpPort "the tcp port for the socket connection";
    output Real oveSig[numOut] "number of overwritten points to be written by the created socket client";
    output Integer resSoc "the return for the socker client function to indicate if the socket communication is successfully done";
    external "C" resSoc = swap(numOut,out,hostAddress,tcpPort,oveSig);

  annotation(Include="#include <sockclient.c>",
  IncludeDirectory="modelica://IBPSA/Resources/C-Sources",
      Documentation(info="<html>
<p>External function that sets up a socket client for receiving/sending data.</p>
</html>"));
  end SocClient;

annotation (preferredView="info", Documentation(info="<html>
<p>
This package contains base classes that are used to construct the models in
<a href=\"modelica://IBPSA.Utilities.IO.RESTClient\">
IBPSA.Utilities.IO.RESTClient</a>.
</p>
</html>"));
end BaseClasses;

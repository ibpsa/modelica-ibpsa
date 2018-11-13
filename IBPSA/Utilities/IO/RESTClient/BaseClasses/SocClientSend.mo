within IBPSA.Utilities.IO.RESTClient.BaseClasses;
function SocClientSend "Socket client for sending information"
   extends Modelica.Icons.Function;

    input Integer numOut "Number of points to be sent by the created socket client";
    input Real out[numOut] "Array with points to be sent by the created socket client";
    input String varName[numOut] "Variable names";
    input String varUnit[numOut] "Variable units";
    input Real simTime "Simulation time";
    input String hostAddress "Host id for the socket server";
    input Integer tcpPort "TCP port for the socket connection";
    external "C" sendmessage(numOut,out,varName,varUnit,simTime,hostAddress,tcpPort)
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
<p>Function&nbsp;that&nbsp;establishes&nbsp;a&nbsp;client with&nbsp;a&nbsp;Socket&nbsp;socker&nbsp;server&nbsp;and&nbsp;sends the information to external parties</p>
</html>"));
end SocClientSend;

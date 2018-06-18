within IBPSA.Utilities.IO.BaseCllasses;
function SocketClient
  "\"Function that establishes a client for a TCP socker server and communicates witht the desired server\""
  extends Modelica.Icons.Function;
  input Integer numOut "number of points to be read by the created socket client";
  input Real out[numOut] "array contains points to be read by the created socket client";
  input String hos "the host id for the socket server";
  input Integer por "the tcp port for the socket connection";
  output Real Ove[numOut] "number of overwritten points to be written by the created socket client";
  output Integer resSoc "the return for the socker client function to indicate if the socket communication is successfully done";
  external "C" resSoc = swap(numOut,out,hos,por,Ove);

  annotation(Include = "#include <sockclient.h>");
end SocketClient;

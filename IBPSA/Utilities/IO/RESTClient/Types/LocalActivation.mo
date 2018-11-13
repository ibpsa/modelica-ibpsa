within IBPSA.Utilities.IO.RESTClient.Types;
type LocalActivation = enumeration(
    global "Use activation from global configuration",
    always "Always on",
    dynamic "On based on input")
  "Enumeration for local activation of the socket connection"
 annotation (Documentation(info="<html>
<p>Enumeration that is used to locally configure the socket connection. </p>
</html>",revisions="<html>
<ul>
<li>
Nov 12, 2018 by Sen Huang:<br/>
First implementation.
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/926\">#926</a>.
</li>
</ul>
</html>"));

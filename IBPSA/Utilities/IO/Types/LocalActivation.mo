within IBPSA.Utilities.IO.Types;
type LocalActivation = enumeration(
    use_activation "Use activation from global configuration",
    always "Always on",
    use_input "On based on input")
  "Enumeration for global activation of the socket connection"
 annotation (Documentation(info="<html>
<p>
Enumeration that is used to configure the socket connection.
</p>
</html>",revisions="<html>
<ul>
<li>
March 23, 2018, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));

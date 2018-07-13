within IBPSA.Utilities.IO.RESTClient.Types;
type GlobalActivation = enumeration(
    always "Always on",
    use_input "On based on input") "Enumeration for global activation of the socket connection"
 annotation (Documentation(info="<html>
<p>Enumeration that is used to globally configure the socket connection. </p>
</html>",revisions="fixme. Revision notes are missing"));

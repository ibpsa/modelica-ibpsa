within IBPSA.Utilities.IO.RESTClient;
package Types "Package with type definitions"
 extends Modelica.Icons.TypesPackage;

  type GlobalActivation = enumeration(
    always   "Always on",
    use_input   "On based on input") "Enumeration for global activation of the socket connection"
   annotation (Documentation(info="<html>
<p>
Enumeration that is used to configure the socket connection.
</p>
</html>",  revisions=""));

annotation (preferredView="info", Documentation(info="<html>
This package contains type definitions.
</html>"));
end Types;

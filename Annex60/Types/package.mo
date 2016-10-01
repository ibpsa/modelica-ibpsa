within Annex60;
package Types "Package with type definitions"
  extends Modelica.Icons.TypesPackage;

  type Reset = enumeration(
    Disabled   "Disabled",
    Parameter   "Use parameter value",
    Input   "Use input signal")
    "Options for integrator reset";

annotation (preferredView="info", Documentation(info="<html>
<p>
This package contains type definitions.
</p>
</html>"));
end Types;

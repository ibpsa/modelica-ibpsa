within IBPSA.Fluid.Movers.BaseClasses;
package Types "Package with type definitions"
  extends Modelica.Icons.TypesPackage;

  type PrescribedVariable = enumeration(
      Speed "Speed is prescribed",
      FlowRate "Flow rate is prescribed",
      PressureDifference "Pressure difference is prescribed")
    "Enumeration to choose what variable is prescribed";

  type PrescribedPressure = enumeration(
      Mover "Pressure head across mover is prescribed",
      Upstream "Pressure head between outlet and upstream pressure measurement is prescribed",
      Downstream "Pressure head between inlet and downstream pressure measurement is prescribed")
    "Enumeration to choose what pressure head is prescribed" annotation (
      Documentation(revisions="<html>
<ul>
<li>
May 9, 2017 by Filip Jorissen:<br/>
First implementation.
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/770\">#770</a>.
</li>
</ul>
</html>", info="<html>
<p>
Enumeration type for selecting what pressure difference should be prescribed.
</p>
</html>"));
 annotation (preferredView="info", Documentation(info="<html>
<p>
This package contains type definitions for movers.
</p>
</html>"));
end Types;

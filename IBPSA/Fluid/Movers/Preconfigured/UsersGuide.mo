within IBPSA.Fluid.Movers.Preconfigured;
package UsersGuide "User's Guide"
  extends Modelica.Icons.Information;

  annotation (preferredView="info",
  Documentation(info="<html>
<p>
This package contains preconfigured versions of the mover models.
They automatically configure a mover model based on
<code>m_flow_nominal</code> and <code>dp_nominal</code>.
</p>
<p>
The configuration is as follows:
</p>
<ul>
<li>
The parameters <code>m_flow_nominal</code> and <code>dp_nominal</code>
are used to construct the pressure curve <i>&Delta; p = f(m&#775;,  y)</i>
where <i>m&#775;</i> is the mass flow rate and <i>y</i> is the speed.
This curve is based on a least squares polynomial fit of all pressure curves from
<a href=\"Modelica://IBPSA.Fluid.Movers.Data.Pumps\">
IBPSA.Fluid.Movers.Data.Pumps</a>
for pumps and
<a href=\"Modelica://IBPSA.Fluid.Movers.Data.Fans\">
IBPSA.Fluid.Movers.Data.Fans</a>
for fans. It goes through the design operating point and spans over
<i>0</i> and twice the design flow rate at maximum speed. See figure below.
The model identifies itself as a fan or pump based on the default density of
the medium.
<p align=\"center\">
<img alt=\"Pump characteristic\"
src=\"modelica://IBPSA/Resources/Images/Fluid/Movers/Preconfigured/PumpCharacteristic.png\"/>
</p>
</li>
<li>
The hydraulic efficiency is computed based on the Euler number.
See <a href=\"modelica://IBPSA.Fluid.Movers.UsersGuide\">
IBPSA.Fluid.Movers.UsersGuide</a>
for details.
</li>
<li>
The motor efficiency is computed based on a generic curve.
See <a href=\"modelica://IBPSA.Fluid.Movers.BaseClasses.Characteristics.motorEfficiencyCurve\">
IBPSA.Fluid.Movers.BaseClasses.Characteristics.motorEfficiencyCurve</a>
for details.
</li>
</ul>
</html>"));

end UsersGuide;

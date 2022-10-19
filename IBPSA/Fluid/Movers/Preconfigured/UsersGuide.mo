within IBPSA.Fluid.Movers.Preconfigured;
package UsersGuide "User's Guide"
  extends Modelica.Icons.Information;

  annotation (preferredView="info",
  Documentation(info="<html>
<p>
This package contains preconfigured versions of the mover models.
They automatically configure a mover model based on
<code>m_flow_nominal</code> and <code>dp_nominal</code>
(and <code>speed_rpm_nominal</code> for <code>SpeedControlled_Nrpm</code> only).
</p>
<p>
The configuration is as follows:
</p>
<ul>
<li>
Based on the parameters <code>m_flow_nominal</code> and <code>dp_nominal</code>,
a pressure curve is constructed based on regression results of pump or fan records
in <a href=\"Modelica://IBPSA.Fluid.Movers.Data.Pumps.Wilo\">
IBPSA.Fluid.Movers.Data.Pumps.Wilo</a>
or <a href=\"Modelica://IBPSA.Fluid.Movers.Data.Fans.Greenheck\">
IBPSA.Fluid.Movers.Data.Fans.Greenheck</a>.
For more information, see documentation of
<code>IBPSA.Fluid.HydronicConfiguration.UsersGuide.ModelParameters</code>
(currently under the development branch of
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1884\">#1884</a>.)
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

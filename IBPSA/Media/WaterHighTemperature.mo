within IBPSA.Media;
package WaterHighTemperature
  "Package with model for liquid water with constant density and an extended 
  maxiumum temperature threshold"
   extends IBPSA.Media.Water(
     T_max = 273.15+600);

  replaceable function saturationTemperature_p
    "Return saturation temperature (K) from a given pressure (Pa)"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    output Temperature T   "Saturation temperature";
  protected
    Real a[:] = {2.2830066E+02,1.1893913E+00,5.2484699E-01,1.2416857E-01,
      -1.3714779E-02,5.5702047E-04}
      "Coefficients";
  algorithm
    T := a[1] + a[2]*log(p) + a[3]*log(p)^2 + a[4]*log(p)^3 +
      a[5]*log(p)^4 + a[6]*log(p)^5  "Saturation temperature";
  annotation (
    smoothOrder=2,
    Documentation(info="<html>
    <p>
    Saturation temperature is computed from pressure. This relation is
    valid in the region of <i>273.16</i> to <i>647.096</i> K (<i>613.3</i> to <i>22,049,100</i> Pa).
    </p>
    <p>
    The function has the following form:
    </p>
    <p align=\"center\" style=\"font-style:italic;\">
    T = a<sub>1</sub> + a<sub>2</sub> ln(p) + a<sub>3</sub> ln(p)<sup>2</sup> +
    a<sub>4</sub> ln(p)<sup>3</sup> + a<sub>5</sub> ln(p)<sup>4</sup> + a<sub>6</sub> ln(p)<sup>5</sup>
    </p>
    <p>
    where temperature <i>T</i> is in units Kelvin, pressure <i>p</i> is in units Pa, and <i>a<sub>1</sub></i>
    through <i>a<sub>6</sub></i> are regression coefficients.
    </p>
  </html>", revisions="<html>
<ul>
<li>
March 6, 2020, by Kathryn Hinkelman:<br/>
First implementation.
</li>
</ul>
</html>"));
  end saturationTemperature_p;
  annotation(preferredView="info", Documentation(info="<html>
<p>
This medium package models liquid water.
</p>
<p>
The mass density is computed using a constant value of <i>995.586</i> kg/s.
For a medium model in which the density is a function of temperature, use
<a href=\"modelica://IBPSA.Media.Specialized.Water.TemperatureDependentDensity\">
IBPSA.Media.Specialized.Water.TemperatureDependentDensity</a> which may have considerably higher computing time.
</p>
<p>
For the specific heat capacities at constant pressure and at constant volume,
a constant value of <i>4184</i> J/(kg K), which corresponds to <i>20</i>&deg;C
is used.
The figure below shows the relative error of the specific heat capacity that
is introduced by this simplification.
</p>
<p align=\"center\">
<img src=\"modelica://IBPSA/Resources/Images/Media/Water/plotCp.png\" border=\"1\"
alt=\"Relative variation of specific heat capacity with temperature\"/>
</p>
<p>
The enthalpy is computed using the convention that <i>h=0</i>
if <i>T=0</i> &deg;C.
</p>
<h4>Limitations</h4>
<p>
Density, specific heat capacity, thermal conductivity and viscosity are constant.
Water is modeled as an incompressible liquid.
There are no phase changes.
</p>
</html>", revisions="<html>
<ul>
<li>
October 26, 2018, by Filip Jorissen and Michael Wetter:<br/>
Now printing different messages if temperature is above or below its limit,
and adding instance name as JModelica does not print the full instance name in the assertion.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1045\">#1045</a>.
</li>
<li>
June 6, 2015, by Michael Wetter:<br/>
Set <code>AbsolutePressure(start=p_default)</code> to avoid
a translation error if
<a href=\"modelica://IBPSA.Fluid.Sources.Examples.TraceSubstancesFlowSource\">
IBPSA.Fluid.Sources.Examples.TraceSubstancesFlowSource</a>
(if used with water instead of air)
is translated in pedantic mode in Dymola 2016.
The reason is that pressures use <code>Medium.p_default</code> as start values,
but
<a href=\"modelica://Modelica.Media.Interfaces.Types\">
Modelica.Media.Interfaces.Types</a>
sets a default value of <i>1E-5</i>.
A similar change has been done for pressure and density.
This fixes
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/266\">#266</a>.
</li>
<li>
June 6, 2015, by Michael Wetter:<br/>
Changed type of <code>BaseProperties.T</code> from
<code>Modelica.SIunits.Temperature</code> to <code>Temperature</code>.
Otherwise, it has a different start value than <code>Medium.T</code>, which
causes an error if
<a href=\"IBPSA.Media.Examples.WaterProperties\">
IBPSA.Media.Examples.WaterProperties</a>
is translated in pedantic mode.
This fixes
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/266\">#266</a>.
</li>
<li>
June 5, 2015, by Michael Wetter:<br/>
Added <code>stateSelect</code> attribute in <code>BaseProperties.T</code>
to allow correct use of <code>preferredMediumState</code> as
described in
<a href=\"modelica://Modelica.Media.Interfaces.PartialMedium\">
Modelica.Media.Interfaces.PartialMedium</a>,
and set <code>preferredMediumState=false</code>
to keep the same states as were used before.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/260\">#260</a>.
</li>
<li>
June 5, 2015, by Michael Wetter:<br/>
Removed <code>ThermodynamicState</code> declaration as this lead to
the error
\"Attempting to redeclare record ThermodynamicState when the original was not replaceable.\"
in Dymola 2016 using the pedantic model check.
</li>
<li>
May 1, 2015, by Michael Wetter:<br/>
Added <code>Inline=true</code> for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/227\">
issue 227</a>.
</li>
<li>
February 25, 2015, by Michael Wetter:<br/>
Removed <code>stateSelect</code> attribute on pressure as this caused
<a href=\"modelica://IBPSA.Examples.Tutorial.SpaceCooling.System3\">
IBPSA.Examples.Tutorial.SpaceCooling.System3</a>
to fail with the error message
\"differentiated if-then-else was not continuous\".
</li>
<li>
October 15, 2014, by Michael Wetter:<br/>
Reimplemented media based on
<a href=\"https://github.com/ibpsa/modelica-ibpsa/blob/446aa83720884052476ad6d6d4f90a6a29bb8ec9/IBPSA/Media/Water.mo\">446aa83</a>.
</li>
<li>
November 15, 2013, by Michael Wetter:<br/>
Complete new reimplementation because the previous version
had the option to add a compressibility to the medium, which
has never been used.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={
        Polygon(
          points={{16,-28},{32,-42},{26,-48},{10,-36},{16,-28}},
          lineColor={95,95,95},
          fillPattern=FillPattern.Sphere,
          fillColor={95,95,95}),
        Polygon(
          points={{10,34},{26,44},{30,36},{14,26},{10,34}},
          lineColor={95,95,95},
          fillPattern=FillPattern.Sphere,
          fillColor={95,95,95}),
        Ellipse(
          extent={{-82,52},{24,-54}},
          lineColor={95,95,95},
          fillPattern=FillPattern.Sphere,
          fillColor={0,0,0}),
        Ellipse(
          extent={{22,82},{80,24}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={95,95,95}),
        Ellipse(
          extent={{20,-30},{78,-88}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={95,95,95})}));
end WaterHighTemperature;

within Annex60.Media.Specialized.Water;
package ConstantProperties_pT "Model for liquid water with constant properties at given nominal conditions"

  constant Modelica.SIunits.Temperature T_nominal = 273.15 + 20
    "Nominal temperature for calculation of water properties";

  constant Modelica.SIunits.AbsolutePressure p_nominal = 101325
    "Nominal pressure for calculation of water properties";

  constant Modelica.SIunits.SpecificHeatCapacity cp_nominal=
    Modelica.Media.Water.IF97_Utilities.cp_pT(p_nominal, T_nominal)
    "Specific heat capacity at nominal water conditions";

  constant Density d_nominal=
    Modelica.Media.Water.IF97_Utilities.rho_pT(p_nominal, T_nominal)
    "Density at nominal water conditions";

  constant DynamicViscosity eta_nominal=
   Modelica.Media.Water.IF97_Utilities.dynamicViscosity(
     d_nominal,
     T_nominal,
     p_nominal)
   "Constant dynamic viscosity";

  constant ThermalConductivity lambda_nominal=
    Modelica.Media.Water.IF97_Utilities.thermalConductivity(
     d_nominal,
     T_nominal,
     p_nominal)
    "Constant thermal conductivity";

  constant VelocityOfSound a_nominal=
    Modelica.Media.Water.IF97_Utilities.velocityOfSound_pT(p_nominal, T_nominal)
    "Constant velocity of sound";

  constant Temperature T_max_nominal=
    Modelica.Media.Water.WaterIF97_base.saturationTemperature(p_nominal)
    "Maximum temperature valid for medium model";

  extends Annex60.Media.Water(
    cp_const=cp_nominal,
    d_const=d_nominal,
    eta_const=eta_nominal,
    lambda_const=lambda_nominal,
    a_const=a_nominal,
    T_max=T_max_nominal);

  extends Modelica.Icons.Package;

annotation (Documentation(info="<html>
<p>A model for liquid water with constant properties of given nominal conditions.</p>
<p>This water model is similar to
<a href=\"modelica://Annex60.Media.Water\">Annex60.Media.Water</a> with regard to its
complexity. It also uses constant values for properties like density and
specific heat capacity. The main difference is, that the constants <code>T_nominal</code>
and <code>p_nominal</code> allow for setting nominal conditions of the water model. The
constant properties will be derived for this nominal condition. The maximum
allowed temperature is set at the saturation temperature for the given nominal
pressure <code>p_nominal.</code></p>
<h4 id=\"assumptions-and-limitations\">Assumptions and limitations</h4>
<p>The nominal values for the constant medium properties are calculated using the
<a href=\"modelica://Modelica.Media.Water.WaterIF97_base\">Modelica.Media.Water.WaterIF97_base</a>
model.</p>
<h4 id=\"typical-use-and-important-parameters\">Typical use and important parameters</h4>
<p>A model using this medium model can set the nominal conditions e.g. by defining</p>
<p><code>package Medium = Annex60.Media.Specialized.WaterNominalCond(T_nominal=273.15+100, p_nominal=5e5);</code></p>
</html>", revisions="<html>
<ul>
<li>
September 8, 2016, by Marcus Fuchs:<br/>
First implementation
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
          fillColor={95,95,95}),
      Text(
        extent={{-104,40},{56,-36}},
        lineColor={238,46,47},
        textString="pT")}));
end ConstantProperties_pT;

within Annex60.Media.IdealGases;
package DryAir
  "Dry air model with constant specific heat capacities and ideal gas law"
  extends Modelica.Media.Air.DryAir(
     T_min=Modelica.SIunits.Conversions.from_degC(-50));

replaceable function enthalpyOfCondensingGas
    "Enthalpy of steam per unit mass of steam"
  extends Modelica.Icons.Function;
  input Temperature T "Temperature";
  output SpecificEnthalpy h "Steam enthalpy";
algorithm
  h := 0;
  annotation (Documentation(info="<html>
<p>
Dummy function that returns <code>0</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
April 27, 2011, by Michael Wetter:<br/>
First implementation to allow using the room model with a medium that does not contain water vapor.
</li>
</ul>
</html>"));
end enthalpyOfCondensingGas;

replaceable function saturationPressure
    "Return saturation pressure of condensing fluid"
  extends Modelica.Icons.Function;
  input Temperature Tsat "Saturation temperature";
  output AbsolutePressure psat "Saturation pressure";
algorithm
  psat := 0;
  annotation (Documentation(info="<html>
<p>
Dummy function that returns <code>0</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
April 27, 2011, by Michael Wetter:<br/>
First implementation to allow using the room model with a medium that does not contain water vapor.
</li>
</ul>
</html>"));
end saturationPressure;

  annotation (preferredView="info", Documentation(info="<html>
<p>
This package is identical to 
<a href=\"modelica://Modelica.Media.Air.DryAir\">
Modelica.Media.Air.DryAir</a> except for the minimum fluid temperature.
The package is here for convenience so that all medium models that are typically used
with the <code>Buildings</code> library are at a central location.
</html>",
        revisions="<html>
<ul>
<li>
November 16, 2013, by Michael Wetter:<br/>
Renamed model from
<code>Annex60.IdealGases.DryAir</code>
to
<code>Annex60.IdealGases.DryAir</code>.
</li>
<li>
April 27, 2011, by Michael Wetter:<br/>
Added function <code>enthalpyOfCondensingGas</code>, which returns <code>0</code>,
to allow using the room model with a medium that does not contain water vapor.
</li><li>
September 4, 2008, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end DryAir;

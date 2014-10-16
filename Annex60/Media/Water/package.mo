within Annex60.Media;
package Water "Package with medium models for water"
  extends Modelica.Icons.MaterialPropertiesPackage;

  annotation (preferredView="info", Documentation(info="<html>
<p>
This package contains different implementations for
water.
For typical building energy simulations, we recommend to use
<a href=\"modelica://Annex60.Media.Water.Simple\">Annex60.Media.Water.Simple</a>
in which the density is a constant. This leads to faster and more robust simulation.
The media model 
<a href=\"modelica://Annex60.Media.Water.Simple\">Annex60.Media.Water.Detailed</a>
models density as a function of temperature. This leads to coupled nonlinear system of
equations that cause slower computing time and may cause for models
with large hydraulic networks convergence problems.
</p>
</html>"));
end Water;

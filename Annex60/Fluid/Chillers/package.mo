within Annex60.Fluid;
package Chillers "Package with chiller models"
  extends Modelica.Icons.VariantsPackage;
annotation (preferredView="info", Documentation(info="<html>
This package contains components models for chillers.
The model
<a href=\"modelica://Annex60.Fluid.Chillers.Carnot\">
Annex60.Fluid.Chillers.Carnot</a> computes the coefficient of performance
based on a change in the Carnot effectiveness.
The models
<a href=\"modelica://Annex60.Fluid.Chillers.ElectricReformulatedEIR\">
Annex60.Fluid.Chillers.ElectricReformulatedEIR</a>
and
<a href=\"modelica://Annex60.Fluid.Chillers.ElectricEIR\">
Annex60.Fluid.Chillers.ElectricEIR</a>
use performance curves from the package
<a href=\"modelica://Annex60.Fluid.Chillers.Data\">
Annex60.Fluid.Chillers.Data</a>
to compute the chiller performance.
</html>"));
end Chillers;

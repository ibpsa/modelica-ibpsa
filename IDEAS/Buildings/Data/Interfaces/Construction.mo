within IDEAS.Buildings.Data.Interfaces;
record Construction "Layers from outer to inner"

  extends Modelica.Icons.MaterialProperty;

  parameter Integer nLay(min=1)
    "Number of layers of the construction, including gaps";
  parameter Integer locGain(min=1) = 1 "Location of possible embedded system";
  replaceable parameter IDEAS.Buildings.Data.Interfaces.Insulation
    insulationType(final d=insulationTickness) constrainedby
    IDEAS.Buildings.Data.Interfaces.Insulation "Type of thermal insulation";
  parameter IDEAS.Buildings.Data.Interfaces.Material[nLay] mats
    "Array of materials";
  parameter Modelica.SIunits.Length insulationTickness=0
    "Thermal insulation thickness";

  annotation (Documentation(info="<html>
<p><h4><font color=\"#008000\">General description</font></h4></p>
<p><h5>Goal</h5></p>
<p>The <code>Construction.mo</code> partial describes the material data required for building construction modelling.</p>
<p><h4><font color=\"#008000\">Validation </font></h4></p>
<p>No validation required.</p>
</html>"));
end Construction;

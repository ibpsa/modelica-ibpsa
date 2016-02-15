within IDEAS.Buildings.Data.Interfaces;
record Construction "Layers from outer to inner"

  extends Modelica.Icons.MaterialProperty;

  parameter Integer nLay(min=1)
    "Number of layers of the construction, including gaps";
  parameter Integer nGain = 0 "Number of gains";
  parameter Integer locGain[max(nGain,1)](each min=1) = {1}
    "Location of possible embedded system";
  replaceable parameter IDEAS.Buildings.Data.Interfaces.Insulation
    insulationType(final d=insulationTickness) constrainedby
    IDEAS.Buildings.Data.Interfaces.Insulation "Type of thermal insulation";
  parameter IDEAS.Buildings.Data.Interfaces.Material[nLay] mats
    "Array of materials. The last layer is connected to propsBus_a.";
  parameter Modelica.SIunits.Length insulationTickness=0
    "Thermal insulation thickness";
  parameter Modelica.SIunits.Angle incLastLay = IDEAS.Types.Tilt.Other
    "Set to IDEAS.Types.Tilt.Floor if the last layer of mats is a floor, to .Ceiling if it is a ceiling and to .Other if other.";

  annotation (Documentation(info="<html>
<p><h4><font color=\"#008000\">General description</font></h4></p>
<p><h5>Goal</h5></p>
<p>The <code>Construction.mo</code> partial describes the material data required for building construction modelling.</p>
<p><h4><font color=\"#008000\">Validation </font></h4></p>
<p>No validation required.</p>
</html>"));
end Construction;

within IDEAS.Buildings.Data.Interfaces;
partial record Construction "Template record for surface structure: define/order layers from outer to inner"

  extends Modelica.Icons.MaterialProperty;

  parameter Integer nLay(min=1)=size(mats,1)
    "Number of layers of the construction, including gaps";
  parameter Integer nGain = size(locGain,1) 
  	"Number of gain heat ports";
  parameter Integer locGain[:](each min=1) = {1}
    "Location of possible embedded system: between layer locGain and layer locGain + 1";
  replaceable parameter IDEAS.Buildings.Data.Interfaces.Insulation
    insulationType(final d=insulationTickness) constrainedby
    IDEAS.Buildings.Data.Interfaces.Insulation 
	"Thermal insulation type, may be used to define 1 instance of mats[:]";
  parameter IDEAS.Buildings.Data.Interfaces.Material[:] mats
    "Array of materials. The last layer is connected to propsBus_a.";
  parameter Modelica.SIunits.Length insulationTickness = 0
    "Thermal insulation thickness of insulationType";
  parameter Modelica.SIunits.Angle incLastLay = IDEAS.Types.Tilt.Other
    "Set to IDEAS.Types.Tilt.Floor if the last layer of mats is a floor, to .Ceiling if it is a ceiling and to .Other if other. For verification purposes.";

  annotation (Documentation(info="<html>
<p><h4><font color=\"#008000\">General description</font></h4></p>
<p><h5>Goal</h5></p>
<p>The <code>Construction.mo</code> partial describes the material data required for building construction modelling.</p>
<p><h4><font color=\"#008000\">Validation </font></h4></p>
<p>No validation required.</p>
</html>", revisions="<html>
<ul>
<li>
Augustus 1, 2016 by Filip Jorissen:<br/>
Set default <code>nLay(min=1)=size(mats,1)</code> 
and <code>nGain = size(locGain,1)</code>.
</li>
</ul>
</html>"));
end Construction;

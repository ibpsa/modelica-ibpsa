within IDEAS.Buildings.Data.Interfaces;
partial record Construction "Template record for surface structure: define/order layers from outer to inner"

  extends Modelica.Icons.MaterialProperty;

  parameter Integer nLay(min=1)=size(mats,1)
    "Number of layers of the construction, including gaps";
  parameter Integer nGain = size(locGain,1)
   "Number of gain heat ports";
  parameter Integer locGain[:](each min=1) = {1}
    "Location of possible embedded system: between layer locGain and layer locGain + 1";
  parameter IDEAS.Buildings.Data.Interfaces.Material[:] mats
    "Array of materials. The last layer is connected to propsBus_a.";
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
November 14, 2016 by Filip Jorissen:<br/>
Removed insulationType and insulationThickness
as these parameters could lead to confusion.
See <a href=https://github.com/open-ideas/IDEAS/issues/583>issue 583</a>.
</li>
<li>
Augustus 1, 2016 by Filip Jorissen:<br/>
Set default <code>nLay(min=1)=size(mats,1)</code> 
and <code>nGain = size(locGain,1)</code>.
</li>
</ul>
</html>"));
end Construction;

within IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.BaseClasses.BoreHoles.BaseClasses;
partial function partialBoreholeResistances
  "Partial model for borehole resistance calculation"

  // Geometry of the borehole
  input Boolean use_Rb = false
    "True if the value Rb should be used instead of calculated";
  input Real Rb(unit="(m.K)/W") "Borehole thermal resistance";
  input Modelica.SIunits.Height hSeg "Height of the element";
  input Modelica.SIunits.Radius rBor "Radius of the borehole";
  // Geometry of the pipe
  input Modelica.SIunits.Radius rTub "Radius of the tube";
  input Modelica.SIunits.Length eTub "Thickness of the tubes";
  input Modelica.SIunits.Length sha
    "Shank spacing, defined as the distance between the center of a pipe and the center of the borehole";

  // Thermal properties
  input Modelica.SIunits.ThermalConductivity kFil
    "Thermal conductivity of the grout";
  input Modelica.SIunits.ThermalConductivity kSoi
    "Thermal conductivity of the soi";
  input Modelica.SIunits.ThermalConductivity kTub
    "Thermal conductivity of the tube";

  // thermal properties
  input Modelica.SIunits.ThermalConductivity kMed
    "Thermal conductivity of the fluid";
  input Modelica.SIunits.DynamicViscosity mueMed
    "Dynamic viscosity of the fluid";
  input Modelica.SIunits.SpecificHeatCapacity cpMed
    "Specific heat capacity of the fluid";
  input Modelica.SIunits.MassFlowRate m_flow_nominal "Nominal mass flow rate";

  input Boolean printDebug
    "Print resistances values in log for debug purposes.";
  // Outputs

  output Real x "Capacity location";

protected
  parameter Real pi = 3.141592653589793;

  parameter Real rTub_in = rTub-eTub "Inner radius of tube";

  Real RConv(unit="(m.K)/W") = convectionResistance(
    hSeg=hSeg,
    rBor=rBor,
    rTub=rTub,
    eTub=eTub,
    kMed=kMed,
    mueMed=mueMed,
    cpMed=cpMed,
    m_flow=m_flow_nominal,
    m_flow_nominal=m_flow_nominal)*hSeg;

  Boolean test=false "thermodynamic test for R and x value";

  Real RCondPipe(unit="(m.K)/W") =  Modelica.Math.log((rTub)/rTub_in)/(2*Modelica.Constants.pi*kTub)
    "Thermal resistance of the pipe wall";

  Real Rb_internal(unit="(m.K)/W")
    "Fluid-to-grout resistance, as defined by Hellstroem. Resistance from the fluid in the pipe to the borehole wall";

  Integer i=1 "Loop counter";

  annotation (Diagram(graphics), Documentation(info="<html>
<p>
This model computes the different thermal resistances present in a single-U-tube borehole 
using the method of Bauer et al. [1].
It also computes the fluid-to-ground thermal resistance <i>R<sub>b</sub></i> 
and the grout-to-grout thermal resistance <i>R<sub>a</sub></i> 
as defined by Hellstroem [2] using the multipole method.
</p>
<p>
The figure below shows the thermal network set up by Bauer et al.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"E:/work\\modelica/DaPModels/Images/Documentation/Bauer_singleUTube_small.png\"/>
</p>
<p>
The different resistances are calculated with following equations:</p>
<p align=\"center\">
<img alt=\"image\" src=\"E:/work\\modelica/DaPModels/Images/Documentation/Bauer_resistanceValues.PNG\"/>
</p>
<p>
Notice that each resistance each resistance still needs to be divided by 
the height of the borehole segment <i>h<sub>Seg</sub></i>.
</p>
<p>
The fluid-to-ground thermal resistance <i>R<sub>b</sub></i> and the grout-to-grout resistance <i>R<sub>a</sub></i> 
are calculated with the multipole method (Hellstroem (1991)) shown below.
</p>
<p>
<!-- If this is an equation, it needs to be typed, not an image -->
<img alt=\"image\" src=\"E:/work\\modelica/DaPModels/Images/Documentation/Rb_multipole.png\"/>
</p>
<p>
<!-- If this is an equation, it needs to be typed, not an image -->
<img alt=\"image\" src=\"E:/work\\modelica/DaPModels/Images/Documentation/Ra_multipole.png\"/>
</p>
<p>
where 
<!-- fixme: use greek symbols such as &lambda; -->
<i>lambda<sub>b</sub></i> and <i>lambda</i>are the conductivity of the filling material 
and of the ground respectively, 
<i>r<sub>p</sub></i> and <i>r<sub>b</sub></i> 
are the pipe and the borehole radius, 
<i>D</i> is the shank spacing (center of borehole to center of pipe), 
<i>R<sub>p</sub></i> is resistance from the fluid to the outside wall of the pipe, 
<i>r<sub>c</sub></i> is the radius at which the ground temperature is radially uniform and 
<i>Epsilon</i> can be neglected as it is close to zero.
</p>
<h4>References</h4>
<p>G. Hellstr&ouml;m. 
<i>Ground heat storage: thermal analyses of duct storage systems (Theory)</i>. 
Dept. of Mathematical Physics, University of Lund, Sweden, 1991.
</p>
<p>D. Bauer, W. Heidemann, H. M&uuml;ller-Steinhagen, and H.-J. G. Diersch. 
<i>Thermal resistance and capacity models for borehole heat exchangers</i>. 
International Journal Of Energy Research, 35:312&ndash;320, 2010.</p>
</html>", revisions="<html>
<p>
<ul>
<li>
February 14, 2014 by Michael Wetter:<br/>
Added an assert statement to test for non-physical values.
</li>
<li>
February 12, 2014, by Damien Picard:<br/>
Remove the flow dependency of the resistances, as this function calculates the conduction resistances only.
</li>
<li>
January 24, 2014, by Michael Wetter:<br/>
Revised implementation.
</li>
<li>
January 23, 2014, by Damien Picard:<br/>
First implementation.
</li>
</ul></p>
</html>"));
end partialBoreholeResistances;

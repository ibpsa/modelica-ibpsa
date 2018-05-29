within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.GroundHeatTransfer.ThermalResponseFactors;
function finiteLineSource
  "Finite line source solution of Claesson and Javed"
  extends Modelica.Icons.Function;

  input Real t "Time";
  input Real alpha "Ground thermal diffusivity";
  input Real dis "Radial distance between borehole axes";
  input Real len1 "Length of emitting borehole";
  input Real burDep1 "Buried depth of emitting borehole";
  input Real len2 "Length of receiving borehole";
  input Real burDep2 "Buried depth of receiving borehole";
  input Boolean includeRealSource = true "True if contribution of real source is included";
  input Boolean includeMirrorSource = true "True if contribution of mirror source is included";

  output Real h_21 "Thermal response factor of borehole 1 on borehole 2";

protected
  Real lowBou = 1.0/sqrt(4*alpha*t) "Lower bound of integration";
  // Upper bound is infinite

algorithm

  h_21 := Modelica.Math.Nonlinear.quadratureLobatto(
    function
      IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.GroundHeatTransfer.ThermalResponseFactors.finiteLineSource_Integrand(
      lowBou=lowBou,
      dis=dis,
      len1=len1,
      burDep1=burDep1,
      len2=len2,
      burDep2=burDep2,
      includeRealSource=includeRealSource,
      includeMirrorSource=includeMirrorSource),
    lowBou,
    100,
    1.0e-6);

annotation (
Documentation(info="<html>
<p>
This function evaluates the finite line source solution. This solution
gives the relation between the constant heat transfer rate (per unit length)
injected by a line source of finite length <i>H<sub>1</sub></i> buried at a
distance <i>D<sub>1</sub></i> from a constant temperature surface
(<i>T=0</i>) and the average temperature raise over a line of finite length
<i>H<sub>2</sub></i> buried at a distance <i>D<sub>2</sub></i> from the constant
temperature surface.
The finite line source solution is defined by:
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://IBPSA/Resources/Images/Fluid/HeatExchangers/GroundHeatExchangers/FiniteLineSource_01.png\" />
</p>
<p>
where <i>&Delta;T<sub>1-2</sub>(t,r,H<sub>1</sub>,D<sub>1</sub>,H<sub>2</sub>,D<sub>2</sub>)</i>
is the temperature raise after a time <i>t</i> of constant heat injection and at
a distance <i>r</i> from the line heat source, <i>Q'</i> is the heat injection
rate per unit length, <i>k<sub>s</sub></i> is the soil thermal conductivity and
<i>h<sub>FLS</sub></i> is the finite line source solution.
</p>
<p>
The finite line source solution is given by:
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://IBPSA/Resources/Images/Fluid/HeatExchangers/GroundHeatExchangers/FiniteLineSource_02.png\" />
</p>
<p>
where <i>&alpha;<sub>s</sub></i> is the ground thermal diffusivity and
<i>erfint</i> is the integral of the error function, defined in
<a href=\"modelica://IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.BaseClasses.ThermalResponseFactors.finiteLineSource_erfint\">IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.BaseClasses.ThermalResponseFactors.finiteLineSource_erfint</a>.
The integral is solved numerically, with the integrand defined in
<a href=\"modelica://IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.BaseClasses.ThermalResponseFactors.finiteLineSource_Integrand\">IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.BaseClasses.ThermalResponseFactors.finiteLineSource_Integrand</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
March 22, 2018 by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));
end finiteLineSource;

within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.BaseClasses.ThermalResponseFactors;
function finiteLineSource_Integrand
  "Integrand function for finite line source evaluation"
  extends Modelica.Icons.Function;

  input Real u "Normalized integration variable";
  input Real lowBou "Lower boundary of integral before normalization";
  input Real dis "Radial distance between borehole axes";
  input Real len1 "Length of emitting borehole";
  input Real burDep1 "Buried depth of emitting borehole";
  input Real len2 "Length of receiving borehole";
  input Real burDep2 "Buried depth of receiving borehole";
  input Boolean includeRealSource = true "True if contribution of real source is included";
  input Boolean includeMirrorSource = true "True if contribution of mirror source is included";

  output Real y "Value of integrand";

protected
  Real f "Intermediate function";
  Real s "Integration variable";

algorithm
  s := u;
  f := 0;
  if includeRealSource then
    f := f +
      IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.BaseClasses.ThermalResponseFactors.finiteLineSource_erfint(
      (burDep2 - burDep1 + len2)*s);
    f := f -
      IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.BaseClasses.ThermalResponseFactors.finiteLineSource_erfint(
      (burDep2 - burDep1)*s);
    f := f +
      IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.BaseClasses.ThermalResponseFactors.finiteLineSource_erfint(
      (burDep2 - burDep1 - len1)*s);
    f := f -
      IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.BaseClasses.ThermalResponseFactors.finiteLineSource_erfint(
      (burDep2 - burDep1 + len2 - len1)*s);
  end if;
  if includeMirrorSource then
    f := f +
      IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.BaseClasses.ThermalResponseFactors.finiteLineSource_erfint(
      (burDep2 + burDep1 + len2)*s);
    f := f -
      IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.BaseClasses.ThermalResponseFactors.finiteLineSource_erfint(
      (burDep2 + burDep1)*s);
    f := f +
      IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.BaseClasses.ThermalResponseFactors.finiteLineSource_erfint(
      (burDep2 + burDep1 + len1)*s);
    f := f -
      IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.BaseClasses.ThermalResponseFactors.finiteLineSource_erfint(
      (burDep2 + burDep1 + len2 + len1)*s);
  end if;

  y := 0.5/(len2*s^2)*f*exp(-dis^2*s^2);

annotation (
Documentation(info="<html>
<p>
Integrand of the cylindrical heat source solution for use in
<a href=\"modelica://IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.BaseClasses.ThermalResponseFactors.finiteLineSource\">IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.BaseClasses.ThermalResponseFactors.finiteLineSource</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
March 22, 2018 by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));
end finiteLineSource_Integrand;

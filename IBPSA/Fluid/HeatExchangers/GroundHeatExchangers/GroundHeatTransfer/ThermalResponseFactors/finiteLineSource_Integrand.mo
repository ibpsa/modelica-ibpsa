within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.GroundHeatTransfer.ThermalResponseFactors;
function finiteLineSource_Integrand
  "Integrand function for finite line source evaluation"
  extends Modelica.Icons.Function;

  input Real s "Integration variable";
  input Modelica.SIunits.Distance dis "Radial distance between borehole axes";
  input Modelica.SIunits.Height len1 "Length of emitting borehole";
  input Modelica.SIunits.Height burDep1 "Buried depth of emitting borehole";
  input Modelica.SIunits.Height len2 "Length of receiving borehole";
  input Modelica.SIunits.Height burDep2 "Buried depth of receiving borehole";
  input Boolean includeRealSource = true "true if contribution of real source is included";
  input Boolean includeMirrorSource = true "true if contribution of mirror source is included";

  output Real y "Value of integrand";

protected
  Real f "Intermediate function";

algorithm
  f := 0;
  if includeRealSource then
    f := f +
      IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.GroundHeatTransfer.ThermalResponseFactors.finiteLineSource_erfint(
      (burDep2 - burDep1 + len2)*s);
    f := f -
      IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.GroundHeatTransfer.ThermalResponseFactors.finiteLineSource_erfint(
      (burDep2 - burDep1)*s);
    f := f +
      IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.GroundHeatTransfer.ThermalResponseFactors.finiteLineSource_erfint(
      (burDep2 - burDep1 - len1)*s);
    f := f -
      IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.GroundHeatTransfer.ThermalResponseFactors.finiteLineSource_erfint(
      (burDep2 - burDep1 + len2 - len1)*s);
  end if;
  if includeMirrorSource then
    f := f +
      IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.GroundHeatTransfer.ThermalResponseFactors.finiteLineSource_erfint(
      (burDep2 + burDep1 + len2)*s);
    f := f -
      IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.GroundHeatTransfer.ThermalResponseFactors.finiteLineSource_erfint(
      (burDep2 + burDep1)*s);
    f := f +
      IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.GroundHeatTransfer.ThermalResponseFactors.finiteLineSource_erfint(
      (burDep2 + burDep1 + len1)*s);
    f := f -
      IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.GroundHeatTransfer.ThermalResponseFactors.finiteLineSource_erfint(
      (burDep2 + burDep1 + len2 + len1)*s);
  end if;

  y := 0.5/(len2*s^2)*f*exp(-dis^2*s^2);

annotation (
Documentation(info="<html>
<p>
Integrand of the cylindrical heat source solution for use in
<a href=\"modelica://IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.GroundHeatTransfer.ThermalResponseFactors.finiteLineSource\">IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.GroundHeatTransfer.ThermalResponseFactors.finiteLineSource</a>.
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

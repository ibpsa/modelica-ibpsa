within IBPSA.Fluid.PVTCollectors.BaseClasses;
model ISO9806HeatLoss
  "Calculate the heat loss of a PVT collector using ISO9806:2017"

  extends .IDEAS.Fluid.SolarCollectors.BaseClasses.EN12975HeatLoss(
    // Override the internal heat-loss expression to include a3-a7 terms
    final QLos_internal=A_c/nSeg*{dT[i]*(a1 - a2*dT[i] + a3*(winSpePla-3)) + a4*(HHorIR
         - .Modelica.Constants.sigma*TEnv^4) - a6*(winSpePla-3)*HGloTil
         - a7*(winSpePla-3)*(HHorIR - .Modelica.Constants.sigma*TEnv^4) - a8*(dT[i])^4 for i in 1:nSeg});

  parameter .Modelica.Units.SI.CoefficientOfHeatTransfer a1(final min=0)
    "Linear heat loss coefficient";
  parameter Real a2(final unit="W/(m2.K2)", final min=0)
    "Quadratic heat loss coefficient";
  parameter Real a3(final unit="J/(m3.K)", final min=0)
    "Wind speed dependence of heat loss";
  parameter .Modelica.Units.SI.DimensionlessRatio a4(final min=0)
    "Sky long-wave irradiance dependence";
  parameter Real a6(final unit="s/m", final min=0)
    "Wind speed dependence of thermal zero-loss efficiency";
  parameter Real a7(final unit="W/(m2.K4)", final min=0)
    "Wind speed dependence of IR radiation exchange";
  parameter Real a8(final unit="W/(m2.K4)", final min=0)
    "Radiation losses";

  .Modelica.Blocks.Interfaces.RealInput winSpePla(
    unit="m/s")
    "Wind speed parallel to collector plane" annotation (
      Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,30})));
  .Modelica.Blocks.Interfaces.RealInput HGloTil(
    unit="W/m2")
    "Global irradiance on the tilted plane" annotation (
      Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,-30})));
  .Modelica.Blocks.Interfaces.RealInput HHorIR(
    unit="W/m2")
    "Long-wave (sky) irradiance [W/m2]" annotation (
      Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,0})));

annotation (
defaultComponentName="heaLosStc",
Documentation(info="<html>
<p>
This component computes the heat loss from a solar thermal or PVT collector
according to ISO&nbsp;9806:2017. It builds on the structure of the
<a href='modelica://IDEAS.Fluid.SolarCollectors.BaseClasses.EN12975HeatLoss'>
IDEAS.Fluid.SolarCollectors.BaseClasses.EN12975HeatLoss</a> model, but extends 
it with the wind‑ and long‑wave irradiance‑dependent loss mechanisms defined in
ISO&nbsp;9806:2017.
</p>
<p>
The base <code>EN12975HeatLoss</code> model includes only the linear (a<sub>1</sub>)
and quadratic (a<sub>2</sub>) temperature‑difference heat‑loss terms from
EN&nbsp;12975. These describe the main convective and radiative losses of glazed
collectors, but they do not account for wind‑driven or long‑wave radiation
effects.
</p>
<p>
The ISO&nbsp;9806:2017 quasi‑dynamic formulation adds the additional coefficients
used here to represent wind‑dependent heat loss and long‑wave irradiance
exchange. These effects are essential for accurately modeling unglazed
collectors, where wind and sky radiation strongly influence thermal losses.
</p>
<p>
The thermal losses in the extended model are calculated for each segment <i>i ∈ {1, ..., n<sub>seg</sub>}</i> as:
</p>
<p align='center' style='font-style:italic;'>
Q<sub>los,i</sub> =
A<sub>c</sub> / n<sub>seg</sub> · [
a<sub>1</sub> · ΔT<sub>i</sub>
+ a<sub>2</sub> · (ΔT<sub>i</sub>)<sup>2</sup>
+ a<sub>3</sub> · u<sub>r</sub> · ΔT<sub>i</sub>
+ a<sub>4</sub> · (E<sub>L</sub> − σ · T<sub>a</sub><sup>4</sup>)
+ a<sub>6</sub> · u<sub>r</sub> · G
+ a<sub>7</sub> · u<sub>r</sub> · (E<sub>L</sub> − σ · T<sub>a</sub><sup>4</sup>)
+ a<sub>8</sub> · (ΔT<sub>i</sub>)<sup>4</sup>
]
</p>
<p>
where:
<ul>
<li>
<i>ΔT<sub>i</sub> = T<sub>m,i</sub> − T<sub>a</sub></i>:
temperature difference between the mean fluid temperature in segment <i>i</i> and the ambient temperature
</li>
<li>
<i>a<sub>1</sub></i>:
heat loss coefficient (W/m²·K)
</li>
<li>
<i>a<sub>2</sub></i>:
temperature dependence of the heat loss coefficient (W/m²·K²)
</li>
<li>
<i>a<sub>3</sub></i>:
wind dependence of the heat loss coefficient (J/m³·K)
</li>
<li>
<i>a<sub>4</sub></i>:
sky long-wave irradiance dependence
</li>
<li>
<i>a<sub>6</sub></i>:
wind dependence of thermal zero-loss efficiency (s/m)
</li>
<li>
<i>a<sub>7</sub></i>:
wind dependence of long-wave exchange (W/m²·K⁴)
</li>
<li>
<i>a<sub>8</sub></i>:
higher-order radiation loss coefficient (W/m²·K⁴)
</li>
<li>
<i>u<sub>r</sub></i>:
wind speed normal to the collector plane
</li>
<li>
<i>E<sub>L</sub></i>:
long-wave irradiance from the sky
</li>
<li>
<i>G</i>:
global solar irradiance on the tilted collector plane
</li>
<li>
<i>T<sub>a</sub></i>:
ambient air temperature
</li>
<li>
<i>σ</i>:
Stefan–Boltzmann constant (<i>5.67×10⁻⁸</i> W/m²·K⁴)
</li>
</ul>
</p>
<p>
This model captures additional wind- and long‑wave irradiance‑dependent heat‑loss 
mechanisms defined in ISO&nbsp;9806:2017, allowing the collector performance to 
be represented more realistically under varying outdoor conditions than when using 
only the EN&nbsp;12975 a<sub>1</sub> and a<sub>2</sub> terms.
</p>
<h4>Implementation Notes</h4>
<p>
The heat-loss block inherits from 
<a href='modelica://IDEAS.Fluid.SolarCollectors.BaseClasses.EN12975HeatLoss'>
IDEAS.Fluid.SolarCollectors.BaseClasses.EN12975HeatLoss</a> to reuse its interface 
and segment-wise structure. Only the heat‑loss equations and parameters are replaced 
to match the ISO&nbsp;9806:2017
formulation.
</p>
<h4>References</h4>
<p>
<li>
ISO 9806:2017. <i><a href='https://www.iso.org/standard/67978.html'>Solar thermal collectors — Test methods</a></i>. ISO.
</li>
</p>
</html>",
revisions="<html>
<ul>
<li>
March 11, 2026, by Lone Meertens:<br/>
Updated thermal formulation from ISO 9806:2013 to ISO 9806:2017.
This is for <a href=\"https://github.com/open-ideas/IDEAS/issues/1473\">#1473</a>.
</li>
<li>
July 7, 2025, by Lone Meertens:<br/>
First implementation PVT model. 
This is for <a href=\"https://github.com/open-ideas/IDEAS/issues/1436\">#1436</a>.
</a>.
</li>
</ul>
</html>"));
end ISO9806HeatLoss;

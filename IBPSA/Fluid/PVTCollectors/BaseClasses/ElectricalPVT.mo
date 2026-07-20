within IBPSA.Fluid.PVTCollectors.BaseClasses;
model ElectricalPVT
  "Calculate the electrical power output of a PVT collector"
  extends .Modelica.Blocks.Icons.Block;
  extends .IBPSA.Fluid.SolarCollectors.BaseClasses.PartialParameters;

  // Parameters
  parameter .Modelica.Units.SI.Irradiance HGloHorNom = 1000 "global horizontal irradiances";
  parameter .Modelica.Units.SI.Efficiency eleLosFac = 0.09 "Electrical system loss factor";
  parameter .Modelica.Units.SI.Temperature TpvtRef = 298.15 "Reference cell temperature";
  parameter Real beta "Temperature coefficient [1/K]";
  parameter .Modelica.Units.SI.Power P_nominal "Nominal PV power";
  parameter .Modelica.Units.SI.Area A "PV area";
  parameter .Modelica.Units.SI.Efficiency eta0 "Zero-loss efficiency";
  parameter .Modelica.Units.SI.DimensionlessRatio tauAlpEff "Effective transmittance–absorptance product";
  parameter .Modelica.Units.SI.CoefficientOfHeatTransfer a1 "First-order heat loss coefficient";
  parameter .Modelica.Units.SI.Efficiency etaEl "Electrical efficiency";

  parameter .Modelica.Units.SI.CoefficientOfHeatTransfer UAbsFluid =
    ((tauAlpEff - etaEl) * a1) / ((tauAlpEff - etaEl) - eta0)
    "Heat transfer coefficient between the fluid and the PV cells, calculated from datasheet parameters";

  // Inputs
  .Modelica.Blocks.Interfaces.RealInput Tflu[nSeg]
    "Fluid temperatures per segment [K]"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  .Modelica.Blocks.Interfaces.RealInput qth[nSeg]
    "Thermal power density per segment [W/m2]"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  .Modelica.Blocks.Interfaces.RealInput HGloTil
    "Global tilted irradiance [W/m2]"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));

  // Outputs
  .Modelica.Blocks.Interfaces.RealOutput Pel
    "Total electrical power output [W]"
    annotation (Placement(transformation(extent={{100,40},{140,80}}),
        iconTransformation(extent={{100,40},{140,80}})));
  .Modelica.Blocks.Interfaces.RealOutput TavgCel
    "Average PV module temperature [K]"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
        iconTransformation(extent={{100,-20},{140,20}})));
  .Modelica.Blocks.Interfaces.RealOutput TavgFlu
    "Average fluid temperature [K]"
    annotation (Placement(transformation(extent={{100,-80},{140,-40}}),
        iconTransformation(extent={{100,-80},{140,-40}})));

protected
  // internal variables (not exposed as connectors)
  .Modelica.Units.SI.Temperature temMod "Average cell/module temperature ";
  .Modelica.Units.SI.Temperature temMea "Average fluid temperature";
  .Modelica.Units.SI.Temperature TCel[nSeg];
  .Modelica.Units.SI.Temperature TDif[nSeg];
  .Modelica.Units.SI.Power Pel_int[nSeg];

equation
  for i in 1:nSeg loop
    TCel[i] = Tflu[i] + qth[i] / UAbsFluid;
    TDif[i] = TCel[i] - TpvtRef;
    Pel_int[i] = (A_c/nSeg) * (P_nominal/A) * (HGloTil/HGloHorNom) *
    (1 + beta * TDif[i]) * (1 - eleLosFac);
  end for;

  Pel = sum(Pel_int);
  temMod = sum(TCel) / nSeg;
  temMea = sum(Tflu) / nSeg;
  TavgCel = temMod;
  TavgFlu = temMea;

annotation (
  defaultComponentName="eleGen",
  Documentation(info="<html>
<p>
This component computes the electrical power output of a photovoltaic-thermal (PVT) collector using the PVWatts v5 methodology (Dobos, 2014), adapted for PVT systems.
It is part of a validated, open-source Modelica implementation that relies solely on manufacturer datasheet parameters, as described in Meertens et al. (2026).
</p>
<p>
The model calculates the electrical output for each segment <i>i ∈ {1, ..., n<sub>seg</sub>}</i> as:
</p>
<p align=\"center\" style=\"font-style:italic;\">
P<sub>el,i</sub> = (A<sub>c</sub> / n<sub>seg</sub>) &#183; (P<sub>nom</sub> / A) 
&#183; (G<sub>tilt</sub> / G<sub>nom</sub>) &#183; (1 + &beta; &#183; &Delta;T<sub>i</sub>) &#183; (1 - eleLosFac)
</p>
<p>
where:
<ul>
<li>
<i>&Delta;T<sub>i</sub> = T<sub>cell,i</sub> - T<sub>ref</sub></i>: temperature difference between PV cell and reference temperature
</li>
<li>
<i>P<sub>nom</sub></i>: nominal electrical power under standard conditions [W]
</li>
<li>
<i>A</i>: gross collector area [m²]
</li>
<li>
<i>A<sub>c</sub></i>: effective collector area (equal to A if not otherwise specified)
</li>
<li>
<i>G<sub>tilt</sub></i>: global irradiance on the tilted collector plane [W/m²]
</li>
<li>
<i>G<sub>nom</sub></i>: nominal irradiance (typically 1000 W/m²)
</li>
<li>
<i>&beta;</i>: temperature coefficient of the electrical power output [1/K]
</li>
<li>
<i>eleLosFac</i>: lumped system loss factor
</li>
</ul>
</p>
<p>
The PV cell temperature is estimated from the fluid temperature and thermal power density using:
</p>
<p align=\"center\" style=\"font-style:italic;\">
T<sub>cell,i</sub> = T<sub>m,i</sub> + q<sub>th,i</sub> / U<sub>AbsFluid</sub>
</p>
<p>
The internal heat transfer coefficient <i>UAbsFluid</i> is approximately calculated from datasheet parameters. 
For the mathematical description and visualisation, see <a href='modelica://IBPSA.Fluid.PVTCollectors.UsersGuide'>IBPSA.Fluid.PVTCollectors.UsersGuide</a>.
</p>

<h4>Electrical performance and losses</h4>
<p>
The electrical submodel includes an overall system loss factor <code>eleLosFac</code>. 
PVWatts reports a total electrical power loss of 14%, resulting from the following mechanisms:
</p>
<table border=\"1\" cellpadding=\"4\">
<tr>
<th style=\"text-align:left;\">Electrical power loss mechanism</th>
<th style=\"text-align:center;\">Default value</th>
</tr>
<tr>
<td style=\"text-align:left;\">Soiling</td>
<td style=\"text-align:center;\">2 %</td>
</tr>
<tr>
<td style=\"text-align:left;\">Shading</td>
<td style=\"text-align:center;\">3 %</td>
</tr>
<tr>
<td style=\"text-align:left;\">Mismatch</td>
<td style=\"text-align:center;\">2 %</td>
</tr>
<tr>
<td style=\"text-align:left;\">Wiring</td>
<td style=\"text-align:center;\">2 %</td>
</tr>
<tr>
<td style=\"text-align:left;\">Connections</td>
<td style=\"text-align:center;\">0.5 %</td>
</tr>
<tr>
<td style=\"text-align:left;\">Light‑induced degradation</td>
<td style=\"text-align:center;\">1.5 %</td>
</tr>
<tr>
<td style=\"text-align:left;\">Nameplate rating</td>
<td style=\"text-align:center;\">1 %</td>
</tr>
<tr>
<td style=\"text-align:left;\">Availability</td>
<td style=\"text-align:center;\">3 %</td>
</tr>
<tr>
<th style=\"text-align:left;\">Total</th>
<th style=\"text-align:center;\">14 %</th>
</tr>
</table>
<p>
For well-maintained, unshaded modules, experimental validation (Meertens et al., 2026)
found that using <code>eleLosFac = 9%</code> gives excellent agreement with
measured electrical output. For PVT collectors with a high positive tolerance on the 
electrical output, this system loss factor can even be lower. 
Users may adjust <code>eleLosFac</code> to account for site-specific soiling or shading effects.
</p>

<h4>Implementation Notes</h4>
<p>
This model is designed for (unglazed) PVT collectors and supports discretization into multiple segments to capture temperature gradients along the flow path. 
It is compatible with the thermal model based on ISO 9806:2017 and is suitable for dynamic simulations where irradiance and fluid temperatures vary over time.
</p>

<h4>References</h4>
<ul>
<li>
Dobos, A. P. (2014). <i><a href='https://docs.nrel.gov/docs/fy14osti/62641.pdf'>PVWatts Version 5 Manual</a></i>. NREL/TP-6A20-62641
</li>
<li>
Meertens, L.; Jansen, J.; Helsen, L. (2026).
<i>Development and Experimental Validation of an Open-Source 
Photovoltaic‑Thermal Collector Modelica Model that Only Needs
Datasheet Parameters</i>. Submitted to 
Mathematical and Computer Modelling of Dynamical Systems,
Special Issue on Modelica, FMI, and Open Standards.
</li>
</ul>
</html>",
revisions="<html>
<ul>
<li>
March 11, 2026, by Lone Meertens:<br/>
Revised the internal thermal–electrical coupling by introducing a new
formulation for the heat-transfer coefficient between the fluid and the PV cells.
This is for <a href=\"https://github.com/open-ideas/IDEAS/issues/1473\">#1473</a>.
</li>
<li>
July 7, 2025, by Lone Meertens:<br/>
First implementation PVT model. 
This is for <a href=\"https://github.com/open-ideas/IDEAS/issues/1436\">#1436</a>.
</li>
</ul>
</html>"));
end ElectricalPVT;

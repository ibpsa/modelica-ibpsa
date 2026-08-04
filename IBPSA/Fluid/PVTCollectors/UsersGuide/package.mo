within IBPSA.Fluid.PVTCollectors;
package UsersGuide "User’s Guide"
  extends .Modelica.Icons.Information;
  annotation(preferredView="info",
    Documentation(info="<html>
<p>
This package contains a physics-based PVT collector model relying solely on 
datasheet parameters. The thermal formulation follows the ISO 9806:2017 
quasi‑dynamic test standard, which is currently the most widely used test method 
for both glazed and unglazed (WISC) collectors. The electrical submodel is 
internally coupled via a datasheet‑derived absorber–fluid heat transfer coefficient.
</p>
<h4>Model description</h4>
<p><b>Thermal part</b><p>
<p>
The equations related to the heat losses and heat gains can be found in the following models:
</p>
<ul>
<li>
Quasi‑dynamic thermal losses: see 
<a href=\"modelica://IBPSA.Fluid.PVTCollectors.BaseClasses.ISO9806HeatLoss\">
IBPSA.Fluid.PVTCollectors.BaseClasses.ISO9806HeatLoss</a>
</li>
<li>
Solar (thermal) heat gain: see 
<a href=\"modelica://IBPSA.Fluid.SolarCollectors.BaseClasses.EN12975SolarGain\">
IBPSA.Fluid.SolarCollectors.BaseClasses.EN12975SolarGain</a>
</li>
</ul>
</p>
<p>
The thermal parameters used by this model are expressed in the ISO 9806:2017 quasi‑dynamic format.
</p>
<p>
Because some commercial PVT collectors are still tested under ISO 9806:2013 (steady‑state 
unglazed or quasi‑dynamic) or the newly published ISO 9806:2025 quasi‑dynamic method, a
unified conversion procedure is provided to translate datasheet parameters from 
these standards into their ISO 9806:2017 equivalents. This guarantees that the
model can be used for all commercially tested PVT collectors. The standard‑to‑standard 
conversion routines are provided in the easy‑to‑use Excel file located at
<code>IBPSA.Resources.Data.Fluid.PVTCollectors</code>. The conversion procedure 
is based on (i) SKN‑N0474R0 for ISO 9806:2013 to ISO 9806:2017, and (ii) a newly 
introduced conversion for ISO 9806:2025 to ISO 9806:2017 as published in Meertens et al. (2026).
</p>
<p><b>Electrical part</b></p>
<p>
The equations and assumptions related to the electrical part can be found in the following model:
</p>
<ul>
<li>
Electrical generation: see 
<a href=\"modelica://IBPSA.Fluid.PVTCollectors.BaseClasses.ElectricalPVT\">
IBPSA.Fluid.PVTCollectors.BaseClasses.ElectricalPVT</a>
</li>
</ul>
<p><b>Electrical–thermal coupling</b></p>
<p>
The internal absorber–fluid heat transfer coefficient <i>U<sub>AbsFluid</sub></i> 
couples the thermal and electrical models by linking the PV cell temperature to 
the fluid temperature (see Figure 1). This coupling is critical for accurately 
predicting the electrical output.
</p>
<p>
The coefficient <i>U<sub>AbsFluid</sub></i> is computed solely from
datasheet parameters following the method introduced in
Meertens et al. (2026). For ISO 9806:2017 and MPP‑tested collectors,
the approximate formula is:
</p>
<div style='display:flex; align-items:center; justify-content:center;'>
<div style='padding-right:8px;'><i>U<sub>AbsFluid</sub> = </i></div>
<table style='border-collapse:collapse; text-align:center;'>
<tr>
<td style='padding:4px;'>
<i>(&tau;&#183;&alpha;)<sub>eff</sub> – &eta;<sub>0,el</sub> &#183; (a<sub>1</sub> + a<sub>3</sub>&#183;u<sub>r</sub>)</i>
</td>
</tr>
<tr>
<td style='border-top:1px solid black; padding:4px;'>
<i>((&tau;&#183;&alpha;)<sub>eff</sub> – &eta;<sub>0,el</sub> – (1 – a<sub>6</sub>&eta;<sub>0,b</sub> &#183; u<sub>r</sub>) &#183; &eta;<sub>0,b</sub></i>
</td>
</tr>
</table>
</div>
<ul>
<li>
Here, <i>(&tau;&#183;&alpha;)<sub>eff</sub> = 0.901</i> for unglazed PVT collectors as reported in Lämmle (2018), 
and <i> 0.84 </i>for covered collectors.
</li>
<li>
<i>u<sub>r</sub></i> is the in-plane reduced wind speed. 
In this approximation, <i>u<sub>r</sub> = 0</i> is used to derive <i>UAbsFluid</i>. 
The internal heat transfer coefficient is only weakly dependent on external wind speed when the datasheet thermal parameters are accurate (Stegmann 2011).
</li>
</ul>
<p>
This approach removes the need for a hidden fit parameter: both thermal
and electrical coupling coefficients derive solely from publicly available
datasheet values. 
</p>
<p align=\"center\">
<img alt=\"Two-node, one-capacitance thermal network for PVT collectors (ISO 9806: dashed lines; extension: solid lines).\" 
 src=\"modelica://IBPSA/Resources/Images/Fluid/PVTCollectors/Tcell_coupling.png\" width=\"500\"/>
</p>
<p style=\"text-align:center; font-style:italic; font-size:90%;\">
Figure 1: Equivalent thermal network between temperatuur node and cell node interlinked by <i>UAbsFluid</i> (Meertens et al., 2026).
</p>

<h4>References</h4>
<ul>
<li>
ISO 9806:2017. <i><a href='https://www.iso.org/standard/67978.html'>Solar thermal collectors — Test methods</a></i>. ISO.
</li>
<li>
SKN-N0474R0. <i><a href='https://solarheateurope.eu/wp-content/uploads/2019/10/SKN-N0474R0_Thermal-performance-parameter-conversion-to-the-ISO9806-2017.pdf'>
Thermal Performance Parameter Conversion to ISO 9806-2017</a></i>. Solar Heat Europe, 2019.
</li>
<li>
Stegmann, M.; Bertram, E.; Rockendorf, G.; Janßen, S. (2011). 
<i><a href='https://proceedings.ises.org/conference/swc2011/papers/swc2011-0221-Stegmann.pdf'>
Model of an Unglazed Photovoltaic Thermal Collector Based on Standard Test Procedures</a></i>. 
ISES Solar World Congress proceedings. DOI: 10.18086/swc.2011.19.30
</li>
<li>
Lämmle, M. (2018). <i><a href='https://freidok.uni-freiburg.de/files/16446/_kjSuAarLmHmjl3z/diss_laemmle.pdf'>
Thermal management of PVT collectors: development and modelling of highly efficient glazed, 
flat plate PVT collectors with low emissivity coatings and overheating protection</a></i>. 
PhD thesis, University of Freiburg. DOI: 10.6094/UNIFR/16446
</li>
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
<li>
Meertens, L., Jansen, J., Helsen, L. (2025).
<i>Development and Experimental Validation of an Unglazed Photovoltaic-Thermal Collector Modelica Model that only needs Datasheet Parameters</i>,
submitted to the 16th International Modelica & FMI Conference, Lucerne, Switzerland, Sep 8–10, 2025.
</li>
</ul>
</html>"));
end UsersGuide;

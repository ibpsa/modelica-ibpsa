within IBPSA.Fluid.PVTCollectors.Validation;
package PVT_UI
  annotation (preferredView="info", Documentation(info=
  "<html>
<p>
This package contains validation models for the <a href=\"modelica://IBPSA.Fluid.PVTCollectors.Validation.PVT_UI\">PVT_UI</a> collector 
(referred to as <code>PVT1</code> in Meertens et al., 2026), 
an <a href=\"modelica://IBPSA.Fluid.PVTCollectors.Data.Uncovered.UI_Validation\">uncovered PVT collector with rear insulation</a>, 
based on experimental data from HTW Saar (Jonas et al., 2019).
</p>
<p>
The validation includes four representative day types:
</p>
<ul>
<li>
<b>Day Type 1:</b> Clear sky, low temperature difference (<i>&eta;<sub>0</sub></i> conditions)
</li>
<li>
<b>Day Type 2:</b> Partly cloudy, low temperature difference 
</li>
<li>
<b>Day Type 3:</b> Clear sky, medium temperature difference 
</li>
<li>
<b>Day Type 4:</b> Clear sky, high temperature difference 
</li>
</ul>
With the temperature difference refering to the difference between the fluid 
temperature and the ambient temperature.
<p>
The validation of <a href=\"modelica://IBPSA.Fluid.PVTCollectors.Validation.PVT_UI\">
PVT_UI</a> is organized into two subpackages:
</p>
<ul>
<li>
<a href=\"modelica://IBPSA.Fluid.PVTCollectors.Validation.PVT_UI.Thermal\">Thermal</a>:
Includes four models for the four ISO&nbsp;9806:2017 day types. Each model
compares simulated and measured thermal output and evaluates the thermal
loss components.
</li>
<li>
<a href=\"modelica://IBPSA.Fluid.PVTCollectors.Validation.PVT_UI.Electrical\">Electrical</a>:
Contains four corresponding day‑type models that validate the electrical performance 
by comparing simulated and measured power output.
</li>
</ul>
<h4>Model limitations</h4>
<p>
Overall, the <a href=\"modelica://IBPSA.Fluid.PVTCollectors.Validation.PVT_UI\">PVT_UI</a> 
validation demonstrates strong agreement between the model and measurements for 
both thermal and electrical outputs under a range of operating conditions. 
While electrical outputs are accurate and consistent across all day types, 
limitations in thermal output are observed under high wind speeds and rapid irradiance 
changes, primarily due to datasheet parameter constraints. This is particularly 
observed in Day Type 4, where a large temperature difference between the fluid 
and ambient air amplifies these limitations. The wind speed over the collector 
plane during most of the test periods is generated using an artificial blower, 
producing wind speeds around <i>3.5&nbsp;m/s</i>.  This lies near the upper 
boundary of the test range for the datasheet thermal parameters, potentially 
leading to additional discrepancies between the modeled and measured results.
</p>
<h4>Validation results</h4>
<p>
The complete validation methodology, covering the model formulation,
datasheet-based thermal–electrical coupling, and performance metrics, is documented in
Meertens et&nbsp;al. (2026).  The same paper reports the detailed results, including 
MAE and RMSE values and the energy deviations for each day type.
</p>
<h4>References</h4>
<ul>
<li>
Meertens, L.; Jansen, J.; Helsen, L. (2026).
<i>Development and Experimental Validation of an Open-Source 
Photovoltaic‑Thermal Collector Modelica Model that Only Needs
Datasheet Parameters</i>. Submitted to 
Mathematical and Computer Modelling of Dynamical Systems,
Special Issue on Modelica, FMI, and Open Standards.
</li>
<li>
Jonas, D., Theis, D., Frey, G. (2019). 
<i>Performance modeling of PVT collectors: Implementation, validation and parameter identification approach using TRNSYS</i>. 
Solar Energy 193, pp. 51–64.
</li>
</ul>
</html>",
revisions="<html>
<ul>
<li>
March 11, 2026, by Lone Meertens:<br/>
Updated thermal formulation from ISO 9806:2013 to ISO 9806:2017 and added
conversion support.This is for <a href=\"https://github.com/open-ideas/IDEAS/issues/1473\">#1473</a>.
</li>
<li>
July 7, 2025, by Lone Meertens:<br/>
First implementation PVT model. 
This is for <a href=\"https://github.com/open-ideas/IDEAS/issues/1436\">#1436</a>.
</li>
</ul>
</html>"));
end PVT_UI;

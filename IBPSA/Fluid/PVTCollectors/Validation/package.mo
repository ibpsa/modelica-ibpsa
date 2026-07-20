within IBPSA.Fluid.PVTCollectors;
package Validation "Collection of validation models"
  extends .Modelica.Icons.ExamplesPackage;

annotation (preferredView="info", Documentation(info="<html>
<p>
This package provides validation models for the classes in 
<a href=\"modelica://IBPSA.Fluid.PVTCollectors\">IBPSA.Fluid.PVTCollectors</a>.
</p>

<p>
The validation examples use experimental data from two types of unglazed PVT collectors:
</p>
<ul>
<li><b>UI</b>: Uncovered PVT collector with rear insulation</li>
<li><b>UN</b>: Uncovered PVT collector without rear insulation</li>
</ul>

<p>
These are implemented in the subpackages <a href=\"modelica://IBPSA.Fluid.PVTCollectors.Validation.PVT_UI\">PVT_UI</a> and <a href=\"modelica://IBPSA.Fluid.PVTCollectors.Validation.PVT_UN\">PVT_UN</a>, respectively.
The naming convention used in this implementation (<code>PVT_UI</code> and <code>PVT_UN</code>) 
corresponds to the datasets referred to as respectively <code>PVT1</code> and <code>PVT2</code> 
in Meertens et al. (2026), where they are described in detail.
</p>

<p>
The purpose of these models is to assess the accuracy and limitations of the quasi-dynamic PVT model 
(<a href=\"modelica://IBPSA.Fluid.PvtCollectors.QuasiDynamicPvtCollector\">IBPSA.Fluid.PvtCollectors.QuasiDynamicPvtCollector</a>) under realistic conditions. 
This is done by driving the model with experimental input data and comparing the simulated outputs 
with measured results.
</p>

<h4>References</h4>
<ul>
<li>
Meertens, L.; Jansen, J.; Helsen, L. (2026).
<i>Development and Experimental Validation of an Open-Source Unglazed
Photovoltaic‑Thermal Collector Modelica Model that only needs
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
Updated thermal formulation from ISO 9806:2013 to ISO 9806:2017 and added
conversion support. This is for <a href=\"https://github.com/open-ideas/IDEAS/issues/1473\">#1473</a>.
</li>
<li>
July 7, 2025, by Lone Meertens:<br/>
First implementation of the PVT model; tracked in 
<a href=\"https://github.com/open-ideas/IDEAS/issues/1436\">
IDEAS #1436
</a>.
</li>
</ul>
</html>"));
end Validation;

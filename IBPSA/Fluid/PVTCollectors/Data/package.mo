within IBPSA.Fluid.PVTCollectors;
package Data "Data for photovoltaic–thermal (PVT) collectors"
extends .Modelica.Icons.MaterialPropertiesPackage;

annotation (Documentation(info = "<html>
<p>
This package contains both thermal and electrical performance data records
for photovoltaic–thermal (PVT) collectors. All parameters are openly available
from datasheets and certificates. Thermal performance data, structured according
to the ISO 9806:2017 quasi-dynamic test method, can be found in rating databases
such as:
<ul>
<li>
<a href=\"https://solar-rating.org/\">Solar Rating and Certification Corporation (SRCC)</a>
</li>
<li>
<a href=\"https://solarkeymark.eu/\">Solar Keymark</a>
</li>
<li>
<a href=\"https://www.spftesting.info/\">SPF Testing</a>
</li>
</ul>
Electrical performance parameters and system loss factors are typically
published in the commercial PV module datasheet provided by the manufacturer.
</p>
<p>
PVT collector types are categorized as follows:
</p>
<ul>
<li>
<b>U:</b> Uncovered PVT collectors, subdivided into:
<ul>
<li>
<b>UI:</b> Uncovered PVT collectors <i>with</i> rear insulation
</li>
<li>
<b>UN:</b> Uncovered PVT collectors <i>without</i> rear insulation
</li>
</ul>
</li>
<li>
<b>C:</b> Covered (glazed or polymer) PVT collectors
</li>
<li>
<b>X:</b> Concentrating PVT collectors
</li>
</ul>
<p>
All record names should begin with one of the above abbreviations to indicate the
collector classification.
</p>
<p>
To ensure compatibility with all commercially tested PVT collectors, this package
also provides a standard‑to‑standard conversion tool that converts thermal
parameters from ISO 9806:2013 and ISO 9806:2025 into the
ISO 9806:2017 quasi-dynamic format used throughout IDEAS.
The conversion is implemented in an easy‑to‑use Excel file located at:
<br/>
<span style=\"font-family:monospace;\">IDEAS.Resources.Data.Fluid.PVTCollectors</span>.
</p>
</html>"));

end Data;

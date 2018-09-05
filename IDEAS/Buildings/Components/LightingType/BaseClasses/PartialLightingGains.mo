within IDEAS.Buildings.Components.LightingType.BaseClasses;
partial record PartialLightingGains
  "Record for defining the type of the lighting, to compute the light heat gains"
  extends Modelica.Icons.Record;

  parameter Modelica.SIunits.Power W(min=0) = speW*A
    "Total light wattage";
  parameter Real F_sa(min=0) = 1.0
    "Special allowance factor";
protected
  parameter SI.Area A(min=0) "Area of the zone";

  parameter Modelica.SIunits.Irradiance speW(min=0)
    "Total light wattage per square meter";
  parameter Modelica.SIunits.Power Q(min=0) = W*F_sa
    "Sensible heat gain from electric lighting";
   annotation (Documentation(revisions="<html>
<ul>
<li>
August 28, 2018 by Iago Cupeiro:<br/>
First implementation
See <a href=\"https://github.com/open-ideas/IDEAS/issues/879\">#879</a>.
</li>
</ul>
</html>", info="<html>
<p>
Because lighting is often a major space cooling load component,
an accurate estimate of the space heat gain it imposes is needed. Calculation
of this load component is not straightforward; the rate of
cooling load from lighting at any given moment can be quite different
from the heat equivalent of power supplied instantaneously to
those lights, because of heat storage.
</p>

<h4>Instantaneous heat gain from lighting</h4>
<p>
The primary source of heat from lighting comes from lightemitting
elements, or lamps, although significant additional heat
may be generated from ballasts and other appurtenances in the
luminaires. Generally, the instantaneous rate of sensible heat gain
from electric lighting may be calculated from:
</p>
<pre>
        qel = W*Ful*Fsa
</pre>
<p>
where:
<ul>
<li>qel = heat gain [W]</li>
<li>W = total light wattage [W]</li>
<li>Ful = lighting use factor</li>
<li>Fsa = lighting special allowance factor</li>
</ul>
</p>
<p>
The total light wattage is obtained from the ratings of all lamps
installed, both for general illumination and for display use. Ballasts
are not included, but are addressed by a separate factor. Wattages of
magnetic ballasts are significant; the energy consumption of highefficiency
electronic ballasts might be insignificant compared to
that of the lamps.
</p>
<p>
The lighting use factor is the ratio of wattage in use, for the conditions
under which the load estimate is being made, to total
installed wattage. For commercial applications such as stores, the
use factor is generally 1.0.
</p>
<p>
The special allowance factor is the ratio of the lighting fixtures’
power consumption, including lamps and ballast, to the nominal
power consumption of the lamps. For incandescent lights, this factor
is 1. For fluorescent lights, it accounts for power consumed by the
ballast as well as the ballast’s effect on lamp power consumption.
The special allowance factor can be less than 1 for electronic ballasts
that lower electricity consumption below the lamp’s rated
power consumption. Use manufacturers’ values for system (lamps +
ballast) power, when available.
</p>
<p>
For high-intensity-discharge lamps (e.g. metal halide, mercury
vapor, high- and low-pressure sodium vapor lamps), the actual lighting
system power consumption should be available from the manufacturer
of the fixture or ballast. Ballasts available for metal halide
and high-pressure sodium vapor lamps may have special allowance
factors from about 1.3 (for low-wattage lamps) down to 1.1 (for
high-wattage lamps).
</p>
<p>
An alternative procedure is to estimate the lighting heat gain on a
per-square-metre basis. Such an approach may be required when
final lighting plans are not available. Table 2 of ASHRAE
Fundamentals 2017 in Chapter 18 shows the maximum
lighting power density (LPD) (lighting heat gain per square metre)
allowed by ASHRAE Standard 90.1-2013 for a range of space types. Some
of the values found in the default records are derived from this Table.
</p>

<h4>References</h4>
<p>
Engineers, R. A. C. (2017). ASHRAE Handbook-fundamental, Chapter 18: Nonresidential Cooling and Heating Load Calculation. American Society of Heating, Refrigerating and Air-Conditioning Engineers.
</p>

</html>"));
end PartialLightingGains;

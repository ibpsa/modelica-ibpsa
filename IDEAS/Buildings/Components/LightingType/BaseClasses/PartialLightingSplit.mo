within IDEAS.Buildings.Components.LightingType.BaseClasses;
partial record PartialLightingSplit
  "Record for defining the type of the lighting, to compute the space and radiative fractions"
  extends Modelica.Icons.Record;

  parameter Real spaFra(min=0,max=1)
    "Space fraction of lighting heat exchange, default based on Ashrae fundamentals chap 18.2.2, Table 3 - Lighting Heat Gain Parameters for Typical Operating Conditions";

  parameter Real radFra(min=0,max=1)
    "Radiant fraction of lighting heat exchange, default based on Ashrae fundamentals chap 18.2.2, Table 3 - Lighting Heat Gain Parameters for Typical Operating Conditions";

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
In addition to determining the lighting heat gain, the fraction of
lighting heat gain that enters the conditioned space may need to be
distinguished from the fraction that enters an unconditioned space;
of the former category, the distribution between radiative and convective
heat gain must be established. This record may be used to split the lightning
heat gain between the space and the plenum ones, and the radiative and convective ones.
</p>
<p>
The records found in the LightningHeatDist package come from Table 3 within Chapter 18 in ASHRAE FUNDAMENTALS (2017).
Fisher and Chantrasrisalai (2006) and Zhou et al. (2016) experimentally
studied 12 luminaire types and recommended several categories
of luminaires, stored in the LightningHeatDist package. The package provides a
range of design data for the conditioned space fraction, short-wave
radiative fraction, and long-wave radiative fraction under typical
operating conditions: airflow rate of 5 L/(s·m2), supply air temperature
between 15 and 16.7°C, and room air temperature between
22 and 24°C. The recommended fractions in the records within such a package 
are based on lighting heat input rates range of 9.7 to 28 W/m2. The
space fraction in the table is the fraction of lighting heat gain that
goes to the room; the fraction going to the plenum can be computed
as 1 – the space fraction. The radiative fraction is the radiative part
of the lighting heat gain that goes to the room. The convective fraction
of the lighting heat gain that goes to the room is 1 – the radiative.
fraction.
</p>

<h4>References</h4>
<p>
Engineers, R. A. C. (2017). ASHRAE Handbook-fundamental, Chapter 18: Nonresidential Cooling and Heating Load Calculation. American Society of Heating, Refrigerating and Air-Conditioning Engineers.
</p>

</html>"));
end PartialLightingSplit;

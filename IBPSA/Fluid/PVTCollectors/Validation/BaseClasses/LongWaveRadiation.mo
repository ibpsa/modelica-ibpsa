within IBPSA.Fluid.PVTCollectors.Validation.BaseClasses;
model LongWaveRadiation
  extends .Modelica.Blocks.Icons.Block;

  // Parameters
  parameter .Modelica.Units.SI.Angle til "Surface tilt (0 for horizontally mounted collector)";
  constant .Modelica.Units.SI.DimensionlessRatio epsGro = 0.95 "ground emissivity [-]";
  // Constants for dew point calculation using Buck's equation [Buck, 1981]
  constant Real aBuck = 243.5 "Buck constant for dew point [°C]";
  constant Real bBuck = 17.67 "Buck constant for dew point [°C]";
  Real Tdew "Dew point temperature [°C]";
  Real epsSky "Clear sky emissivity [-]";

  // Real Inputs
  .Modelica.Blocks.Interfaces.RealInput Tamb(
    quantity="AmbientTemperature",
    unit="degC",
    displayUnit="degC") "Ambient temperature [°C]"
    annotation (Placement(transformation(extent={{-140,-108},{-100,-68}})));
  .Modelica.Blocks.Interfaces.RealInput rH(
    quantity="RelativeHumidity",
    unit="percentage",
    displayUnit="frac") "Relative Humidity [%]"
    annotation (Placement(transformation(extent={{-140,-64},{-100,-24}}),
        iconTransformation(extent={{-140,-64},{-100,-24}})));
  .Modelica.Blocks.Interfaces.RealInput patm(
    quantity="AtmosphericPressure",
    unit="bar",
    displayUnit="bar") "Atmospheric pressure [atm]"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  .Modelica.Blocks.Interfaces.RealInput Edif_h(
    quantity="DiffuseRadiationCollector",
    unit="W/m2",
    displayUnit="kJ/hr.m²") "Diffuse horizontal irradiation [W/m2]"
    annotation (Placement(transformation(extent={{-140,24},{-100,64}}),
        iconTransformation(extent={{-140,24},{-100,64}})));
  .Modelica.Blocks.Interfaces.RealInput Eglobh_h(
    quantity="TotalRadiationCollector",
    unit="W/m2",
    displayUnit="kJ/hr.m²") "global horizontal irradiation [W/m2]"
    annotation (Placement(transformation(extent={{-140,68},{-100,108}}),
        iconTransformation(extent={{-140,68},{-100,108}})));

  // Outputs
  .Modelica.Blocks.Interfaces.RealOutput lonRad(
    quantity="LongwaveRadiation",
    unit="W/m2",
    displayUnit="W/m2") "Longwave radiation [W/m²]"
    annotation (Placement(transformation(extent={{100,-16},{134,18}}),
        iconTransformation(extent={{100,-16},{134,18}})));

equation
   // Calculate Dew Point Temperature (Tdew) using Buck's equation [Buck, 1981]
  Tdew = (aBuck * (bBuck * (Tamb - 273.15) / (aBuck + (Tamb - 273.15)) + log(rH/100))) /
         (bBuck - (bBuck * (Tamb - 273.15) / (aBuck + (Tamb - 273.15)) + log(rH/100)));

  // Clear Sky Emissivity (epsEmi)
  epsSky = 0.711 + 0.56 * (Tdew/100) + 0.73 * (Tdew/100)^2;

  // Calculate Longwave Radiation (lonRad) using Tview and the Stefan-Boltzmann Law
  lonRad = .Modelica.Constants.sigma*Tamb^4*((epsSky*(1 + cos(til)) / 2) + (epsGro*(1 - cos(til)) / 2));
annotation (
  defaultComponentName="LongWaveRad",
  Documentation(info="<html>
<p>
Computes longwave radiation exchange between the sky and a tilted surface using ambient meteorological inputs. 
The model estimates sky emissivity based on the dew point temperature derived from ambient temperature and relative humidity, 
following Buck's equation. It then applies the Stefan–Boltzmann law to calculate the net longwave radiation on a tilted surface, 
accounting for both sky and ground contributions.
</p>

<h4>Implementation Notes</h4>
<p>
This model is used in the validation of unglazed photovoltaic–thermal (PVT) collectors 
(<a href=\"modelica://IDEAS.Fluid.PVTCollectors.Validation.PVT_UI.PVTCollectorValidation\">
IDEAS.Fluid.PVTCollectors.Validation.PVT_UI.PVTQuasiDynamicCollectorValidation</a>) 
where direct longwave irradiance measurements are unreliable or unavailable. It assumes a ground emissivity of 0.95. 
The clear-sky emissivity is calculated using an empirical correlation based on the dew point temperature. 
The model is particularly useful in dynamic simulations where longwave radiation must be estimated from standard meteorological data.
</p>

<h4>References</h4>
<ul>
<li>
Buck, A.L., <i>New equations for computing vapor pressure and enhancement factor</i>, 
Journal of Applied Meteorology, 1981.
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
</html>", revisions=
"<html>
<ul>
<li>
July 7, 2025, by Lone Meertens:<br/>
First implementation PVT model.
This is for <a href=\"https://github.com/open-ideas/IDEAS/issues/1436\">#1436</a>.
</li>
</ul>
</html>"));
end LongWaveRadiation;

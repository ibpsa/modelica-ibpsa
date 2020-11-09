within IBPSA.Media.Examples;
model SteamSaturationConsistencyCheck
  "Model that checks the consistency of saturated property functions"
  extends Modelica.Icons.Example;

  package MediumSte = IBPSA.Media.Steam "Steam medium model";
  package MediumWat = IBPSA.Media.Water "Liquid water medium model";

  parameter Modelica.SIunits.Temperature TMin = 273.15+100
    "Minimum temperature for the simulation";
  parameter Modelica.SIunits.Temperature TMax = 273.15+179.886
      "Maximum temperature for the simulation";
  parameter Real tol = 1E-8 "Numerical tolerance";

  MediumSte.ThermodynamicState sat "Saturation state";
  Modelica.SIunits.Pressure pSat "Saturation pressure";
  Modelica.SIunits.Temperature TSat0 "Starting saturation temperature";
  Modelica.SIunits.Temperature TSat "Saturation temperature";
  Modelica.SIunits.Conversions.NonSIunits.Temperature_degC TSat_degC
    "Celsius saturation temperature";
  Modelica.SIunits.SpecificEnthalpy hlvIF97 "Enthalpy of vaporization, IF97 formulation";
  Modelica.SIunits.SpecificEnthalpy hlvWatSte "Enthalpy of vaporization, water and steam medium models";
  Modelica.SIunits.SpecificEnthalpy hlIF97 "Enthalpy of saturated liquid, IF97";
  Modelica.SIunits.SpecificEnthalpy hlWat "Enthalpy of saturated liquid, water medium";
  Modelica.SIunits.SpecificEnthalpy hvIF97 "Enthalpy of saturated vapor, IF97";
  Modelica.SIunits.SpecificEnthalpy hvSte "Enthalpy of saturated vapor, steam medium";

  Real hlvErr "Enthalpy of vaporization percent error";
  Real hlErr "Enthalpy of saturated liquid percent error";
  Real hvErr "Enthalpy of saturated vapor percent error";

protected
  constant Real conv(unit="1/s") = 1 "Conversion factor to satisfy unit check";

equation
  // Compute temperatures that are used as input to the functions
  TSat0 = TMin + conv*time * (TMax-TMin);

  // Set saturation states
//  pSat = MediumSte.saturationPressure(TSat);
  pSat = MediumSte.saturationPressure(TSat0);
  TSat = MediumSte.saturationTemperature(pSat);
  if (time>0.1) then
  assert(abs(TSat-TSat0)<tol, "Error in implementation of functions.\n"
     + "   TSat0 = " + String(TSat0) + "\n"
     + "   TSat  = " + String(TSat) + "\n"
     + "   Absolute error: " + String(abs(TSat-TSat0)) + " K");
  end if;
  TSat_degC = Modelica.SIunits.Conversions.to_degC(TSat);
  sat = MediumSte.setState_pTX(p=pSat, T=TSat, X=MediumSte.X_default);

  hlvIF97 = MediumSte.enthalpyOfVaporization(TSat);
  hlvWatSte = MediumSte.specificEnthalpy(sat) - MediumWat.specificEnthalpy(sat);
  hlIF97 = MediumSte.enthalpyOfSaturatedLiquid(TSat);
  hlWat = MediumWat.specificEnthalpy(sat);
  hvIF97 = MediumSte.enthalpyOfSaturatedVapor(TSat);
  hvSte = MediumSte.specificEnthalpy(sat);

  hlvErr = abs(hlvIF97 - hlvWatSte)/hlvIF97*100;
  hlErr = abs(hlIF97 - hlWat)/hlIF97*100;
  hvErr = abs(hvIF97 - hvSte)/hvIF97*100;

  annotation (experiment(Tolerance=1e-6, StopTime=1.0),
  __Dymola_Commands(file="modelica://IBPSA/Resources/Scripts/Dymola/Media/Examples/SteamSaturationConsistencyCheck.mos"
        "Simulate and plot"),
  Icon(coordinateSystem(preserveAspectRatio=false)),
  Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html>
<ul>
<li>
November 8, 2020, by Kathryn Hinkelman:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
This example checks the consistency of satuated property functions across the steam and liquid water mediums. 
It also checks if the inversion of saturated temperature and saturated pressure is implemented correctly 
for the steam model.
</p>
<p>
Errors are presented as percent differences between the standard property functions - 
e.g medium.specificEnthalpy(saturatedState) - and the IF97 saturated property functions as the baseline.
</p>
</html>"));
end SteamSaturationConsistencyCheck;

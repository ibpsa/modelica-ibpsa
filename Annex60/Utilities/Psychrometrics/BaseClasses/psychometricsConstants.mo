within Annex60.Utilities.Psychrometrics.BaseClasses;
partial block psychometricsConstants
  "Constants used by the psychometrics functions"
protected
  constant Modelica.SIunits.SpecificHeatCapacity cpAir=1006
    "Specific heat capacity of air";
  constant Modelica.SIunits.SpecificHeatCapacity cpSte=1860
    "Specific heat capacity of water vapor";
  constant Modelica.SIunits.SpecificEnthalpy h_fg = 2501014.5
    "Enthalpy of evaporator of water"; //fixme: according to wikipedia: h_fg = 2260000
  constant Real k_mair = 0.6219647130774989 "Ratio of molar weights";
end psychometricsConstants;

within IBPSA.Media.Interfaces;
partial package PartialPureSubstanceWithSat
  "Partial pure substance model with saturation state functions"
  extends Modelica.Media.Interfaces.PartialPureSubstance;

  replaceable partial function saturationState_p
    "Return saturation property record from pressure"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    output SaturationProperties sat "Saturation property record";
  end saturationState_p;

  replaceable partial function saturationTemperature_p
    "Return saturation temperature"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    output Temperature T "Saturation temperature";
  end saturationTemperature_p;

  replaceable partial function enthalpyOfSaturatedLiquid_sat
    "Return enthalpy of saturated liquid"
    extends Modelica.Icons.Function;
    input SaturationProperties sat "Saturation property record";
    output SpecificEnthalpy hl "Boiling curve specific enthalpy";
  end enthalpyOfSaturatedLiquid_sat;

  replaceable partial function enthalpyOfSaturatedVapor_sat
    "Return enthalpy of saturated vapor"
    extends Modelica.Icons.Function;
    input SaturationProperties sat "Saturation property record";
    output SpecificEnthalpy hv "Dew curve specific enthalpy";
  end enthalpyOfSaturatedVapor_sat;

  replaceable partial function enthalpyOfVaporization_sat
    "Return enthalpy of vaporization"
    extends Modelica.Icons.Function;
    input SaturationProperties sat "Saturation property record";
    output SpecificEnthalpy hlv "Vaporization enthalpy";
  end enthalpyOfVaporization_sat;

  replaceable partial function entropyOfSaturatedLiquid_sat
    "Return entropy of saturated liquid"
    extends Modelica.Icons.Function;
    input SaturationProperties sat "Saturation property record";
    output SpecificEntropy sl "Boiling curve specific entropy";
  end entropyOfSaturatedLiquid_sat;

  replaceable partial function entropyOfSaturatedVapor_sat
    "Return entropy of saturated vapor"
    extends Modelica.Icons.Function;
    input SaturationProperties sat "Saturation property record";
    output SpecificEntropy sv "Dew curve specific entropy";
  end entropyOfSaturatedVapor_sat;

  replaceable partial function entropyOfVaporization_sat
    "Return entropy of vaporization"
    extends Modelica.Icons.Function;
    input SaturationProperties sat "Saturation property record";
    output SpecificEntropy slv "Vaporization entropy";
  end entropyOfVaporization_sat;

  replaceable partial function densityOfSaturatedLiquid_sat
       "Return density of saturated liquid"
    extends Modelica.Icons.Function;
    input SaturationProperties sat "Saturation property record";
    output Density dl "Boiling curve density";
  end densityOfSaturatedLiquid_sat;

  replaceable partial function densityOfSaturatedVapor_sat
    "Return density of saturated vapor"
    extends Modelica.Icons.Function;
    input SaturationProperties sat "Saturation property record";
    output Density dv "Dew curve density";
  end densityOfSaturatedVapor_sat;
end PartialPureSubstanceWithSat;

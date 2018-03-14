within IBPSA.Media.SecondaryFluid;
package PropyleneGlycolWater "Package with model for propylene glycol - water with constant properties"
  extends Modelica.Icons.VariantsPackage;

  constant Modelica.SIunits.Temperature property_T
    "Temperature for evaluation of constant fluid properties";
  constant Modelica.SIunits.MassFraction massFraction
    "Mass fraction of propylene glycol in water";
  constant Modelica.SIunits.MassFraction massFraction_min=0.
    "Minimum allowed mass fraction of propylene glycol in water";
  constant Modelica.SIunits.MassFraction massFraction_max=0.6
    "Maximum allowed mass fraction of propylene glycol in water";

  // Fluid constants based on pure Propylene Glycol
  constant Modelica.Media.Interfaces.Types.Basic.FluidConstants[1]
    simplePropyleneGlycolWaterConstants(
    each chemicalFormula="C3H8O2",
    each structureFormula="CH3CH(OH)CH2OH",
    each casRegistryNumber="57-55-6",
    each iupacName="1,2-Propylene glycol",
    each molarMass=0.07609);

  extends Modelica.Media.Interfaces.PartialSimpleMedium(
    mediumName="SimplePropyleneGlycolWater",
    final cp_const=BaseClasses.specificHeatCapacityCp(massFraction,property_T),
    final cv_const=cp_const,
    final d_const=BaseClasses.density(massFraction,property_T),
    final eta_const=BaseClasses.dynamicViscosity(massFraction,property_T),
    final lambda_const=BaseClasses.thermalConductivity(massFraction,property_T),
    a_const=1484,
    final T_min=BaseClasses.fusionTemperature(massFraction,property_T),
    final T_max=Modelica.SIunits.Conversions.from_degC(100),
    T0=273.15,
    MM_const=(massFraction/0.07609+(1-massFraction)/0.018015268)^(-1),
    fluidConstants=simplePropyleneGlycolWaterConstants,
    p_default=300000,
    reference_p=300000,
    reference_T=273.15,
    reference_X={1},
    AbsolutePressure(start=p_default),
    Temperature(start=T_default),
    Density(start=d_const));

  redeclare model BaseProperties "Base properties"
    Temperature T(stateSelect=
      if preferredMediumStates then StateSelect.prefer else StateSelect.default)
      "Temperature of medium";
    InputAbsolutePressure p "Absolute pressure of medium";
    InputMassFraction[nXi] Xi=fill(0, 0)
      "Structurally independent mass fractions";
    InputSpecificEnthalpy h "Specific enthalpy of medium";
    Modelica.SIunits.SpecificInternalEnergy u
      "Specific internal energy of medium";
    Modelica.SIunits.Density d=d_const "Density of medium";
    Modelica.SIunits.MassFraction[nX] X={1}
      "Mass fractions (= (component mass)/total mass  m_i/m)";
    final Modelica.SIunits.SpecificHeatCapacity R=0
      "Gas constant (of mixture if applicable)";
    final Modelica.SIunits.MolarMass MM=MM_const
      "Molar mass (of mixture or single fluid)";
    ThermodynamicState state
      "Thermodynamic state record for optional functions";
    parameter Boolean preferredMediumStates=false
      "= true if StateSelect.prefer shall be used for the independent property variables of the medium"
      annotation(Evaluate=true, Dialog(tab="Advanced"));
    final parameter Boolean standardOrderComponents=true
      "If true, and reducedX = true, the last element of X will be computed from the other ones";
    Modelica.SIunits.Conversions.NonSIunits.Temperature_degC T_degC=
        Modelica.SIunits.Conversions.to_degC(T)
      "Temperature of medium in [degC]";
    Modelica.SIunits.Conversions.NonSIunits.Pressure_bar p_bar=
        Modelica.SIunits.Conversions.to_bar(p)
      "Absolute pressure of medium in [bar]";

    // Local connector definition, used for equation balancing check
    connector InputAbsolutePressure = input Modelica.SIunits.AbsolutePressure
      "Pressure as input signal connector";
    connector InputSpecificEnthalpy = input Modelica.SIunits.SpecificEnthalpy
      "Specific enthalpy as input signal connector";
    connector InputMassFraction = input Modelica.SIunits.MassFraction
      "Mass fraction as input signal connector";

  equation
    assert(T >= T_min and T <= T_max, "
Temperature T (= " + String(T) + " K) is not
in the allowed range (" + String(T_min) + " K <= T <= " + String(T_max) + " K)
required from medium model \"" + mediumName + "\".
"); assert(massFraction >= massFraction_min and massFraction <= massFraction_max, "
    Mass fraction massFraction (= " + String(massFraction) + " ) is not
in the allowed range (" + String(massFraction_min) + " <= massFraction <= " + String(massFraction_max) + " )
required from medium model \"" + mediumName + "\".
");

    h = cp_const*(T-reference_T);
    u = h;
    state.T = T;
    state.p = p;
    annotation(Documentation(info="<html>
    <p>
    fixme.
    </p>
</html>"));
  end BaseProperties;

end PropyleneGlycolWater;

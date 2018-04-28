within IBPSA.Media.Antifreeze;
package PropyleneGlycolWater
  "Package with model for propylene glycol - water with constant properties"
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
    final cp_const=IBPSA.Media.Antifreeze.PropyleneGlycolWater.BaseClasses.specificHeatCapacityCp(massFraction,property_T),
    final cv_const=cp_const,
    final d_const=IBPSA.Media.Antifreeze.PropyleneGlycolWater.BaseClasses.density(massFraction,property_T),
    final eta_const=IBPSA.Media.Antifreeze.PropyleneGlycolWater.BaseClasses.dynamicViscosity(massFraction,property_T),
    final lambda_const=IBPSA.Media.Antifreeze.PropyleneGlycolWater.BaseClasses.thermalConductivity(massFraction,property_T),
    a_const=1484,
    final T_min=IBPSA.Media.Antifreeze.PropyleneGlycolWater.BaseClasses.fusionTemperature(massFraction,property_T),
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
");
    assert(massFraction >= massFraction_min and massFraction <= massFraction_max, "
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
    This base properties model is identical to
    <a href=\"modelica://Modelica.Media.Water.ConstantPropertyLiquidWater\">
    Modelica.Media.Water.ConstantPropertyLiquidWater</a>,
    except that the equation
    <code>u = cv_const*(T - reference_T)</code>
    has been replaced by <code>u=h</code> because
    <code>cp_const=cv_const</code>.
    Also, the model checks if the mass fraction of the mixture is within the
    allowed limits.
    </p>
</html>"));
  end BaseProperties;

annotation(preferredView="info", Documentation(info="<html>
<p>
This medium package models propylene glycol - water mixtures.
</p>
<p>
The mass density, specific heat capacity, thermal conductivity and viscosity
are assumed constant and evaluated at a set temperature and mass fraction of
propylene glycol within the mixture. The dependence of the four properties
are shown on the figure below.
</p>
<p align=\"center\">
<img src=\"modelica://IBPSA/Resources/Images/Media/Antifreeze/PropyleneGlycolWaterProperties.png\" border=\"1\"
alt=\"Relative variation of specific heat capacity with temperature\"/>
</p>
<p>
The accuracy of the thermophysical properties is dependent on the temperature
variations encountered during simulations.
The figure below shows the relative error of the the four properties over a
<i>10</i> &deg;C range around the temperature used to evaluate the constant
proepties. The maximum errors are <i>0.8</i> % for mass density, <i>1.5</i> %
for specific heat capacity, <i>3.2</i> % for thermal conductivity and <i>250</i>
% for dynamic viscosity.
</p>
<p align=\"center\">
<img src=\"modelica://IBPSA/Resources/Images/Media/Antifreeze/PropyleneGlycolWaterError10degC.png\" border=\"1\"
alt=\"Relative variation of specific heat capacity with temperature\"/>
</p>
<p>
The figure below shows the relative error of the the four properties over a
<i>20</i> &deg;C range around the temperature used to evaluate the constant
proepties. The maximum errors are <i>1.6</i> % for mass density, <i>3.0</i> %
for specific heat capacity, <i>6.2</i> % for thermal conductivity and <i>950</i>
% for dynamic viscosity.
</p>
<p align=\"center\">
<img src=\"modelica://IBPSA/Resources/Images/Media/Antifreeze/PropyleneGlycolWaterError20degC.png\" border=\"1\"
alt=\"Relative variation of specific heat capacity with temperature\"/>
</p>
<p>
The enthalpy is computed using the convention that <i>h=0</i>
if <i>T=0</i> &deg;C.
</p>
<h4>Limitations</h4>
<p>
Density, specific heat capacity, thermal conductivity and viscosity are constant.
The propylene glycol/water mixture is modeled as an incompressible liquid.
There are no phase changes. The medium is limited to temperatures below
<i>100</i> &deg;C and mass fractions below <i>0.60</i>.
As is the case for IBPSA.Media.Water, this medium package should not be used if
the simulation relies on the dynamic viscosity.
</p>
<h4>Typical use and important parameters</h4>
<p>
The temperature and mass fraction must be specified for the evaluation of the
constant thermophysical properties. A typical use of the package is (e.g. for
a temperature of <i>20</i> &deg;C and a mass fraction of <i>0.40</i>):
</p>
<p>
<code>Medium = IBPSA.Media.Antifreeze.PropyleneGlycolWater(property_T=293.15, massFraction=0.40)</code>
</p>
</html>", revisions="<html>
<ul>
<li>
March 16, 2018, by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));
  package BaseClasses "Property evaluation functions for propylene glycol - water"
  extends Modelica.Icons.BasesPackage;

    function density "Evaluate density of propylene glycol - water"
      extends Modelica.Icons.Function;

      input Modelica.SIunits.MassFraction w "Mass fraction of propylene glycol";
      input Modelica.SIunits.Temperature T "Temperature of propylene glycol - water";

      output Modelica.SIunits.Density d "Density of propylene glycol - water";

    protected
      Modelica.SIunits.MassFraction wm=30.7031 "Reference mass fraction";
      Modelica.SIunits.Temperature Tm=32.7089 "Reference temperature";
      Integer nw=6 "Order of polynomial in x";
      Integer nT[nw]={4,4,4,3,2,1} "Order of polynomial in y";
      Real coeff[18]={1.018e3, -5.406e-1, -2.666e-3, 1.347e-5, 7.604e-1, -9.450e-3, 5.541e-5, -1.343e-7, -2.498e-3, 2.700e-5, -4.018e-7, 3.376e-9, -1.550e-4, 2.829e-6, -7.175e-9, -1.131e-6, -2.221e-8, 2.342e-8}
        "Polynomial coefficients";

    algorithm

      d := IBPSA.Media.Antifreeze.BaseClasses.polynomialProperty(
        w*100,
        Modelica.SIunits.Conversions.to_degC(T),
        wm,
        Tm,
        nw,
        nT,
        coeff);
    annotation (
    Documentation(info="<html>
    <p>
    Density of propylene glycol - water at specified mass fraction and temperature,
    based on Melinder (2010).
    </p>
    <h4>References</h4>
    <p>
    Melinder, &#197;ke. 2010. Properties of Secondary Working Fluids (Secondary
    Refrigerants or Coolants, Heat Transfer Fluids) for Indirect Systems. Paris:
    IIR/IIF.
    </p>
    </html>", revisions="<html>
    <ul>
    <li>
    March 16, 2018 by Massimo Cimmino:<br/>
    First implementation.
    This function is used by
    <a href=\"modelica://IBPSA.Media.Antifreeze.PropyleneGlycolWater\">
    IBPSA.Media.Antifreeze.PropyleneGlycolWater</a>.
    </li>
    </ul>
    </html>"));
    end density;

    function dynamicViscosity
      "Evaluate dynamic viscosity of propylene glycol - water"
      extends Modelica.Icons.Function;

      input Modelica.SIunits.MassFraction w "Mass fraction of propylene glycol";
      input Modelica.SIunits.Temperature T "Temperature of propylene glycol - water";

      output Modelica.SIunits.DynamicViscosity eta "Dynamic Viscosity of propylene glycol - water";

    protected
      Modelica.SIunits.MassFraction wm=30.7031 "Reference mass fraction";
      Modelica.SIunits.Temperature Tm=32.7089 "Reference temperature";
      Integer nw=6 "Order of polynomial in x";
      Integer nT[nw]={4,4,4,3,2,1} "Order of polynomial in y";
      Real coeff[18]={6.837e-1, -3.045e-2, 2.525e-4, -1.399e-6, 3.328e-2, -3.984e-4, 4.332e-6, -1.860e-8, 5.453e-5, -8.600e-8, -1.593e-8, -4.465e-11, -3.900e-6, 1.054e-7, -1.589e-9, -1.587e-8, 4.475e-10, 3.564e-9}
        "Polynomial coefficients";

    algorithm

      eta := 1e-3*exp(IBPSA.Media.Antifreeze.BaseClasses.polynomialProperty(
        w*100,
        Modelica.SIunits.Conversions.to_degC(T),
        wm,
        Tm,
        nw,
        nT,
        coeff));
    annotation (
    Documentation(info="<html>
    <p>
    Dynamic viscosity of propylene glycol - water at specified mass fraction and
    temperature, based on Melinder (2010).
    </p>
    <h4>References</h4>
    <p>
    Melinder, &#197;ke. 2010. Properties of Secondary Working Fluids (Secondary
    Refrigerants or Coolants, Heat Transfer Fluids) for Indirect Systems. Paris:
    IIR/IIF.
    </p>
    </html>", revisions="<html>
    <ul>
    <li>
    March 16, 2018 by Massimo Cimmino:<br/>
    First implementation.
    This function is used by
    <a href=\"modelica://IBPSA.Media.Antifreeze.PropyleneGlycolWater\">
    IBPSA.Media.Antifreeze.PropyleneGlycolWater</a>.
    </li>
    </ul>
    </html>"));
    end dynamicViscosity;

    function fusionTemperature
      "Evaluate temperature of fusion of propylene glycol - water"
      extends Modelica.Icons.Function;

      input Modelica.SIunits.MassFraction w "Mass fraction of propylene glycol";
      input Modelica.SIunits.Temperature T "Temperature of propylene glycol - water";

      output Modelica.SIunits.Temperature Tf "Temperature of fusion of propylene glycol - water";

    protected
      Modelica.SIunits.MassFraction wm=30.7031 "Reference mass fraction";
      Modelica.SIunits.Temperature Tm=32.7089 "Reference temperature";
      Integer nw=6 "Order of polynomial in x";
      Integer nT[nw]={4,4,4,3,2,1} "Order of polynomial in y";
      Real coeff[18]={-1.325e1, -3.820e-5, 7.865e-7, -1.733e-9, -6.631e-1, 6.774e-6, -6.242e-8, -7.819e-10, -1.094e-2, 5.332e-8, -4.169e-9, 3.288e-11, -2.283e-4, -1.131e-8, 1.918e-10, -3.409e-6, 8.035e-11, 1.465e-8}
        "Polynomial coefficients";

    algorithm

      Tf := Modelica.SIunits.Conversions.from_degC(
        IBPSA.Media.Antifreeze.BaseClasses.polynomialProperty(
        w*100,
        Modelica.SIunits.Conversions.to_degC(T),
        wm,
        Tm,
        nw,
        nT,
        coeff));
    annotation (
    Documentation(info="<html>
    <p>
    fusion temperature of propylene glycol - water at specified mass fraction and
    temperature, based on Melinder (2010).
    </p>
    <h4>References</h4>
    <p>
    Melinder, &#197;ke. 2010. Properties of Secondary Working Fluids (Secondary
    Refrigerants or Coolants, Heat Transfer Fluids) for Indirect Systems. Paris:
    IIR/IIF.
    </p>
    </html>", revisions="<html>
    <ul>
    <li>
    March 16, 2018 by Massimo Cimmino:<br/>
    First implementation.
    This function is used by
    <a href=\"modelica://IBPSA.Media.Antifreeze.PropyleneGlycolWater\">
    IBPSA.Media.Antifreeze.PropyleneGlycolWater</a>.
    </li>
    </ul>
    </html>"));
    end fusionTemperature;

    function specificHeatCapacityCp
      "Evaluate specific heat capacity of propylene glycol - water"
      extends Modelica.Icons.Function;

      input Modelica.SIunits.MassFraction w "Mass fraction of propylene glycol";
      input Modelica.SIunits.Temperature T "Temperature of propylene glycol - water";

      output Modelica.SIunits.SpecificHeatCapacity cp "Specific heat capacity of propylene glycol - water";

    protected
      Modelica.SIunits.MassFraction wm=30.7031 "Reference mass fraction";
      Modelica.SIunits.Temperature Tm=32.7089 "Reference temperature";
      Integer nw=6 "Order of polynomial in x";
      Integer nT[nw]={4,4,4,3,2,1} "Order of polynomial in y";
      Real coeff[18]={3.882e3, 2.699e0, -1.659e-3, -1.032e-5, -1.304e1, 5.070e-2, -4.752e-5, 1.522e-6, -1.598e-1, 9.534e-5, 1.167e-5, -4.870e-8, 3.539e-4, 3.102e-5, -2.950e-7, 5.000e-5, -7.135e-7, -4.959e-7}
        "Polynomial coefficients";

    algorithm

      cp := IBPSA.Media.Antifreeze.BaseClasses.polynomialProperty(
        w*100,
        Modelica.SIunits.Conversions.to_degC(T),
        wm,
        Tm,
        nw,
        nT,
        coeff);
    annotation (
    Documentation(info="<html>
    <p>
    Specific heat capacity of propylene glycol - water at specified mass fraction
    and temperature, based on Melinder (2010).
    </p>
    <h4>References</h4>
    <p>
    Melinder, &#197;ke. 2010. Properties of Secondary Working Fluids (Secondary
    Refrigerants or Coolants, Heat Transfer Fluids) for Indirect Systems. Paris:
    IIR/IIF.
    </p>
    </html>", revisions="<html>
    <ul>
    <li>
    March 16, 2018 by Massimo Cimmino:<br/>
    First implementation.
    This function is used by
    <a href=\"modelica://IBPSA.Media.Antifreeze.PropyleneGlycolWater\">
    IBPSA.Media.Antifreeze.PropyleneGlycolWater</a>.
    </li>
    </ul>
    </html>"));
    end specificHeatCapacityCp;

    function thermalConductivity
      "Evaluate thermal conductivity of propylene glycol - water"
      extends Modelica.Icons.Function;

      input Modelica.SIunits.MassFraction w "Mass fraction of propylene glycol";
      input Modelica.SIunits.Temperature T "Temperature of propylene glycol - water";

      output Modelica.SIunits.ThermalConductivity lambda "Thermal conductivity of propylene glycol - water";

    protected
      Modelica.SIunits.MassFraction wm=30.7031 "Reference mass fraction";
      Modelica.SIunits.Temperature Tm=32.7089 "Reference temperature";
      Integer nw=6 "Order of polynomial in x";
      Integer nT[nw]={4,4,4,3,2,1} "Order of polynomial in y";
      Real coeff[18]={4.513e-1, 7.955e-4, 3.482e-8, -5.966e-9, -4.795e-3, -1.678e-5, 8.941e-8, 1.493e-10, 2.076e-5, 1.563e-7, -4.615e-9, 9.897e-12, -9.083e-8, -2.518e-9, 6.543e-11, -5.952e-10, -3.605e-11, 2.104e-11}
        "Polynomial coefficients";

    algorithm

      lambda := IBPSA.Media.Antifreeze.BaseClasses.polynomialProperty(
        w*100,
        Modelica.SIunits.Conversions.to_degC(T),
        wm,
        Tm,
        nw,
        nT,
        coeff);
    annotation (
    Documentation(info="<html>
    <p>
    Thermal conductivity of propylene glycol - water at specified mass fraction and
    temperature, based on Melinder (2010).
    </p>
    <h4>References</h4>
    <p>
    Melinder, &#197;ke. 2010. Properties of Secondary Working Fluids (Secondary
    Refrigerants or Coolants, Heat Transfer Fluids) for Indirect Systems. Paris:
    IIR/IIF.
    </p>
    </html>", revisions="<html>
    <ul>
    <li>
    March 16, 2018 by Massimo Cimmino:<br/>
    First implementation.
    This function is used by
    <a href=\"modelica://IBPSA.Media.Antifreeze.PropyleneGlycolWater\">
    IBPSA.Media.Antifreeze.PropyleneGlycolWater</a>.
    </li>
    </ul>
    </html>"));
    end thermalConductivity;

    annotation (preferredView="info", Documentation(info="<html>
  <p>
  This package contains functions to evaluate the temperature- and
  concentration-dependent themophysical properties of propylene glycol-water
  mixtures.
  </p>
  </html>"));
  end BaseClasses;
end PropyleneGlycolWater;

within Annex60.Media;
package Water "Package with model for liquid water with constant properties"
   extends Modelica.Media.Interfaces.PartialPureSubstance(
     mediumName="Water",
     p_default=300000,
     reference_p=300000,
     reference_T=273.15,
     reference_X={1},
     final singleState=true,
     ThermoStates=Modelica.Media.Interfaces.Choices.IndependentVariables.T);

  redeclare record FluidConstants =
    Modelica.Media.Interfaces.Types.Basic.FluidConstants (
    each chemicalFormula="H2O",
    each structureFormula="H2O",
    each casRegistryNumber="7732-18-5",
    each iupacName="oxidane",
    each molarMass=MM_const);

  redeclare record extends ThermodynamicState "Thermodynamic state variables"
    Modelica.SIunits.Temperature T "Temperature of medium";
    Modelica.SIunits.AbsolutePressure p "Pressure of medium";
  end ThermodynamicState;

  constant Modelica.SIunits.SpecificHeatCapacity cp_const = 4148
    "Specific heat capacity at constant pressure";

  redeclare model extends BaseProperties(
     T(stateSelect=if
          preferredMediumStates then StateSelect.prefer else StateSelect.default),
     p(stateSelect=if
          preferredMediumStates then StateSelect.prefer else StateSelect.default),
     preferredMediumStates=true) "Base properties"
  equation
    h = (T - reference_T)*cp_const;
    u = h;
    d = density(state);
    state.T = T;
    state.p = p;
    R=0;
    MM=MM_const;
    annotation (Documentation(info="<html>
    <p>
    Base properties of the medium.
    </p>
</html>"));
  end BaseProperties;

redeclare function extends density "Gas density"
  protected
  Modelica.SIunits.Conversions.NonSIunits.Temperature_degC T_degC=
   Modelica.SIunits.Conversions.to_degC(state.T) "fixme";
algorithm
  // fixme: IDA uses T_degC = max(0, T_degC); We should keep rho constant at its inflection points
  // (both at low and high temperatures)
  d := 1000.12 + 1.43711e-2*T_degC -
       5.83576e-3*T_degC^2 + 1.5009e-5*T_degC^3;
    // fixme. Convert to use Kelvin
  annotation (smoothOrder=2,
Documentation(info="<html>
<p>
This function computes density as a function of temperature and humidity content.
</p>
</html>",
revisions="<html>
<ul>
<li>
December 11, 2013, by Michael Wetter:<br/>
First implementation, based on the IDA implementation in <code>therpro.nmf</code>, 
but converted from Celsius to Kelvin.
</li>
</ul>
</html>"));
end density;

redeclare function extends dynamicViscosity "dynamic viscosity of dry air"
algorithm
  // fixme: These two polynomials should be collapsed into one.
  eta := density(state)*kinematicViscosity(state.T);
annotation (
Documentation(info="<html>
<p>
This function returns a constant value for the dynamic viscosity.
</p>
</html>",
revisions="<html>
<ul>
<li>
December 2, 2013, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end dynamicViscosity;

redeclare function extends specificEnthalpy "Return specific enthalpy"
algorithm
  h := (state.T - reference_T)*cp_const;
annotation(smoothOrder=5,
Documentation(info="<html>
<p>
This function computes the specific enthalpy.
</p>
</html>",
revisions="<html>
<ul>
<li>
December 11, 2013, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end specificEnthalpy;

function enthalpyOfLiquid
    "Enthalpy of liquid (per unit mass of liquid) which is linear in the temperature"
  extends Modelica.Icons.Function;
  input Modelica.SIunits.Temperature T "Temperature";
  output Modelica.SIunits.SpecificEnthalpy h "Liquid enthalpy";
algorithm
  h := (T - reference_T)*cp_const;
  annotation(smoothOrder=5, derivative=der_enthalpyOfLiquid,
Documentation(info="<html>
<p>
This function computes the specific enthalpy of liquid water.
</p>
</html>",
revisions="<html>
<ul>
<li>
December 2, 2013, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end enthalpyOfLiquid;

redeclare function extends specificInternalEnergy "Return specific enthalpy"
algorithm
  u := (state.T - reference_T)*cp_const;
annotation(smoothOrder=5,
Documentation(info="<html>
<p>
This function computes the specific internal energy.
</p>
</html>",
revisions="<html>
<ul>
<li>
December 11, 2013, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end specificInternalEnergy;

  redeclare function extends specificEntropy "Return specific entropy"
    extends Modelica.Icons.Function;
  algorithm
    s := cv_const*Modelica.Math.log(state.T/273.15);
  end specificEntropy;

  redeclare function extends specificGibbsEnergy "Return specific Gibbs energy"
    extends Modelica.Icons.Function;
  algorithm
    g := specificEnthalpy(state) - state.T*specificEntropy(state);
  end specificGibbsEnergy;

  redeclare function extends specificHelmholtzEnergy
    "Return specific Helmholtz energy"
    extends Modelica.Icons.Function;
  algorithm
    f := specificInternalEnergy(state) - state.T*specificEntropy(state);
  end specificHelmholtzEnergy;

  redeclare function extends isentropicEnthalpy "Return isentropic enthalpy"
  algorithm
    h_is := cp_const*(temperature(refState) - reference_T);
  end isentropicEnthalpy;

  redeclare function extends isobaricExpansionCoefficient
    "Returns overall the isobaric expansion coefficient beta"
  algorithm
    beta := 0.0;
  end isobaricExpansionCoefficient;

  redeclare function extends isothermalCompressibility
    "Returns overall the isothermal compressibility factor"
  algorithm
    assert(false, "fixme: isothermalCompressibility is not yet implemented.");

    kappa := 0;
  end isothermalCompressibility;

  redeclare function extends density_derp_T
    "Returns the partial derivative of density with respect to pressure at constant temperature"
  algorithm
    ddpT := 0;
  end density_derp_T;

  redeclare function extends density_derT_p
    "Returns the partial derivative of density with respect to temperature at constant pressure"
  algorithm
  assert(false, "density_derT_p is not yet implemented.");
    ddTp := 0;
  end density_derT_p;

  redeclare function extends density_derX
    "Returns the partial derivative of density with respect to mass fractions at constant pressure and temperature"
  algorithm
    dddX := fill(0, nX);
  end density_derX;

redeclare replaceable function extends specificHeatCapacityCp
    "Specific heat capacity of gas mixture at constant pressure"
algorithm
  cp := cp_const;
    annotation(derivative=der_specificHeatCapacityCp,
Documentation(info="<html>
<p>
This function returns the specific heat capacity at constant pressure.
</p>
</html>",
revisions="<html>
<ul>
<li>
December 11, 2013, by Michael Wetter:<br/>
</li>
</ul>
</html>"));
end specificHeatCapacityCp;

redeclare replaceable function extends specificHeatCapacityCv
    "Specific heat capacity of gas mixture at constant volume"
algorithm
  cv := cp_const;
    annotation(derivative=der_specificHeatCapacityCp,
Documentation(info="<html>
<p>
This function computes the specific heat capacity at constant volume.
</p>
</html>",
revisions="<html>
<ul>
<li>
December 11, 2013, by Michael Wetter:<br/>
</li>
</ul>
</html>"));
end specificHeatCapacityCv;

///////
  redeclare function extends thermalConductivity "Return thermal conductivity"

  algorithm
    lambda := lambda_const;
  end thermalConductivity;

  redeclare function extends pressure "Return pressure"

  algorithm
    p := state.p;
  end pressure;

  redeclare function extends temperature "Return temperature"

  algorithm
    T := state.T;
  end temperature;

  redeclare function extends molarMass "Return the molar mass of the medium"
  algorithm
    MM := MM_const;
  end molarMass;

redeclare function setState_dTX
    "Return thermodynamic state as function of density d, temperature T and composition X"
  extends Modelica.Icons.Function;
  input Density d "Density";
  input Temperature T "Temperature";
  input MassFraction X[:]=reference_X "Mass fractions";
  output ThermodynamicState state "Thermodynamic state";

algorithm
    state := ThermodynamicState(p=reference_p, T=T);
    annotation (smoothOrder=99,
Documentation(info="<html>
<p>
This function returns the thermodynamic state for a given density, temperature and composition.
Because this medium assumes density to be a function of temperature only,
this function ignores the argument <code>d</code>.
The pressure that is used to set the state is equal to the constant
<code>reference_p</code>.
</p>
</html>",
revisions="<html>
<ul>
<li>
December 11, 2013, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end setState_dTX;

redeclare function extends setState_phX
    "Return thermodynamic state as function of pressure p, specific enthalpy h and composition X"
algorithm
  state := ThermodynamicState(p=p, T=temperature_phX(p, h, X));
  annotation (smoothOrder=99,
Documentation(info="<html>
<p>
This function returns the thermodynamic state for a given pressure, 
specific enthalpy and composition.
</p>
</html>",
revisions="<html>
<ul>
<li>
December 11, 2013, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end setState_phX;

redeclare function extends setState_pTX
    "Return thermodynamic state as function of p, T and composition X or Xi"
algorithm
    state := ThermodynamicState(p=p, T=T);
annotation (smoothOrder=99,
Documentation(info="<html>
<p>
This function returns the thermodynamic state for a given pressure, 
temperature and composition.
</p>
</html>",
revisions="<html>
<ul>
<li>
December 11, 2013, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end setState_pTX;

redeclare function extends setState_psX

  protected
    Modelica.SIunits.Temperature T "Temperature";
algorithm
    // The next line is obtained from symbolic solving the
    // specificEntropy function for T, i.e.,
    // s := cv_const*Modelica.Math.log(state.T/reference_T)
    T := 273.15 * Modelica.Math.exp(s/cv_const);
    state := ThermodynamicState(p=p, T=T);
  annotation (
    Inline=false,
    Documentation(info="<html>
    <p>
    This function returns the thermodynamic state based on pressure, 
    specific entropy and mass fraction.
    </p>
    <p>
    The state is computed by symbolically solving
    <a href=\"modelica://Annex60.Media.Water.specificEntropy\">
    Annex60.Media.Water.specificEntropy</a>
    for temperature.
      </p>
</html>", revisions="<html>
<ul>
<li>
December 11, 2013, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end setState_psX;

  /////////////////////////////////////////////////////////////////////////////////

protected
  final constant Modelica.SIunits.SpecificHeatCapacity cv_const = cp_const
    "Specific heat capacity at constant volume";
  constant Modelica.SIunits.ThermalConductivity lambda_const=0.598
    "Constant thermal conductivity";
  constant Modelica.SIunits.VelocityOfSound a_const=1484
    "Constant velocity of sound";
  constant Modelica.SIunits.MolarMass MM_const=0.018015268 "Molar mass";

replaceable function der_specificHeatCapacityCp
    "Derivative of specific heat capacity at constant pressure"
  extends Modelica.Icons.Function;
    input ThermodynamicState state "Thermodynamic state";
    input ThermodynamicState der_state "Derivative of thermodynamic state";
    output Real der_cp(unit="J/(kg.K.s)")
      "Derivative of specific heat capacity";
algorithm
  der_cp := 0;
annotation (
Documentation(info="<html>
<p>
This function computes the derivative of the specific heat capacity at constant pressure
with respect to the state.
</p>
</html>",
revisions="<html>
<ul>
<li>
December 11, 2013, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end der_specificHeatCapacityCp;

  replaceable function der_enthalpyOfLiquid
    "Temperature derivative of enthalpy of liquid per unit mass of liquid"
    extends Modelica.Icons.Function;
    input Temperature T "Temperature";
    input Real der_T "Temperature derivative";
    output Real der_h "Derivative of liquid enthalpy";
  algorithm
    der_h := cp_const*der_T;
    annotation (Documentation(info=
                   "<html>
<p>
This function computes the temperature derivative of the enthalpy of liquid water
per unit mass.
</p>
</html>", revisions=
          "<html>
<ul>
<li>
December 11, 2013, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
  end der_enthalpyOfLiquid;

function kinematicViscosity "Kinematic viscosity"
  extends Modelica.Icons.Function;

  input Modelica.SIunits.Temperature T "Temperature";
  output Modelica.SIunits.KinematicViscosity kinVis "Kinematic viscosity";
  protected
  Modelica.SIunits.Conversions.NonSIunits.Temperature_degC T_degC=
   Modelica.SIunits.Conversions.to_degC(T) "fixme";
algorithm
  // fixme: IDA uses T_degC = max(0, T_degC);
  // This function can be collapsed into dynamicViscosity
  kinVis :=1E-6*Modelica.Math.exp(0.577449 - 3.253945e-2*T_degC + 2.17369e-4*
      T_degC^2 - 7.22111e-7*T_degC^3);
end kinematicViscosity;

  annotation (preferredView="info", Documentation(info="<html>
<p>
This medium package models liquid water.
For the specific heat capacities at constant pressure and at constant volume,
a constant value of <i>4184</i> J/(kg K), which corresponds to <i>20</i>&deg;C.
The figure below shows the relative error of the specific heat capacity that
is introduced by this simplification.
</p>
<p align=\"center\">
<img src=\"modelica://Annex60/Resources/Images/Media/Water/plotCp.png\" border=\"1\" 
alt=\"Relative variation of specific heat capacity with temperature\"/>
</p>
<p>
The mass density is computed using a 3rd order polynomial, which yields the following
density as a function of temperature.
</p>
<p align=\"center\">
<img src=\"modelica://Annex60/Resources/Images/Media/Water/plotRho.png\" border=\"1\" 
alt=\"Control error.\"
alt=\"Mass density as a function of temperature\"/>
</p>
<p>
The enthalpy is computed using the convention that <i>h=0</i>
if <i>T=0</i> &deg;C.
</p>
<h4>Limitations</h4>
<p>
Water is modeled as an incompressible liquid, and there are no phase changes.
</p>
</html>", revisions="<html>
<ul>
<li>
December 11, 2013, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Water;

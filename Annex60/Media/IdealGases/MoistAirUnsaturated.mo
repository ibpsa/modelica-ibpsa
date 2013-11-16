within Annex60.Media.IdealGases;
package MoistAirUnsaturated
  "Moist air model with constant specific heat capacities and ideal gas law"
  extends Modelica.Media.Interfaces.PartialCondensingGases(
     mediumName="Moist air unsaturated ideal gas",
     final substanceNames={"water", "air"},
     final reducedX=true,
     final singleState=false,
     reference_X={0.01,0.99},
     final fluidConstants = {Modelica.Media.IdealGases.Common.FluidData.H2O,
                             Modelica.Media.IdealGases.Common.FluidData.N2});

  final constant Integer Water=1
    "Index of water (in substanceNames, massFractions X, etc.)";
  final constant Integer Air=2
    "Index of air (in substanceNames, massFractions X, etc.)";

  // Redeclare ThermodynamicState to avoid the warning
  // "Base class ThermodynamicState is replaceable"
  // during model check
  redeclare record extends ThermodynamicState
    "ThermodynamicState record for moist air"
  end ThermodynamicState;

  redeclare replaceable model extends BaseProperties(
    T(stateSelect=if preferredMediumStates then StateSelect.prefer else StateSelect.default),
    p(stateSelect=if preferredMediumStates then StateSelect.prefer else StateSelect.default),
    Xi(each stateSelect=if preferredMediumStates then StateSelect.prefer else StateSelect.default),
    final standardOrderComponents=true) "Base properties"

    MassFraction x_water "Mass of total water/mass of dry air";
    Real phi "Relative humidity";

  protected
    constant Modelica.SIunits.MolarMass[2] MMX = {steam.MM,dryair.MM}
      "Molar masses of components";
    MassFraction X_steam "Mass fraction of steam water";
    MassFraction X_air "Mass fraction of air";
    AbsolutePressure p_steam_sat "Partial saturation pressure of steam";
  equation
    assert(T >= 200.0 and T <= 423.15, "
Temperature T is not in the allowed range
200.0 K <= (T =" + String(T) + " K) <= 423.15 K
required from medium model \""     + mediumName + "\".");

    MM = 1/(Xi[Water]/MMX[Water]+(1.0-Xi[Water])/MMX[Air]);

    p_steam_sat = min(saturationPressure(T),0.999*p);

    X_steam  = Xi[Water];
    X_air    = 1-Xi[Water];

    //    h = specificEnthalpy_pTX(p,T,Xi);
    h = (T - 273.15)*dryair.cp * (1 - Xi[Water]) +
       ((T-273.15) * steam.cp + 2501014.5) * Xi[Water];
    R = dryair.R*(1 - X_steam) + steam.R*X_steam;
    //
    u = h - R*T;
    d = p/(R*T);
    /* Note, u and d are computed under the assumption that the volume of the liquid
         water is neglible with respect to the volume of air and of steam
      */
    state.p = p;
    state.T = T;
    state.X = X;

    // this x_steam is water load / dry air!!!!!!!!!!!
    x_water = Xi[Water]/max(X_air,100*Modelica.Constants.eps);
    phi = p/p_steam_sat*Xi[Water]/(Xi[Water] + k_mair*X_air);
  end BaseProperties;

redeclare function extends density "Gas density"

algorithm
  d := state.p/(gasConstant(state)*state.T);
  annotation (smoothOrder=2, Documentation(info="<html>
Density is computed from pressure, temperature and composition in the thermodynamic state record applying the ideal gas law.
</html>"));
end density;

redeclare function extends dynamicViscosity "dynamic viscosity of dry air"
algorithm
  eta := 1.85E-5;
end dynamicViscosity;

redeclare function enthalpyOfCondensingGas
    "Enthalpy of steam per unit mass of steam"
  extends Modelica.Icons.Function;

  input Temperature T "temperature";
  output SpecificEnthalpy h "steam enthalpy";
algorithm
  h := (T-273.15) * steam.cp + enthalpyOfVaporization(T);
  annotation(smoothOrder=5, derivative=der_enthalpyOfCondensingGas);
end enthalpyOfCondensingGas;

redeclare replaceable function extends enthalpyOfGas
    "Enthalpy of gas mixture per unit mass of gas mixture"
algorithm
  h := enthalpyOfCondensingGas(T)*X[Water]
       + enthalpyOfDryAir(T)*(1.0-X[Water]);
end enthalpyOfGas;

redeclare replaceable function extends enthalpyOfLiquid
    "Enthalpy of liquid (per unit mass of liquid) which is linear in the temperature"
algorithm
  h := (T - 273.15)*4186;
  annotation(smoothOrder=5, derivative=der_enthalpyOfLiquid);
end enthalpyOfLiquid;

redeclare function enthalpyOfNonCondensingGas
    "Enthalpy of non-condensing gas per unit mass of steam"
  extends Modelica.Icons.Function;

  input Temperature T "temperature";
  output SpecificEnthalpy h "enthalpy";
algorithm
  h := enthalpyOfDryAir(T);
  annotation(smoothOrder=5, derivative=der_enthalpyOfNonCondensingGas);
end enthalpyOfNonCondensingGas;

redeclare function extends enthalpyOfVaporization
    "Enthalpy of vaporization of water"
algorithm
  r0 := 2501014.5;
end enthalpyOfVaporization;

redeclare function extends gasConstant
    "Return ideal gas constant as a function from thermodynamic state, only valid for phi<1"

algorithm
    R := dryair.R*(1 - state.X[Water]) + steam.R*state.X[Water];
  annotation (smoothOrder=2, Documentation(info="<html>
The ideal gas constant for moist air is computed from <a href=\"modelica://Modelica.Media.Air.MoistAir.ThermodynamicState\">thermodynamic state</a> assuming that all water is in the gas phase.
</html>"));
end gasConstant;

redeclare function extends pressure
    "Returns pressure of ideal gas as a function of the thermodynamic state record"

algorithm
  p := state.p;
  annotation (smoothOrder=2, Documentation(info="<html>
Pressure is returned from the thermodynamic state record input as a simple assignment.
</html>"));
end pressure;

redeclare function extends saturationPressure
    "Saturation curve valid for 223.16 <= T <= 373.16 (and slightly outside with less accuracy)"

algorithm
  psat := Annex60.Utilities.Math.Functions.spliceFunction(
             saturationPressureLiquid(Tsat),
             sublimationPressureIce(Tsat),
             Tsat-273.16,
             1.0);
  annotation(Inline=false,smoothOrder=5);
end saturationPressure;

redeclare function extends specificEntropy
    "Return specific entropy from thermodynamic state record, only valid for phi<1"

algorithm
  s := Modelica.Media.Air.MoistAir.s_pTX(
        state.p,
        state.T,
        state.X);
  annotation (
    Inline=false,
    smoothOrder=2,
    Documentation(info="<html>
Specific entropy is calculated from the thermodynamic state record, assuming ideal gas behavior and including entropy of mixing. Liquid or solid water is not taken into account, the entire water content X[1] is assumed to be in the vapor state (relative humidity below 1.0).
</html>"));
end specificEntropy;

redeclare replaceable function extends specificHeatCapacityCp
    "Specific heat capacity of gas mixture at constant pressure"
algorithm
  cp := dryair.cp*(1-state.X[Water]) +steam.cp*state.X[Water];
    annotation(derivative=der_specificHeatCapacityCp);
end specificHeatCapacityCp;

redeclare replaceable function extends specificHeatCapacityCv
    "Specific heat capacity of gas mixture at constant volume"
algorithm
  cv:= dryair.cv*(1-state.X[Water]) +steam.cv*state.X[Water];
    annotation(derivative=der_specificHeatCapacityCv);
end specificHeatCapacityCv;

redeclare function setState_dTX
    "Return thermodynamic state as function of density d, temperature T and composition X"
  extends Modelica.Icons.Function;
  input Density d "Density";
  input Temperature T "Temperature";
  input MassFraction X[:]=reference_X "Mass fractions";
  output ThermodynamicState state "Thermodynamic state";

algorithm
    state := if size(X, 1) == nX then
               ThermodynamicState(p=d*({steam.R,dryair.R}*X)*T, T=T, X=X)
             else
               ThermodynamicState(p=d*({steam.R,dryair.R}*cat(1, X, {1 - sum(X)}))*T,
                                  T=T,
                                  X=cat(1, X, {1 - sum(X)}));
    annotation (smoothOrder=2, Documentation(info="<html>
The <a href=\"modelica://Modelica.Media.Interfaces.PartialMixtureMedium.ThermodynamicState\">thermodynamic state record</a> is computed from density d, temperature T and composition X.
</html>"));
end setState_dTX;

redeclare function extends setState_phX
    "Return thermodynamic state as function of pressure p, specific enthalpy h and composition X"
algorithm
  state := if size(X, 1) == nX then
    ThermodynamicState(p=p, T=temperature_phX(p, h, X), X=X)
 else
    ThermodynamicState(p=p, T=temperature_phX(p, h, X), X=cat(1, X, {1 - sum(X)}));
  annotation (smoothOrder=2, Documentation(info="<html>
The <a href=\"modelica://Modelica.Media.Interfaces.PartialMixtureMedium.ThermodynamicState\">
thermodynamic state record</a> is computed from pressure p, specific enthalpy h and composition X.
</html>"));
end setState_phX;

redeclare function extends setState_pTX
    "Return thermodynamic state as function of p, T and composition X or Xi"
algorithm
    state := if size(X, 1) == nX then
                ThermodynamicState(p=p, T=T, X=X)
             else
                ThermodynamicState(p=p, T=T, X=cat(1, X, {1 - sum(X)}));
    annotation (smoothOrder=2, Documentation(info="<html>
The <a href=\"modelica://Modelica.Media.Interfaces.PartialMixtureMedium.ThermodynamicState\">
thermodynamic state record</a> is computed from pressure p, temperature T and composition X.
</html>"));
end setState_pTX;

redeclare replaceable function extends specificEnthalpy
    "Compute specific enthalpy from pressure, temperature and mass fraction"
algorithm
  h := (state.T - 273.15)*dryair.cp * (1 - state.X[Water]) +
       ((state.T-273.15) * steam.cp + 2501014.5) * state.X[Water];
  annotation(Inline=false,smoothOrder=5);
end specificEnthalpy;

redeclare replaceable function specificEnthalpy_pTX "Specific enthalpy"
  extends Modelica.Icons.Function;
  input Modelica.SIunits.Pressure p "Pressure";
  input Modelica.SIunits.Temperature T "Temperature";
  input Modelica.SIunits.MassFraction X[:] "Mass fractions of moist air";
  output Modelica.SIunits.SpecificEnthalpy h "Specific enthalpy at p, T, X";

algorithm
  h := specificEnthalpy(setState_pTX(p, T, X));
  annotation(smoothOrder=5,
             inverse(T=temperature_phX(p, h, X)));
end specificEnthalpy_pTX;

redeclare replaceable function extends specificGibbsEnergy
    "Specific Gibbs energy"
algorithm
  g := specificEnthalpy(state) - state.T*specificEntropy(state);
end specificGibbsEnergy;

redeclare replaceable function extends specificHelmholtzEnergy
    "Specific Helmholtz energy"
algorithm
  f := specificEnthalpy(state) - gasConstant(state)*state.T - state.T*specificEntropy(state);
end specificHelmholtzEnergy;

redeclare replaceable function extends specificInternalEnergy
    "Specific internal energy"
algorithm
  u := specificEnthalpy(state) - gasConstant(state)*state.T;
end specificInternalEnergy;

redeclare function extends temperature
    "Return temperature of ideal gas as a function of the thermodynamic state record"
algorithm
  T := state.T;
  annotation (smoothOrder=2, Documentation(info="<html>
Temperature is returned from the thermodynamic state record input as a simple assignment.
</html>"));
end temperature;

redeclare replaceable function temperature_phX
    "Compute temperature from specific enthalpy and mass fraction"
    extends Modelica.Icons.Function;
  input AbsolutePressure p "Pressure";
  input SpecificEnthalpy h "specific enthalpy";
  input MassFraction[:] X "mass fractions of composition";
  output Temperature T "temperature";
algorithm
  T := 273.15 + (h - 2501014.5 * X[Water])
       /((1 - X[Water])*dryair.cp + X[Water] * steam.cp);
  annotation(smoothOrder=5,
             inverse(h=specificEnthalpy_pTX(p, T, X)),
             Documentation(info="<html>
Temperature as a function of specific enthalpy and species concentration.
The pressure is input for compatibility with the medium models, but the temperature
is independent of the pressure.
</html>"));
end temperature_phX;

redeclare function extends thermalConductivity
    "Thermal conductivity of dry air as a polynomial in the temperature"
algorithm
  lambda := Modelica.Media.Incompressible.TableBased.Polynomials_Temp.evaluate(
      {(-4.8737307422969E-008), 7.67803133753502E-005, 0.0241814385504202},
   Modelica.SIunits.Conversions.to_degC(state.T));
end thermalConductivity;

//////////////////////////////////////////////////////////////////////
// Protected classes.
// These classes are only of use within this medium model.
// Equipment models generally have no need to access them.
// Therefore, they are made protected. This also allows to redeclare the
// medium model with another medium model that does not provide an
// implementation of these classes.

protected
  constant Real k_mair =  steam.MM/dryair.MM "ratio of molar weights";
  constant Annex60.Media.IdealGases.Common.DataRecord dryair=
     Annex60.Media.IdealGases.Common.SingleGasData.Air "Dry air properties";
  constant Annex60.Media.IdealGases.Common.DataRecord steam=
     Annex60.Media.IdealGases.Common.SingleGasData.H2O "Steam properties";

replaceable function der_enthalpyOfLiquid
    "Temperature derivative of enthalpy of liquid per unit mass of liquid"
  extends Modelica.Icons.Function;
  input Temperature T "Temperature";
  input Real der_T "Temperature derivative";
  output Real der_h "Derivative of liquid enthalpy";
algorithm
  der_h := 4186*der_T;
end der_enthalpyOfLiquid;

function der_enthalpyOfCondensingGas
    "Derivative of enthalpy of steam per unit mass of steam"
  extends Modelica.Icons.Function;
  input Temperature T "Temperature";
  input Real der_T "Temperature derivative";
  output Real der_h "Derivative of steam enthalpy";
algorithm
  der_h := steam.cp*der_T;
end der_enthalpyOfCondensingGas;

replaceable function enthalpyOfDryAir
    "Enthalpy of dry air per unit mass of dry air"
  extends Modelica.Icons.Function;

  input Temperature T "Temperature";
  output SpecificEnthalpy h "Dry air enthalpy";
algorithm
  h := (T - 273.15)*dryair.cp;
  annotation(smoothOrder=5, derivative=der_enthalpyOfDryAir);
end enthalpyOfDryAir;

function saturationPressureLiquid
    "Return saturation pressure of water as a function of temperature T in the range of 273.16 to 373.16 K"
    extends Modelica.Icons.Function;
  input Modelica.SIunits.Temperature Tsat "Saturation temperature";
  output Modelica.SIunits.AbsolutePressure psat "Saturation pressure";
algorithm
  psat := 611.657*Modelica.Math.exp(17.2799 - 4102.99/(Tsat - 35.719));
  annotation(Inline=false,
             smoothOrder=5,
             derivative=saturationPressureLiquid_der,
    Documentation(info="<html>
Saturation pressure of water above the triple point temperature is computed from temperature. 
The range of validity is between
273.16 and 373.16 K. Outside these limits, a less accurate result is returned.
</html>"));
end saturationPressureLiquid;

function saturationPressureLiquid_der
    "Time derivative of saturationPressureLiquid"

  extends Modelica.Icons.Function;
  input Modelica.SIunits.Temperature Tsat "Saturation temperature";
  input Real dTsat(unit="K/s") "Saturation temperature derivative";
  output Real psat_der(unit="Pa/s") "Saturation pressure";

algorithm
  psat_der:=611.657*Modelica.Math.exp(17.2799 - 4102.99
            /(Tsat - 35.719))*4102.99*dTsat/(Tsat - 35.719)/(Tsat - 35.719);

  annotation(Inline=false,smoothOrder=5,
    Documentation(info="<html>
Derivative function of 
<a href=\"modelica://Annex60.Media.IdealGases.MoistAirUnsaturated.saturationPressureLiquid\">
Annex60.Media.IdealGases.MoistAirUnsaturated.saturationPressureLiquid</a>
</html>"));
end saturationPressureLiquid_der;

function sublimationPressureIce
    "Return sublimation pressure of water as a function of temperature T between 190 and 273.16 K"

  extends Modelica.Icons.Function;
  input Modelica.SIunits.Temperature Tsat "Sublimation temperature";
  output Modelica.SIunits.AbsolutePressure psat "Sublimation pressure";
  protected
  Modelica.SIunits.Temperature Ttriple=273.16 "Triple point temperature";
  Modelica.SIunits.AbsolutePressure ptriple=611.657 "Triple point pressure";
  Real r1=Tsat/Ttriple "Common subexpression";
  Real a[:]={-13.9281690,34.7078238} "Coefficients a[:]";
  Real n[:]={-1.5,-1.25} "Coefficients n[:]";
algorithm
  psat := exp(a[1] - a[1]*r1^n[1] + a[2] - a[2]*r1^n[2])*ptriple;
  annotation (
    Inline=false,
    smoothOrder=5,
    derivative=sublimationPressureIce_der,
    Documentation(info="<html>
    <p>Sublimation pressure of water below the triple point temperature 
    is computed from temperature.</p>
<p>Source: W Wagner, A Saul, A Pruss: &quot;International equations for the pressure along the melting and along the sublimation curve of ordinary water substance&quot;, equation 3.5</p>
</html>"));
end sublimationPressureIce;

function sublimationPressureIce_der
    "Derivative function for 'sublimationPressureIce'"

    extends Modelica.Icons.Function;
    input Modelica.SIunits.Temperature Tsat "Sublimation temperature";
    input Real dTsat(unit="K/s") "Sublimation temperature derivative";
    output Real psat_der(unit="Pa/s") "Sublimation pressure derivative";
  protected
    Modelica.SIunits.Temperature Ttriple=273.16 "Triple point temperature";
    Modelica.SIunits.AbsolutePressure ptriple=611.657 "Triple point pressure";
    Real r1=Tsat/Ttriple "Common subexpression 1";
    Real r1_der=dTsat/Ttriple "Derivative of common subexpression 1";
    Real a[:]={-13.9281690,34.7078238} "Coefficients a[:]";
    Real n[:]={-1.5,-1.25} "Coefficients n[:]";
algorithm
    psat_der := exp(a[1] - a[1]*r1^n[1] + a[2] - a[2]*r1^n[2])*ptriple*(-(a[1]
      *(r1^(n[1] - 1)*n[1]*r1_der)) - (a[2]*(r1^(n[2] - 1)*n[2]*r1_der)));
    annotation (
      Inline=false,
      smoothOrder=5,
      Documentation(info="<html>
<p>Sublimation pressure of water below the triple point temperature is computed from temperature.</p>
<p>Source: W Wagner, A Saul, A Pruss: &quot;International equations for the pressure along the melting and along the sublimation curve of ordinary water substance&quot;, equation 3.5</p>
</html>"));
end sublimationPressureIce_der;

replaceable function der_enthalpyOfDryAir
    "Derivative of enthalpy of dry air per unit mass of dry air"
  extends Modelica.Icons.Function;
  input Temperature T "Temperature";
  input Real der_T "Temperature derivative";
  output Real der_h "Derivative of dry air enthalpy";
algorithm
  der_h := dryair.cp*der_T;
end der_enthalpyOfDryAir;

replaceable function der_enthalpyOfNonCondensingGas
    "Derivative of enthalpy of non-condensing gas per unit mass of steam"
  extends Modelica.Icons.Function;
  input Temperature T "Temperature";
  input Real der_T "Temperature derivative";
  output Real der_h "Derivative of steam enthalpy";
algorithm
  der_h := der_enthalpyOfDryAir(T, der_T);
end der_enthalpyOfNonCondensingGas;

replaceable function der_specificHeatCapacityCp
    "Derivative of specific heat capacity of gas mixture at constant pressure"
  extends Modelica.Icons.Function;
    input ThermodynamicState state "Thermodynamic state";
    input ThermodynamicState der_state "Derivative of thermodynamic state";
    output Real der_cp(unit="J/(kg.K.s)")
      "Derivative of specific heat capacity";
algorithm
  der_cp := (steam.cp-dryair.cp)*der_state.X[Water];
end der_specificHeatCapacityCp;

replaceable function der_specificHeatCapacityCv
    "Derivative of specific heat capacity of gas mixture at constant volume"
  extends Modelica.Icons.Function;
    input ThermodynamicState state "Thermodynamic state";
    input ThermodynamicState der_state "Derivative of thermodynamic state";
    output Real der_cv(unit="J/(kg.K.s)")
      "Derivative of specific heat capacity";
algorithm
  der_cv := (steam.cv-dryair.cv)*der_state.X[Water];
end der_specificHeatCapacityCv;

  annotation (preferredView="info", Documentation(info="<html>
<p>
This medium package models moist air using the ideal gas law. 
The specific heat capacities at constant pressure and at constant volume are constant.
The air is assumed to be not saturated. Even if its relative humidity raises
above 100%, this model does not compute the amount of liquid that is
condensed out of the medium. However, the medium can still be used
in models of air-conditioning equipment that humidifies or dehumidifies
air.
</p>
<p>
The model is similar to 
<a href=\"modelica://Annex60.Media.IdealGases.MoistAir\">
Annex60.Media.IdealGases.MoistAir</a> but 
in this model, the air must not be saturated. If the air is saturated, 
use the medium model
<a href=\"modelica://Annex60.Media.IdealGases.MoistAir\">
Annex60.Media.IdealGases.MoistAir</a> instead of this one.
</p>
<p>
This medium model has been added to allow an explicit computation of
the function 
<code>temperature_phX</code> so that it is once differentiable in <code>h</code>
with a continuous derivative. This allows obtaining an analytic
expression for the Jacobian, and therefore simplifies the computation
of initial conditions that can be numerically challenging for 
thermo-fluid systems.
</p>
</html>", revisions="<html>
<ul>
<li>
November 15, 2013, by Michael Wetter:<br/>
Revised and simplified the implementation.
</li>
<li>
November 14, 2013, by Michael Wetter:<br/>
Removed function
<code>HeatCapacityOfWater</code>
which is neither needed nor implemented in the
Modelica Standard Library.
</li>
<li>
November 13, 2013, by Michael Wetter:<br/>
Removed un-used computations in <code>specificEnthalpy_pTX</code> and
in <code>temperature_phX</code>.
</li>
<li>
March 29, 2013, by Michael Wetter:<br/>
Added <code>final standardOrderComponents=true</code> in the
<code>BaseProperties</code> declaration. This avoids an error
when models are checked in Dymola 2014 in the pedenatic mode.
</li>
<li>
April 12, 2012, by Michael Wetter:<br/>
Added keyword <code>each</code> to <code>Xi(stateSelect=...</code>.
</li>
<li>
April 4, 2012, by Michael Wetter:<br/>
Added redeclaration of <code>ThermodynamicState</code> to avoid a warning
during model check and translation.
</li>
<li>
January 27, 2010, by Michael Wetter:<br/>
Added function <code>enthalpyOfNonCondensingGas</code> and its derivative.
</li>
<li>
January 27, 2010, by Michael Wetter:<br/>
Fixed bug with temperature offset in <code>temperature_phX</code>.
</li>
<li>
August 18, 2008, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end MoistAirUnsaturated;

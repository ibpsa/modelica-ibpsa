within Annex60.Experimental;
package AirPTDecoupled
  "Package with moist air model that decouples pressure and temperature"
  extends Modelica.Media.Interfaces.PartialCondensingGases(
     mediumName="AirPTDecoupled",
     final substanceNames={"water", "air"},
     final reducedX=true,
     final singleState = false,
     reference_X={0.01,0.99},
     final fluidConstants = {Modelica.Media.IdealGases.Common.FluidData.H2O,
                             Modelica.Media.IdealGases.Common.FluidData.N2});

  constant Integer Water=1
    "Index of water (in substanceNames, massFractions X, etc.)";
  constant Integer Air=2
    "Index of air (in substanceNames, massFractions X, etc.)";

  constant AbsolutePressure pStp = 101325 "Pressure for which dStp is defined";
  constant Density dStp = 1.2 "Fluid density at pressure pStp";

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
    MassFraction X_sat
      "Steam water mass fraction of saturation boundary in kg_water/kg_moistair";
    AbsolutePressure p_steam_sat "Partial saturation pressure of steam";
    Modelica.SIunits.TemperatureDifference dT
      "Temperature difference used to compute enthalpy";
  equation
    assert(T >= 200.0 and T <= 423.15, "
Temperature T is not in the allowed range
200.0 K <= (T ="
               + String(T) + " K) <= 423.15 K
required from medium model \""     + mediumName + "\".");

    MM = 1/(Xi[Water]/MMX[Water]+(1.0-Xi[Water])/MMX[Air]);

    p_steam_sat = min(saturationPressure(T),0.999*p);
    X_sat = min(p_steam_sat * k_mair/max(100*Modelica.Constants.eps, p - p_steam_sat)*(1 - Xi[Water]), 1.0)
      "Water content at saturation with respect to actual water content";

    X_steam  = Xi[Water]; // There is no liquid in this medium model
    X_air    = 1-Xi[Water];

    //    h = specificEnthalpy_pTX(p,T,Xi);
    dT = T - 273.15;
    h = dT*dryair.cp * (1 - Xi[Water]) +
       (dT * steam.cp + 2501014.5) * Xi[Water];
    R = dryair.R*(1 - Xi[Water]) + steam.R*Xi[Water];

    // Equation for ideal gas, from h=u+p*v and R*T=p*v, from which follows that  u = h-R*T.
    // u = h-R*T;

    // However, in this medium, the gas law is d/dStp=p/pStp, from which follows using h=u+pv that
    // u= h-p*v = h-p/d = h-pStp/dStp
    u = h-pStp/dStp;

    //    d = p/(R*T);
    d/dStp = p/pStp;

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

redeclare function density "Gas density"
  extends Modelica.Icons.Function;
  input ThermodynamicState state;
  output Density d "Density";
algorithm
  d :=state.p*dStp/pStp;
  annotation (smoothOrder=5, Documentation(info="<html>
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
  psat := Annex60.Utilities.Psychrometrics.Functions.saturationPressure(Tsat);
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
    // Note that d/dStp = p/pStp, hence p = d*pStp/dStp
    state := if size(X, 1) == nX then
               ThermodynamicState(p=d*pStp/dStp, T=T, X=X)
             else
               ThermodynamicState(p=d*pStp/dStp,
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

redeclare function extends specificInternalEnergy "Specific internal energy"
  extends Modelica.Icons.Function;
algorithm
  u := specificEnthalpy(state) - pStp/dStp;
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
  constant Real k_mair =  steam.MM/dryair.MM "Ratio of molar weights";
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
This medium package models moist air using a gas law in which pressure and temperature
are independent, which often leads to significantly faster and more robust computations. 
The specific heat capacities at constant pressure and at constant volume are constant.
The air is assumed to be not saturated.
</p>
</html>", revisions="<html>
<ul>
<li>
November 16, 2013, by Michael Wetter:<br/>
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
Removed non-used computations in <code>specificEnthalpy_pTX</code> and
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
August 3, 2011, by Michael Wetter:<br/>
Fixed bug in <code>u=h-R*T</code>, which is only valid for ideal gases. 
For this medium, the function is <code>u=h-pStd/dStp</code>.
</li>
<li>
January 27, 2010, by Michael Wetter:<br/>
Fixed bug in <code>else</code> branch of function <code>setState_phX</code>
that lead to a run-time error when the constructor of this function was called.
</li>
<li>
January 22, 2010, by Michael Wetter:<br/>
Added implementation of function
<a href=\"modelica://Annex60.Media.GasesPTDecoupled.MoistAirUnsaturated.enthalpyOfNonCondensingGas\">
enthalpyOfNonCondensingGas</a> and its derivative.
<li>
January 13, 2010, by Michael Wetter:<br/>
Fixed implementation of derivative functions.
</li>
<li>
August 28, 2008, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end AirPTDecoupled;

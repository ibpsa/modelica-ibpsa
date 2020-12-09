within IBPSA.Media;
package Steam
  "Package with model for pure steam water vapor"
  extends Modelica.Media.Interfaces.PartialMedium(
     mediumName="steam",
     final substanceNames={"water"},
     singleState = true,
     reducedX = true,
     fixedX = true,
     FluidConstants={Modelica.Media.IdealGases.Common.FluidData.H2O},
     reference_T=273.15,
     reference_p=101325,
     reference_X={1},
     AbsolutePressure(start=p_default),
     Temperature(start=T_default),
     SpecificEnthalpy(start=1.0e5, nominal=5.0e5),
     Density(start=150, nominal=500),
     T_default=Modelica.SIunits.Conversions.from_degC(100));
  extends Modelica.Icons.Package;

  redeclare record ThermodynamicState
    "Thermodynamic state variables"
    AbsolutePressure p "Absolute pressure of medium";
    Temperature T "Temperature of medium";
  end ThermodynamicState;

  constant Integer region = 2 "Region of IF97";
  constant Integer phase = 1 "1 for one-phase";

redeclare replaceable model extends BaseProperties(
    preferredMediumStates = true,
    final standardOrderComponents=true)
    "Base properties (p, d, T, h, u, R, MM) of water"
equation
    MM = steam.MM;
    h = specificEnthalpy(state);
    d = density(state);
    u = h - p/d;
    R = steam.R;
    state.p = p;
    state.T = T;
end BaseProperties;

redeclare replaceable function extends density
  "Returns density"
algorithm
  d := rho_T(state.T);
  annotation (Inline=true, Documentation(info="<html>
<p>
Density is computed from temperature and <code>p_default</code> using the
IAPWS-IF97 relationship via the Gibbs free energy for region 2.
</p>
</html>"));
end density;

redeclare replaceable function extends dynamicViscosity
    "Return dynamic viscosity"
algorithm
    eta := Modelica.Media.Water.IF97_Utilities.dynamicViscosity(
          d=density(state),
          T=state.T,
          p=p_default);
    annotation (Inline=true, Documentation(info="<html>
<p>
Dynamic viscosity is computed from density, temperature and <code>p_default</code>
using the IAPWS-IF97 formulation.
</p>
</html>"));
end dynamicViscosity;

redeclare replaceable function extends molarMass
  "Return the molar mass of the medium"
algorithm
  MM := steam.MM;
    annotation (Documentation(info="<html>
<p>
Returns the molar mass.
</p>
</html>"));
end molarMass;

redeclare function extends pressure
  "Return pressure"
algorithm
  p := p_default;
    annotation (Documentation(info="<html>
<p>
Pressure is returned as the constant value <code>p_default</code>.
</p>
</html>"));
end pressure;

replaceable function saturationPressure
  "Return saturation pressure of condensing fluid"
    extends Modelica.Icons.Function;
    input Temperature Tsat "Saturation temperature";
    output AbsolutePressure psat "Saturation pressure";
algorithm
   psat := Modelica.Media.Water.IF97_Utilities.BaseIF97.Basic.psat(Tsat);

 annotation (Inline=true, Documentation(info="<html>
<p>
Saturation pressure is computed from temperature
using the IAPWS-IF97 formulation.
</p>
</html>"));
end saturationPressure;

replaceable function saturationTemperature
    "Return saturation temperature"
  input AbsolutePressure psat "Saturation pressure";
  output Temperature Tsat "Saturation temperature";
algorithm
    Tsat := Modelica.Media.Water.IF97_Utilities.BaseIF97.Basic.tsat(psat);
    annotation (Inline=true, Documentation(info="<html>
<p>
Saturation temperature is computed from pressure
using the IAPWS-IF97 formulation.
</p>
</html>"));
end saturationTemperature;

redeclare replaceable function extends specificEnthalpy
  "Returns specific enthalpy"
  protected
    constant Real a[:] = {3.272e+06,-1.838e+04,3.504e+05} "Regression coefficients";
    constant AbsolutePressure pMean =  1.235156250000000e+06 "Mean pressure";
    constant Temperature TMean =  6.775608072916825e+02 "Mean temperature";
    constant Real pSD = 8.325568179102554e+05 "Normalization value";
    constant Real TSD = 1.610589787790216e+02 "Normalization value";
    AbsolutePressure pHat;
    Temperature THat;
algorithm
  pHat := (p_default - pMean)/pSD;
  THat := (state.T - TMean)/TSD;
  h := a[1] + a[2]*pHat + a[3]*THat;
annotation (Inline=true,smoothOrder=2,
    Documentation(info="<html>
<p>
Returns the specific enthalpy.
</p>
<h4>Implementation</h4>
<p>
The function is based on
<a href=\"modelica://Modelica.Media.Water.WaterIF97_base.specificEnthalpy_pT\">
Modelica.Media.Water.WaterIF97_base.specificEnthalpy_pT</a>.
However, for the typical range of temperatures and pressures
encountered in building and district energy applications,
a linear function sufficies. This implementation is therefore a linear
surface fit of the IF97 formulation <i>h(p,T)</i> in the ranges of
<i>100&deg;C &le; T &le; 700&deg;C</i> and
<i>100 kPa &le; p &le; 3000</i> kPa. The fit is scaled by the dataset's
mean and standard deviation values to improve conditioning.
The relative error of this linearization is
<i>2.04</i>% at <i>235&deg;C</i> and <i>3000 kPa</i>,
and is less than <i>0.52</i>% for all <i>p &le; 1000 kPa</i>. The root mean square error (RMSE)
is <i>12.711 kJ/kg</i>.
</p>
</html>", revisions="<html>
<ul>
<li>
October 30, 2020, by Kathryn Hinkelman:<br/>
First implementation.
</li>
</ul>
</html>"));
end specificEnthalpy;

redeclare replaceable function extends specificEntropy
  "Return specific entropy"
  protected
    constant Real a[:] = {7530,-636.9,532.8,159.8,4.13} "Regression coefficients";
    constant AbsolutePressure pMean =  8.161678571428572e+05 "Mean pressure";
    constant Temperature TMean =  6.625678571428278e+02 "Mean temperature";
    constant Real pSD = 7.802949628497174e+05 "Normalization values";
    constant Real TSD = 1.664480893697980e+02 "Normalization values";
    AbsolutePressure pHat;
    Temperature THat;
algorithm
  pHat := (p_default - pMean)/pSD;
  THat := (state.T - TMean)/TSD;
  s := a[1] + a[2]*pHat + a[3]*THat + pHat*(a[4]*pHat + a[5]*THat);
annotation (Inline=true,smoothOrder=1,
    Documentation(info="<html>
<p>
Returns the specific entropy.
</p>
<h4>Implementation</h4>
<p>
The function is based on
<a href=\"modelica://Modelica.Media.Water.WaterIF97_base.specificEntropy\">
Modelica.Media.Water.WaterIF97_base.specificEntropy</a>.
However, for the typical range of temperatures and pressures
encountered in building and district energy applications,
an invertible polynomial fit sufficies. This implementation is therefore
a polynomial fit (quadratic in pressure, linear in temperature) of the
IF97 formulation <i>s(p,T)</i> in the ranges of
<i>100&deg;C &le; T &le; 700&deg;C</i> and
<i>100 kPa &le; p &le; 3000 kPa</i>. The fit is scaled by the dataset's
mean and standard deviation values to improve conditioning.
The relative error of this approximation is
<i>4.86</i>% at <i>235&deg;C</i> and <i>3000 kPa</i>,
and is less than <i>3.42</i>% for all <i>p &le; 1000 kPa</i>. The root mean
square error (RMSE) is <i>105.296 J/kg-K</i>.</p>
</html>"));
end specificEntropy;

redeclare replaceable function extends specificInternalEnergy
  "Return specific internal energy"
algorithm
  u := specificEnthalpy(state) - p_default/density(state);
  annotation (Inline=true, Documentation(info="<html>
<p>
Returns the specific internal energy for a given state.
</p>
</html>"));
end specificInternalEnergy;

redeclare replaceable function extends specificHeatCapacityCp
  "Specific heat capacity at constant pressure"
algorithm
  cp := cp_T(state.T);
  annotation (Inline=true, Documentation(info="<html>
<p>
Specific heat at constant pressure is computed from temperature and
<code>p_default</code> using the IAPWS-IF97 relationship via the Gibbs
free energy for region 2.
</p>
</html>"));
end specificHeatCapacityCp;

redeclare replaceable function extends specificHeatCapacityCv
  "Specific heat capacity at constant volume"
algorithm
  cv := cv_T(state.T);
  annotation (Inline=true, Documentation(info="<html>
<p>
Specific heat at constant volume is computed from temperature and
<code>p_default</code> using the IAPWS-IF97 relationship via the Gibbs
free energy for region 2.
</p>
</html>"));
end specificHeatCapacityCv;

redeclare replaceable function extends specificGibbsEnergy
   "Specific Gibbs energy"
algorithm
  g := specificEnthalpy(state) - state.T*specificEntropy(state);
  annotation (Inline=true);
end specificGibbsEnergy;

redeclare replaceable function extends specificHelmholtzEnergy
   "Specific Helmholtz energy"
algorithm
  f := specificEnthalpy(state) - steam.R*state.T - state.T*specificEntropy(state);
  annotation (Inline=true, Documentation(info="<html>
<p>
Returns the specific Helmholtz energy for a given state.
</p>
</html>"));
end specificHelmholtzEnergy;

redeclare replaceable function extends setState_dTX
    "Return the thermodynamic state as function of d and T"
algorithm
  state := ThermodynamicState(p=p_default, T=T);
annotation (Inline=true,smoothOrder=2,
      Documentation(info="<html>
<p>
The <a href=\"modelica://Modelica.Media.Interfaces.PartialMixtureMedium.ThermodynamicState\">thermodynamic state record</a>
is computed from density <code>d</code> and temperature <code>T</code>.
</p>
</html>"));
end setState_dTX;

redeclare replaceable function extends setState_pTX
    "Return the thermodynamic state as function of p and T"
algorithm
  state := ThermodynamicState(p=p_default, T=T);
annotation (Inline=true,smoothOrder=2,
    Documentation(info="<html>
<p>
The <a href=\"modelica://Modelica.Media.Interfaces.PartialMixtureMedium.ThermodynamicState\">thermodynamic state record</a>
is computed from pressure <code>p_default</code> and temperature <code>T</code>.
</p>
</html>"));
end setState_pTX;

redeclare replaceable function extends setState_phX
    "Return the thermodynamic state as function of p and h"
algorithm
  state := ThermodynamicState(p=p_default, T=temperature_h(h));
annotation (Inline=true,smoothOrder=2,
      Documentation(info="<html>
<p>
The <a href=\"modelica://Modelica.Media.Interfaces.PartialMixtureMedium.ThermodynamicState\">thermodynamic state record</a>
is computed from pressure <code>p_default</code> and specific enthalpy <code>h</code>.
</p>
</html>"));
end setState_phX;

redeclare replaceable function extends setState_psX
    "Return the thermodynamic state as function of p and s"
algorithm
  state := ThermodynamicState(p=p_default, T=temperature_s(s));
annotation (Inline=true,smoothOrder=2,
    Documentation(info="<html>
<p>
The <a href=\"modelica://Modelica.Media.Interfaces.PartialMixtureMedium.ThermodynamicState\">thermodynamic state record</a>
is computed from pressure <code>p_default</code> and specific entropy <code>s</code>.
</p>
</html>"));
end setState_psX;

redeclare function extends temperature
    "Return temperature"
algorithm
  T := state.T;
    annotation (Documentation(info="<html>
<p>
Temperature is returned from the thermodynamic state record input as a simple assignment.
</p>
</html>"));
end temperature;

redeclare replaceable function extends thermalConductivity
  "Return thermal conductivity"
algorithm
  lambda := Modelica.Media.Water.IF97_Utilities.thermalConductivity(
        density(state),
        state.T,
        p_default);
  annotation (Inline=true, Documentation(info="<html>
<p>
Thermal conductivity is computed from density, temperature and <code>p_default</code>
using the IAPWS-IF97 formulation.
</p>
</html>"));
end thermalConductivity;

redeclare function extends density_derh_p
  "Density derivative by specific enthalpy"
algorithm
  ddhp := Modelica.Media.Water.IF97_Utilities.ddhp(
        p_default,
        specificEnthalpy(state),
        phase,
        region);
  annotation (Inline=true, Documentation(info="<html>
<p>
Returns the partial derivative of density with respect
to specific enthalpy at constant pressure using the IAPWS-IF97 formulation.
</p>
</html>"));
end density_derh_p;

redeclare function extends density_derp_h
  "Density derivative by pressure"
algorithm
  ddph := Modelica.Media.Water.IF97_Utilities.ddph(
        p_default,
        specificEnthalpy(state),
        phase,
        region);
  annotation (Inline=true, Documentation(info="<html>
<p>
Returns the partial derivative of density with respect
to pressure at constant specific enthalpy using the IAPWS-IF97 formulation.
</p>
</html>"));
end density_derp_h;

redeclare replaceable function extends isentropicExponent
  "Return isentropic exponent"
algorithm
  gamma := Modelica.Media.Water.IF97_Utilities.isentropicExponent_pT(
        p_default,
        state.T,
        region);
  annotation (Inline=true, Documentation(info="<html>
<p>
Isentropic exponent is computed from temperature and <code>p_default</code>
using the IAPWS-IF97 formulation.
</p>
</html>"));
end isentropicExponent;

redeclare replaceable function extends isothermalCompressibility
  "Isothermal compressibility of water"
algorithm
  kappa := Modelica.Media.Water.IF97_Utilities.kappa_pT(
        p_default,
        state.T,
        region);
  annotation (Inline=true, Documentation(info="<html>
<p>
Isothermal compressibility is computed from temperature and <code>p_default</code>
using the IAPWS-IF97 formulation.
</p>
</html>"));
end isothermalCompressibility;

redeclare replaceable function extends isobaricExpansionCoefficient
  "Isobaric expansion coefficient of water"
algorithm
  beta := Modelica.Media.Water.IF97_Utilities.beta_pT(
        p_default,
        state.T,
        region);
    annotation (Documentation(info="<html>
<p>
Isobaric expansion coefficient is computed from temperature and
<code>p_default</code> using the IAPWS-IF97 formulation.
</p>
</html>"));
end isobaricExpansionCoefficient;

redeclare replaceable function extends isentropicEnthalpy
  "Isentropic enthalpy"
algorithm
  h_is := Modelica.Media.Water.IF97_Utilities.isentropicEnthalpy(
        p_downstream,
        specificEntropy(refState),
        0);
  annotation (Inline=true, Documentation(info="<html>
<p>
Isentropic enthalpy is computed using the IAPWS-IF97 formulation:
</p>
<ol>
<li> A medium is in a particular state, refState.</li>
<li> The enthalpy at another state (h_is) shall be computed
     under the assumption that the state transformation from refState to h_is
     is performed with a change of specific entropy ds = 0 and the pressure of state h_is
     is p_downstream and the composition X upstream and downstream is assumed to be the same.</li>
</ol>
</html>"));
end isentropicEnthalpy;
//////////////////////////////////////////////////////////////////////
// Protected classes

protected
record GasProperties
  "Coefficient data record for properties of perfect gases"
  extends Modelica.Icons.Record;
  Modelica.SIunits.MolarMass MM "Molar mass";
  Modelica.SIunits.SpecificHeatCapacity R "Gas constant";
end GasProperties;
constant GasProperties steam(
  R =    Modelica.Media.IdealGases.Common.SingleGasesData.H2O.R,
  MM =   Modelica.Media.IdealGases.Common.SingleGasesData.H2O.MM)
  "Steam properties";

function temperature_h
  "Return temperature from h, inverse function of h(T)"
    input SpecificEnthalpy h "Specific Enthalpy";
    output Temperature T "Temperature";
  protected
    constant Real a[:] = {3.272e+06,-1.838e+04,3.504e+05} "Coefficients from forward function h(p,T)";
    constant Real b[:] = {-a[1]*TSD/a[3]+TMean, -a[2]*TSD/a[3], TSD/a[3]} "Regression coefficients";
    constant AbsolutePressure pMean =  1.235156250000000e+06 "Mean pressure";
    constant Temperature TMean =  6.775608072916825e+02 "Mean temperature";
    constant Real pSD = 8.325568179102554e+05 "Normalization values";
    constant Real TSD = 1.610589787790216e+02 "Normalization values";
    AbsolutePressure pHat;
algorithm
  pHat := (p_default - pMean)/pSD;
  T := b[1] + b[2]*pHat + b[3]*h;
annotation (Inline=true,smoothOrder=1,
      Documentation(info="<html>
<p>
Returns temperature from specific enthalpy and <code>p_default</code>.
</p>
<h4>Implementation</h4>
<p>
This linear approximation is the inverse or backward function of
<a href=\"modelica://IBPSA.Media.Steam.specificEnthalpy\">
IBPSA.Media.Steam.specificEnthalpy</a> and is numerically
consistent with that forward function.
</html>", revisions="<html>
<ul>
<li>
October 30, 2020, by Kathryn Hinkelman:<br/>
First implementation.
</li>
</ul>
</html>"));
end temperature_h;

function temperature_s
  "Return temperature from s, inverse function of s(T)"
    input SpecificEntropy s "Specific Entropy";
    output Temperature T "Temperature";
  protected
    constant Real a[:] = {7530,-636.9,532.8,159.8,4.13} "Coefficients from forward function s(p,T)";
    constant AbsolutePressure pMean =  8.161678571428572e+05 "Mean pressure";
    constant Temperature TMean =  6.625678571428278e+02 "Mean temperature";
    constant Real pSD = 7.802949628497174e+05 "Normalization values";
    constant Real TSD = 1.664480893697980e+02 "Normalization values";
    AbsolutePressure pHat;
    Temperature THat;
algorithm
  pHat := (p_default - pMean)/pSD;
  THat := (s - a[1] - pHat*(a[2] + a[4]*pHat))/(a[3] + a[5]*pHat);
  T := THat*TSD + TMean;
annotation (Inline=true,smoothOrder=1,
    Documentation(info="<html>
<p>
Returns temperature from specific entropy and <code>p_default</code>.
</p>
<h4>Implementation</h4>
<p>
This polynomial approximation is the inverse or backward function of
<a href=\"modelica://IBPSA.Media.Steam.specificEntropy\">
IBPSA.Media.Steam.specificEntropy</a> and is numerically
consistent with that forward function.
</html>", revisions="<html>
<ul>
<li>
October 30, 2020, by Kathryn Hinkelman:<br/>
First implementation.
</li>
</ul>
</html>"));
end temperature_s;

function rho_T "Density as function of temperature and p_default"
  extends Modelica.Icons.Function;
  input Temperature T "Temperature";
  output Density rho "Density";
  protected
  Modelica.Media.Common.GibbsDerivs g
    "Dimensionless Gibbs function and derivatives w.r.t. pi and tau";
  SpecificHeatCapacity R "Specific gas constant of water vapor";
algorithm
  R := Modelica.Media.Water.IF97_Utilities.BaseIF97.data.RH2O;
  // Region 2 properties
  g := g2(p_default, T);
  rho := p_default/(R*T*g.pi*g.gpi);
  annotation (smoothOrder=2,Inline=true,
      Documentation(info="<html>
<p>
Density is computed from temperature and <code>p_default</code> using the
IAPWS-IF97 relationship via the Gibbs free energy for region 2.
</p>
</html>"));
end rho_T;

function cp_T
  "Specific heat capacity at constant pressure as function of pressure and temperature"
  extends Modelica.Icons.Function;
  input Temperature T "Temperature";
  output SpecificHeatCapacity cp "Specific heat capacity";
  protected
  Modelica.Media.Common.GibbsDerivs g
    "Dimensionless Gibbs function and derivatives w.r.t. pi and tau";
  SpecificHeatCapacity R "Specific gas constant of water vapor";
algorithm
  R := Modelica.Media.Water.IF97_Utilities.BaseIF97.data.RH2O;
  // Region 2 properties
  g := g2(p_default, T);
  cp := -R*g.tau*g.tau*g.gtautau;
  annotation (
    smoothOrder=2,
    Inline=true,
      Documentation(info="<html>
<p>
Specific heat at constant pressure is computed from temperature and
<code>p_default</code> using the IAPWS-IF97 relationship via the Gibbs
free energy for region 2.
</p>
</html>"));
end cp_T;

function cv_T
  "Specific heat capacity at constant volume as function of pressure and temperature"
  extends Modelica.Icons.Function;
  input Temperature T "Temperature";
  output SpecificHeatCapacity cv "Specific heat capacity";
  protected
  Modelica.Media.Common.GibbsDerivs g
    "Dimensionless Gibbs function and derivatives w.r.t. pi and tau";
  SpecificHeatCapacity R "Specific gas constant of water vapor";
algorithm
  R := Modelica.Media.Water.IF97_Utilities.BaseIF97.data.RH2O;
  // Region 2 properties
  g := g2(p_default, T);
  cv := R*(-g.tau*g.tau*g.gtautau + ((g.gpi - g.tau*g.gtaupi)*(g.gpi
     - g.tau*g.gtaupi)/g.gpipi));
  annotation (
    smoothOrder=2,
    Inline=true,
    LateInline = true,
      Documentation(info="<html>
<p>
Specific heat at constant volume is computed from temperature and
<code>p_default</code> using the IAPWS-IF97 relationship via the Gibbs
free energy for region 2.
</p>
</html>",
revision="<html>
<ul>
<li>
December 6, 2020, by Michael Wetter:<br/>
Added <code>LateInline=true</code>.
This is required for OCT-r17595_JM-r14295, otherwise
<a href=\modelica://IBPSA.Media.Examples.SteamDerivativeCheck\">
IBPSA.Media.Examples.SteamDerivativeCheck</a>
does not translate.
</li>
</ul>
</html>"));
end cv_T;

function g2 "Gibbs function for region 2: g(p,T)"
  extends Modelica.Media.Water.IF97_Utilities.BaseIF97.Basic.g2;
  annotation(smoothOrder=1, Inline=true);
end g2;
  annotation (Icon(graphics={
      Line(
        points={{50,30},{30,10},{50,-10},{30,-30}},
        color={0,0,0},
        smooth=Smooth.Bezier),
      Line(
        points={{10,30},{-10,10},{10,-10},{-10,-30}},
        color={0,0,0},
        smooth=Smooth.Bezier),
      Line(
        points={{-30,30},{-50,10},{-30,-10},{-50,-30}},
        color={0,0,0},
        smooth=Smooth.Bezier)}), Documentation(info="<html>
<p>
This medium package models water vapor (pure steam, region 2, quality=1).
</p>
<p>
Thermodynamic properties are calculated primarily in terms of pressure
and temperature, with pressure assumed to be a constant value of
<code>p_default</code>. Thus, <code>p_default</code> needs to be set to
the correct pressure in applications of this model.
For thermodynamic property functions, the IAPWS-IF97 formulations are adapted,
as well as approximate relationships for commonly used functions to improve
computational efficiency and provide backward compatability.
</p>
<p>
Detailed functions from <a href=\"modelica://Modelica.Media.Water.WaterIF97_R2pT\">
Modelica.Media.Water.WaterIF97_R2pT</a> are generally used, expect for
<a href=\"modelica://IBPSA.Media.Steam.specificEnthalpy\">specificEnthalpy</a> and
<a href=\"modelica://IBPSA.Media.Steam.specificEntropy\">specificEntropy</a>
(both \"forward\" functions), as well as their \"backward\" inverse functions
<a href=\"modelica://IBPSA.Media.Steam.temperature_h\">temperature_h</a> and
<a href=\"modelica://IBPSA.Media.Steam.temperature_s\">temperature_s</a>,
which are numerically consistent with the forward functions.
The following modifications were made relative to the
<a href=\"modelica://Modelica.Media.Water.WaterIF97_R2pT\">
Modelica.Media.Water.WaterIF97_R2pT</a> medium package:
</p>
<ol>
<li>Analytic expressions for the derivatives are provided for all thermodynamic property functions.</li>
<li>The implementation is generally simplier in order to increase the likelyhood
of more efficient simulations. </li>
</ol>
<h4>Limitations </h4>
<ul>
<li>
The valid temperature range is <i>100&deg;C &le; T &le; 700&deg;C</i>, and the valid
pressure range is <i>100 kPa &le; p &le; 3000 kPa</i>, except for the
<a href=\"modelica://IBPSA.Media.Steam.saturationTemperature\">saturationTemperature</a> and
<a href=\"modelica://IBPSA.Media.Steam.saturationPressure\">saturationPressure</a>
functions, which are only valid below water's critical temperature of <i>373.946&deg;C</i>.
</li>
<li>When phase change is required, this model is to be used in combination with
<a href=\"modelica://IBPSA.Media.Water\">IBPSA.Media.Water</a>
for the liquid phase (quality=0). Please note that the maximum temperature for liquid
water is <code>T_max=130&deg;C</code>. This is suitable for real-world condensate
return and boiler feedwater systems, which are typically vented to the atmosphere
with steam contained via steam traps (thus, <code>T_max=100&deg;C</code> for the
condensate or feedwater in properly functioning systems).</li>
</ul>
<h4>Applications </h4>
<p>
This model is intended for first generation district heating systems and other
industrial processes involving medium and high pressure steam.
</p>
<p>For numerical robustness, applications of this medium model assume the pressure
is constant throughout the simulation. This is done to improve simulation
performance by decoupling the pressure drop and energy balance calculations. </p>
<h4>References </h4>
<p>W. Wagner et al., &ldquo;The IAPWS industrial formulation 1997 for the thermodynamic
properties of water and steam,&rdquo; <i>J. Eng. Gas Turbines Power</i>, vol. 122, no.
1, pp. 150&ndash;180, 2000.
</p>
</html>", revisions="<html>
<ul>
<li>
October 30, 2020, by Kathryn Hinkelman:<br/>
Complete new reimplementation to eliminate numerical inefficiencies
and improve accuracy of property function calculations.
</li>
</ul>
</html>"));
end Steam;

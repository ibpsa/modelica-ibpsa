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
    // Temperature and pressure values must be within acceptable max & min bounds
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
  annotation (Inline=true);
end density;

redeclare function extends dynamicViscosity
    "Return dynamic viscosity"
algorithm
    eta := Modelica.Media.Water.IF97_Utilities.dynamicViscosity(
          d=density(state),
          T=state.T,
          p=p_default);
    annotation (Inline=true);
end dynamicViscosity;

redeclare replaceable function extends specificEnthalpy
  "Returns specific enthalpy"
  protected
  Real a[:] = {3.354e+06,-1.661e+04,4.276e+05};
  AbsolutePressure pMean =  8.766717603911981e+05;
  Temperature TMean =  7.104788508557040e+02;
  Real pSD = 8.540705946819051e+05;
  Real TSD = 1.976242680354902e+02;
  AbsolutePressure pHat;
  Temperature THat;
algorithm
  pHat := (p_default - pMean)/pSD;
  THat := (state.T - TMean)/TSD;
  h := a[1] + a[2]*pHat + a[3]*THat;
annotation (Inline=true,smoothOrder=2);
end specificEnthalpy;

redeclare replaceable function extends molarMass
  "Return the molar mass of the medium"
algorithm
  MM := steam.MM;
end molarMass;

redeclare function extends pressure
  "Return pressure"
algorithm
  p := p_default;
end pressure;
/*replaceable function pressure_dT
  "Return pressure from d and T, inverse function of d(p,T)"
  input Density d "Density";
  input Temperature T "Temperature";
  output AbsolutePressure p "Absolute Pressure";
algorithm 
  p := Modelica.Media.Water.IF97_Utilities.p_dT(d,T);
annotation (Inline=true,smoothOrder=1);
end pressure_dT;*/

replaceable function saturationPressure
  "Return saturation pressure of condensing fluid"
    extends Modelica.Icons.Function;
    input Temperature Tsat "Saturation temperature";
    output AbsolutePressure psat "Saturation pressure";
algorithm
   psat := Modelica.Media.Water.IF97_Utilities.BaseIF97.Basic.psat(Tsat);

 annotation (Inline=true);
end saturationPressure;

replaceable function saturationTemperature
    "Return saturation temperature"
  input AbsolutePressure psat "Saturation pressure";
  output Temperature Tsat "Saturation temperature";
algorithm
    Tsat := Modelica.Media.Water.IF97_Utilities.BaseIF97.Basic.tsat(psat);
    annotation (Inline=true);
end saturationTemperature;

redeclare function extends specificEntropy
  "Return specific entropy"
  protected
  Real a[:] = {7801,-445.2,594.7};
  AbsolutePressure pMean =  8.766717603911981e+05;
  Temperature TMean =  7.104788508557040e+02;
  Real pSD = 8.540705946819051e+05;
  Real TSD = 1.976242680354902e+02;
  AbsolutePressure pHat;
  Temperature THat;
algorithm
  pHat := (p_default - pMean)/pSD;
  THat := (state.T - TMean)/TSD;
  s := a[1] + a[2]*pHat + a[3]*THat;
annotation (Inline=true,smoothOrder=1);
end specificEntropy;

redeclare replaceable function extends specificInternalEnergy
  "Return specific internal energy"
algorithm
  u := specificEnthalpy(state) - p_default/density(state);
  annotation (Inline=true);
end specificInternalEnergy;

redeclare replaceable function extends specificHeatCapacityCp
  "Specific heat capacity at constant pressure"
algorithm
  cp := cp_T(state.T);
  annotation (Inline=true);
end specificHeatCapacityCp;

redeclare replaceable function extends specificHeatCapacityCv
  "Specific heat capacity at constant volume"
algorithm
  cv := cv_T(state.T);
  annotation (Inline=true);
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
  annotation (Inline=true);
end specificHelmholtzEnergy;

redeclare function extends setState_dTX
    "Return the thermodynamic state as function of d, T and composition X or Xi"
algorithm
  state := ThermodynamicState(p=p_default, T=T); //, X={1}
annotation (Inline=true,smoothOrder=2);
end setState_dTX;

redeclare function extends setState_pTX
    "Return the thermodynamic state as function of p, T and composition X or Xi"
algorithm
  state := ThermodynamicState(p=p_default, T=T);
annotation (Inline=true,smoothOrder=2);
end setState_pTX;

redeclare function extends setState_phX
    "Return the thermodynamic state as function of p, h and composition X or Xi"
algorithm
  state := ThermodynamicState(p=p_default, T=temperature_h(h));
annotation (Inline=true,smoothOrder=2);
end setState_phX;

redeclare function extends setState_psX
    "Return the thermodynamic state as function of p, s and composition X or Xi"
algorithm
  state := ThermodynamicState(p=p_default, T=temperature_s(s));
annotation (Inline=true,smoothOrder=2);
end setState_psX;

redeclare function extends temperature
    "Return temperature"
algorithm
  T := state.T;
end temperature;

replaceable function temperature_h
  "Return temperature from h, inverse function of h(T)"
  input SpecificEnthalpy h "Specific Enthalpy";
  output Temperature T "Temperature";
  protected
  Real a[:] = {3.354e+06,-1.661e+04,4.276e+05} "Coefficients from forward function h(p,T)";
  Real b[:] = {-a[1]*TSD/a[3]+TMean, -a[2]*TSD/a[3], TSD/a[3]};
  AbsolutePressure pMean =  8.766717603911981e+05;
  Temperature TMean =  7.104788508557040e+02;
  Real pSD = 8.540705946819051e+05;
  Real TSD = 1.976242680354902e+02;
  AbsolutePressure pHat;
algorithm
  pHat := (p_default - pMean)/pSD;
  T := b[1] + b[2]*pHat + b[3]*h;
annotation (Inline=true,smoothOrder=1);
end temperature_h;

replaceable function temperature_s
  "Return temperature from s, inverse function of s(T)"
  input SpecificEntropy s "Specific Entropy";
  output Temperature T "Temperature";
  protected
  Real a[:] = {7801,-445.2,594.7} "Coefficients from forward function s(p,T)";
  Real b[:] = {-a[1]*TSD/a[3]+TMean, -a[2]*TSD/a[3], TSD/a[3]};
  AbsolutePressure pMean =  8.766717603911981e+05;
  Temperature TMean =  7.104788508557040e+02;
  Real pSD = 8.540705946819051e+05;
  Real TSD = 1.976242680354902e+02;
  AbsolutePressure pHat;
algorithm
  pHat := (p_default - pMean)/pSD;
  T := b[1] + b[2]*pHat + b[3]*s;
annotation (Inline=true,smoothOrder=1);
end temperature_s;

redeclare replaceable function extends thermalConductivity
  "Return thermal conductivity"
algorithm
  lambda := Modelica.Media.Water.IF97_Utilities.thermalConductivity(
        density(state),
        state.T,
        p_default);
  annotation (Inline=true);
end thermalConductivity;

redeclare function extends density_derh_p
  "Density derivative by specific enthalpy"
algorithm
  ddhp := Modelica.Media.Water.IF97_Utilities.ddhp(
        p_default,
        specificEnthalpy(state),
        phase,
        region);
  annotation (Inline=true);
end density_derh_p;

redeclare function extends density_derp_h
  "Density derivative by pressure"
algorithm
  ddph := Modelica.Media.Water.IF97_Utilities.ddph(
        p_default,
        specificEnthalpy(state),
        phase,
        region);
  annotation (Inline=true);
end density_derp_h;

redeclare replaceable function extends isentropicExponent
  "Return isentropic exponent"
algorithm
  gamma := Modelica.Media.Water.IF97_Utilities.isentropicExponent_pT(
        p_default,
        state.T,
        region);
  annotation (Inline=true);
end isentropicExponent;

redeclare replaceable function extends isothermalCompressibility
  "Isothermal compressibility of water"
algorithm
  kappa := Modelica.Media.Water.IF97_Utilities.kappa_pT(
        p_default,
        state.T,
        region);
  annotation (Inline=true);
end isothermalCompressibility;

redeclare replaceable function extends isobaricExpansionCoefficient
  "Isobaric expansion coefficient of water"
algorithm
  beta := Modelica.Media.Water.IF97_Utilities.beta_pT(
        p_default,
        state.T,
        region);
end isobaricExpansionCoefficient;

redeclare replaceable function extends isentropicEnthalpy
  "Compute h(s,p)"
algorithm
  h_is := Modelica.Media.Water.IF97_Utilities.isentropicEnthalpy(
        p_downstream,
        specificEntropy(refState),
        0);
  annotation (Inline=true);
end isentropicEnthalpy;

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

function rho_T "Density as function or pressure and temperature"
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
  annotation (smoothOrder=2,Inline=true);
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
  Integer error "Error flag for inverse iterations";
algorithm
  R := Modelica.Media.Water.IF97_Utilities.BaseIF97.data.RH2O;
  // Region 2 properties
  g := g2(p_default, T);
  cp := -R*g.tau*g.tau*g.gtautau;
  annotation (
    smoothOrder=2,
    Inline=true);
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
  Integer error "Error flag for inverse iterations";
algorithm
  R := Modelica.Media.Water.IF97_Utilities.BaseIF97.data.RH2O;
  // Region 2 properties
  g := g2(p_default, T);
  cv := R*(-g.tau*g.tau*g.gtautau + ((g.gpi - g.tau*g.gtaupi)*(g.gpi
     - g.tau*g.gtaupi)/g.gpipi));
  annotation (
    smoothOrder=2,
    Inline=true);
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
The following modifications from the WaterIF97_R2pT medium packages were made: 
</p>
<ol>
<li>Automatic differentiation is provided for all thermodynamic property functions.</li>
<li>The implementation is generally simplier in order to increase the likelyhood 
of more efficient simulations. </li>
</ol>
<h4>Limitations </h4>
<ul>
<li>
The valid temperature range is <i>100 C &le; T &le; 700 C</i>, and the valid 
pressure range is <i>100 kPa &le; p &le; 1000 kPa</i> (medium pressure systems), except for the 
<a href=\"modelica://IBPSA.Media.Steam.saturationTemperature\">saturationTemperature</a> and 
<a href=\"modelica://IBPSA.Media.Steam.saturationPressure\">saturationPressure</a> 
functions, which are only valid below water's critical temperature of <i>373.946 C</i>. 
</li>
<li>When phase change is required, this model is to be used in combination with 
the <a href=\"modelica://IBPSA.Media.Specialized.Water.HighTemperature\">IBPSA.Media.Specialized.Water.HighTemperature</a> 
media model for incompressible liquid water for the liquid phase (quality = 0). </li>
</ul>
<h4>Applications </h4>
<p>
This model is intended for first generation district heating systems and other 
industrial processes involving medium pressure steam.
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

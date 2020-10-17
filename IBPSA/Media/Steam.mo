within IBPSA.Media;
package Steam
  "Package with model for region 2 (steam) water according to IF97 standard"
  extends Modelica.Media.Interfaces.PartialCondensingGases(
     mediumName="steam",
     final substanceNames={"water"},
     final singleState = false,
     final fixedX = true,
     fluidConstants={Modelica.Media.IdealGases.Common.FluidData.H2O},
     reference_T=273.15,
     reference_p=101325,
     reference_X={1},
     AbsolutePressure(start=p_default),
     Temperature(start=T_default),
     SpecificEnthalpy(start=1.0e5, nominal=5.0e5),
     Density(start=150, nominal=500),
     T_default=Modelica.SIunits.Conversions.from_degC(100));
  extends Modelica.Icons.Package;

  redeclare replaceable record extends ThermodynamicState
    "Thermodynamic state variables"
    AbsolutePressure p "Absolute pressure of medium";
    Temperature T "Temperature of medium";
    MassFraction[nX] X(start=reference_X)
      "Mass fractions (= (component mass)/total mass  m_i/m)";
  end ThermodynamicState;

  redeclare replaceable model extends BaseProperties(
    T(stateSelect=if preferredMediumStates then StateSelect.prefer
           else StateSelect.default),
    p(stateSelect=if preferredMediumStates then StateSelect.prefer
  else StateSelect.default))
    "Base properties (p, d, T, h, u, R, MM, sat) of water"
  equation
    // Temperature and pressure values must be within acceptable max & min bounds
    // Assert statements
    MM = steam.MM;
    h = specificEnthalpy(state);
    d = density(state);
    //d = p/(R*T);
    u = h - p/d;
    R = steam.R;
    p = state.p;
    T = state.T;
    X = state.X;
    //X = reference_X;
  end BaseProperties;

redeclare replaceable function extends density
  "Returns density"
  protected
  Real a[:] = {2.752,2.938,-0.8873,-0.8445,0.2132};
  AbsolutePressure pMean =  8.766717603911981e+05;
  Temperature TMean =  7.104788508557040e+02;
  Real pSD = 8.540705946819051e+05;
  Real TSD = 1.976242680354902e+02;
  AbsolutePressure pHat=(state.p - pMean)/pSD;
  Temperature THat=(state.T - TMean)/TSD;
algorithm
  d := a[1] + a[2]*pHat + a[3]*THat + a[4]*pHat*THat + a[5]*THat^2;
  annotation (Inline=true,smoothOrder=2);
end density;
/*redeclare replaceable function extends density
  "Returns density"
  protected 
  Real a[:] = {2.702,2.653,-0.7555,0.02029,-0.7485,0.2043,-0.0521,0.2587,
    -0.1007,0.06978,-0.1735,0.0566,-0.02713,0.06016,-0.01156};
  AbsolutePressure pMean =  8.766717603911981e+05;
  Temperature TMean =  7.104788508557040e+02;
  Real pSD = 8.540705946819051e+05;
  Real TSD = 1.976242680354902e+02;
  AbsolutePressure pHat;
  Temperature THat;
algorithm 
   // function of state
   //d := state.p/(steam.R*state.T);
  pHat :=(state.p - pMean)/pSD;
  THat :=(state.T - TMean)/TSD;
  d := a[1] + a[2]*pHat + a[3]*THat + a[4]*pHat^2 + a[5]*pHat*THat +
    a[6]*THat^2 + a[7]*pHat^2*THat + a[8]*pHat*THat^2 + a[9]*THat^3 +
    a[10]*pHat^2*THat^2 + a[11]*pHat*THat^3 + a[12]*THat^4 +
    a[13]*pHat^2*THat^3 + a[14]*pHat*THat^4 + a[15]*THat^5;
  annotation (Inline=true);
end density;
*/

redeclare function extends dynamicViscosity
    "Return the dynamic viscosity of dry air"
algorithm
  eta :=  1;
annotation (Inline=true);
end dynamicViscosity;

redeclare replaceable function extends enthalpyOfGas
  "Return enthalpy of non-condensing gas mixture"
  //    input Temperature T "Temperature";
  //    input MassFraction[:] X "Vector of mass fractions";
  //    output SpecificEnthalpy h "Specific enthalpy";
algorithm

annotation (Inline=true);
end enthalpyOfGas;

redeclare replaceable function extends enthalpyOfLiquid
  "Return liquid enthalpy of condensing fluid"
  //    input Temperature T "Temperature";
  //    output SpecificEnthalpy h "Liquid enthalpy";
algorithm
annotation (Inline=true);
end enthalpyOfLiquid;

redeclare replaceable function extends enthalpyOfVaporization
  "Return vaporization enthalpy of condensing fluid"
  //    input Temperature T "Temperature";
  //    output SpecificEnthalpy r0 "Vaporization enthalpy";
algorithm
annotation (Inline=true);
end enthalpyOfVaporization;

redeclare replaceable function extends specificEnthalpy
  "Returns specific enthalpy"
  protected
  Real a[:] = {3354,-16.61,427.6};
  AbsolutePressure pMean =  8.766717603911981e+05;
  Temperature TMean =  7.104788508557040e+02;
  Real pSD = 8.540705946819051e+05;
  Real TSD = 1.976242680354902e+02;
  AbsolutePressure pHat=(state.p - pMean)/pSD;
  Temperature THat=(state.T - TMean)/TSD;
algorithm
  h := a[1] + a[2]*pHat + a[3]*THat;
annotation (Inline=true,smoothOrder=1);
end specificEnthalpy;

redeclare function extends pressure
  "Return pressure"
algorithm
  p := state.p;
end pressure;

replaceable function pressure_dT
  "Return pressure from d and T, inverse function of d(p,T)"
  input Density d "Density";
  input Temperature T "Temperature";
  output AbsolutePressure p "Absolute Pressure";
  protected
  Real a[:] = {2.752,2.938,-0.8873,-0.8445,0.2132};
  AbsolutePressure pMean =  8.766717603911981e+05;
  Temperature TMean =  7.104788508557040e+02;
  Real pSD = 8.540705946819051e+05;
  Real TSD = 1.976242680354902e+02;
  Temperature THat=(T - TMean)/TSD;
algorithm
  p := pSD/(a[2]+a[4]*THat)*(-a[1]+d-THat*(a[3]+a[5]*THat))+pMean;
annotation (Inline=true,smoothOrder=1);
end pressure_dT;

 redeclare replaceable function extends saturationPressure
  "Return saturation pressure of condensing fluid"
  //    input Temperature Tsat "Saturation temperature";
  //    output AbsolutePressure psat "Saturation pressure";
 algorithm
 annotation (Inline=true);
 end saturationPressure;

replaceable function saturationTemperature
  "Return saturation temperature from a given pressure"
  extends Modelica.Icons.Function;
  input AbsolutePressure p "Pressure";
  output Temperature T   "Saturation temperature";
  protected
  Real a[:] = {2.2830066E+02,1.1893913E+00,5.2484699E-01,1.2416857E-01,
    -1.3714779E-02,5.5702047E-04}
    "Coefficients";
  Real logP = log(p);
algorithm
  T := a[1] + a[2]*logP + a[3]*logP^2 + a[4]*logP^3 +
    a[5]*logP^4 + a[6]*logP^5
  "Saturation temperature";
annotation (
  smoothOrder=2,
  Documentation(info="<html>
  <p>
  Saturation temperature is computed from pressure. This relation is
  valid in the region of <i>273.16</i> to <i>647.096</i> K (<i>613.3</i> to <i>22,049,100</i> Pa).
  </p>
  <p>
  The function has the following form:
  </p>
  <p align=\"center\" style=\"font-style:italic;\">
  T = a<sub>1</sub> + a<sub>2</sub> ln(p) + a<sub>3</sub> ln(p)<sup>2</sup> +
  a<sub>4</sub> ln(p)<sup>3</sup> + a<sub>5</sub> ln(p)<sup>4</sup> + a<sub>6</sub> ln(p)<sup>5</sup>
  </p>
  <p>
  where temperature <i>T</i> is in units Kelvin, pressure <i>p</i> is in units Pa, and <i>a<sub>1</sub></i>
  through <i>a<sub>6</sub></i> are regression coefficients.
  </p>
  </html>", revisions="<html>
  <ul>
  <li>
  March 6, 2020, by Kathryn Hinkelman:<br/>
  First implementation.
  </li>
  </ul>
  </html>"));
end saturationTemperature;

redeclare function extends specificEntropy
  "Return specific entropy"
  protected
  Real a[:] = {7.801,-0.4452,0.5947};
  AbsolutePressure pMean =  8.766717603911981e+05;
  Temperature TMean =  7.104788508557040e+02;
  Real pSD = 8.540705946819051e+05;
  Real TSD = 1.976242680354902e+02;
  AbsolutePressure pHat=(state.p - pMean)/pSD;
  Temperature THat=(state.T - TMean)/TSD;
algorithm
  s := a[1] + a[2]*pHat + a[3]*THat;
annotation (Inline=true,smoothOrder=1);
end specificEntropy;

redeclare replaceable function extends specificHeatCapacityCp
  "Specific heat capacity at constant pressure"
  protected
  Real a[:] = {3354,-16.61,427.6};
  Real TSD = 1.976242680354902e+02;
algorithm
  cp := a[3]/TSD;
annotation (Inline=true,smoothOrder=1);
end specificHeatCapacityCp;

redeclare replaceable function extends specificHeatCapacityCv
  "Specific heat capacity at constant volume"
algorithm
  cv :=5;
annotation (Inline=true,smoothOrder=1);
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
  ThermodynamicState(p=pressure_dT(d,T), T=T, X=X);
annotation (Inline=true,smoothOrder=2);
end setState_dTX;

redeclare function extends setState_pTX
    "Return the thermodynamic state as function of p, T and composition X or Xi"
algorithm
  ThermodynamicState(p=p, T=T, X=X);
annotation (Inline=true,smoothOrder=2);
end setState_pTX;

redeclare function extends setState_phX
    "Return the thermodynamic state as function of p, h and composition X or Xi"
algorithm
  ThermodynamicState(p=p, T=temperature_ph(p,h), X=X);
annotation (Inline=true,smoothOrder=2);
end setState_phX;

redeclare function extends setState_psX
    "Return the thermodynamic state as function of p, s and composition X or Xi"
algorithm
  ThermodynamicState(p=p, T=temperature_ps(p,s), X=X);
annotation (Inline=true,smoothOrder=2);
end setState_psX;

redeclare function extends temperature
    "Return temperature"
algorithm
  T := state.T;
end temperature;

replaceable function temperature_ph
  "Return temperature from p and h, inverse function of h(p,T)"
  input AbsolutePressure p "Absolute Pressure";
  input SpecificEnthalpy h "Specific Enthalpy";
  output Temperature T "Temperature";
  protected
  Real a[:] = {3354,-16.61,427.6} "Coefficients from forward function h(p,T)";
  Real b[:] = {-a[1]*TSD/a[3]+TMean, -a[2]*TSD/a[3], TSD/a[3]};
  AbsolutePressure pMean =  8.766717603911981e+05;
  Temperature TMean =  7.104788508557040e+02;
  Real pSD = 8.540705946819051e+05;
  Real TSD = 1.976242680354902e+02;
  AbsolutePressure pHat=(p - pMean)/pSD;
algorithm
  T := b[1] + b[2]*pHat + b[3]*h;
annotation (Inline=true,smoothOrder=1);
end temperature_ph;

replaceable function temperature_ps
  "Return temperature from p and s, inverse function of s(p,T)"
  input AbsolutePressure p "Absolute Pressure";
  input SpecificEntropy s "Specific Entropy";
  output Temperature T "Temperature";
  protected
  Real a[:] = {7.801,-0.4452,0.5947} "Coefficients from forward function s(p,T)";
  Real b[:] = {-a[1]*TSD/a[3]+TMean, -a[2]*TSD/a[3], TSD/a[3]};
  AbsolutePressure pMean =  8.766717603911981e+05;
  Temperature TMean =  7.104788508557040e+02;
  Real pSD = 8.540705946819051e+05;
  Real TSD = 1.976242680354902e+02;
  AbsolutePressure pHat=(p - pMean)/pSD;
algorithm
  T := b[1] + b[2]*pHat + b[3]*s;
annotation (Inline=true,smoothOrder=1);
end temperature_ps;
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
        smooth=Smooth.Bezier)}));
end Steam;

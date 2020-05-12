within IBPSA.Media;
package Steam "Package with model for region 2 (steam) water according to IF97 standard"
  extends Modelica.Media.Interfaces.PartialMedium(
    redeclare replaceable record FluidConstants =
        Modelica.Media.Interfaces.Types.TwoPhase.FluidConstants,
    mediumName="WaterIF97_R2pT",
    substanceNames={"water"},
    singleState=false,
    SpecificEnthalpy(start=1.0e5, nominal=5.0e5),
    Density(start=150, nominal=500),
    AbsolutePressure(
      start=50e5,
      nominal=10e5,
      min=611.657,
      max=100e6),
    Temperature(
      start=500,
      nominal=500,
      min=273.15,
      max=2273.15));
   extends Modelica.Icons.Package;

  constant FluidConstants[1] fluidConstants=
     Modelica.Media.Water.waterConstants
     "Constant data for water";

  redeclare record extends ThermodynamicState "Thermodynamic state"
    SpecificEnthalpy h "Specific enthalpy";
    Density d "Density";
    Temperature T "Temperature";
    AbsolutePressure p "Pressure";
  end ThermodynamicState;
  constant Integer region = 2 "Region of IF97, if known, zero otherwise";
  constant Integer phase = 1 "1 for one-phase";

  redeclare replaceable partial model extends BaseProperties
    "Base properties (p, d, T, h, u, R, MM, sat) of water"
    SaturationProperties sat "Saturation properties at the medium pressure";

  equation
    MM = fluidConstants[1].molarMass;
    h = specificEnthalpy(state);
    d = density(state);
    sat.psat = p;
    sat.Tsat = saturationTemperature_p(p);
    u = h - p/d;
    R = Modelica.Constants.R/fluidConstants[1].molarMass;
    h = state.h;
    p = state.p;
    T = state.T;
    d = state.d;
    phase = phase;
  end BaseProperties;

  redeclare function extends dynamicViscosity "Return dynamic viscosity"
    extends Modelica.Icons.Function;
    input ThermodynamicState state "Thermodynamic state record";
    output DynamicViscosity eta "Dynamic viscosity";
  algorithm
    eta := Modelica.Media.Water.IF97_Utilities.dynamicViscosity(
          state.d,
          state.T,
          state.p,
          phase);
    annotation (Inline=true);
  end dynamicViscosity;

  redeclare function extends thermalConductivity
    "Return thermal conductivity"
    extends Modelica.Icons.Function;
    input ThermodynamicState state "Thermodynamic state record";
    output ThermalConductivity lambda "Thermal conductivity";
  algorithm
    lambda := Modelica.Media.Water.IF97_Utilities.thermalConductivity(
          state.d,
          state.T,
          state.p,
          phase);
    annotation (Inline=true);
  end thermalConductivity;

  redeclare function extends pressure "Return pressure"
    extends Modelica.Icons.Function;
    input ThermodynamicState state "Thermodynamic state record";
    output AbsolutePressure p "Pressure";
  algorithm
    p := state.p;
    annotation (Inline=true);
  end pressure;

  redeclare function extends temperature "Return temperature"
    extends Modelica.Icons.Function;
    input ThermodynamicState state "Thermodynamic state record";
    output Temperature T "Temperature";
  algorithm
   T := state.T;
    annotation (Inline=true);
  end temperature;

  redeclare function extends density "Return density"
    extends Modelica.Icons.Function;
    input ThermodynamicState state "Thermodynamic state record";
    output Density d "Density";
  algorithm
    d := state.d;
    //    d := Modelica.Media.Water.IF97_Utilities.rho_pT(
    //          state.p,
    //          state.T,
    //          region);
    annotation (Inline=true);
  end density;

  redeclare function extends specificEnthalpy "Return specific enthalpy"
    extends Modelica.Icons.Function;
    input ThermodynamicState state "Thermodynamic state record";
    output SpecificEnthalpy h "Specific enthalpy";
  algorithm
    h := state.h;
    annotation (Inline=true);
  end specificEnthalpy;

  redeclare function extends specificInternalEnergy
    "Return specific internal energy"
    extends Modelica.Icons.Function;
    input ThermodynamicState state "Thermodynamic state record";
    output SpecificEnergy u "Specific internal energy";
  algorithm
    u := state.h - state.p/state.d;
    annotation (Inline=true);
  end specificInternalEnergy;

  redeclare function extends specificEntropy "Return specific entropy"
    extends Modelica.Icons.Function;
    input ThermodynamicState state "Thermodynamic state record";
    output SpecificEntropy s "Specific entropy";
  algorithm
    s := Modelica.Media.Water.IF97_Utilities.s_pT(
          state.p,
          state.T,
          region);
    annotation (Inline=true);
  end specificEntropy;

  redeclare function extends specificGibbsEnergy
    "Return specific Gibbs energy"
    extends Modelica.Icons.Function;
    input ThermodynamicState state "Thermodynamic state record";
    output SpecificEnergy g "Specific Gibbs energy";
  algorithm
    g := state.h - state.T*specificEntropy(state);
    annotation (Inline=true);
  end specificGibbsEnergy;

  redeclare function extends specificHelmholtzEnergy
    "Return specific Helmholtz energy"
    extends Modelica.Icons.Function;
    input ThermodynamicState state "Thermodynamic state record";
    output SpecificEnergy f "Specific Helmholtz energy";
  algorithm
    f := state.h - state.p/state.d - state.T*specificEntropy(state);
    annotation (Inline=true);
  end specificHelmholtzEnergy;

  redeclare function extends specificHeatCapacityCp
    "Return specific heat capacity at constant pressure"
    extends Modelica.Icons.Function;
    input ThermodynamicState state "Thermodynamic state record";
    output SpecificHeatCapacity cp
      "Specific heat capacity at constant pressure";
  algorithm
    cp := Modelica.Media.Water.IF97_Utilities.cp_pT(
          state.p,
          state.T,
          region);
    annotation (Inline=true);
  end specificHeatCapacityCp;

  redeclare function extends specificHeatCapacityCv
    "Return specific heat capacity at constant volume"
    extends Modelica.Icons.Function;
    input ThermodynamicState state "Thermodynamic state record";
    output SpecificHeatCapacity cv
      "Specific heat capacity at constant volume";
  algorithm
    cv := Modelica.Media.Water.IF97_Utilities.cv_pT(
          state.p,
          state.T,
          region);
    annotation (Inline=true);
  end specificHeatCapacityCv;
  // Saturation state functions

  replaceable function saturationTemperature_p
    "Return saturation temperature"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    output Temperature T "Saturation temperature";
  algorithm
    T := Modelica.Media.Water.IF97_Utilities.BaseIF97.Basic.tsat(p);
    annotation (Inline=true);
  end saturationTemperature_p;

  replaceable function enthalpyOfSaturatedLiquid_sat
    "Return enthalpy of saturated liquid"
    extends Modelica.Icons.Function;
    input SaturationProperties sat "Saturation property record";
    output SpecificEnthalpy hl "Boiling curve specific enthalpy";
  algorithm
    hl := Modelica.Media.Water.IF97_Utilities.BaseIF97.Regions.hl_p(sat.psat);
    annotation (Inline=true);
  end enthalpyOfSaturatedLiquid_sat;

  replaceable function enthalpyOfSaturatedVapor_sat
    "Return enthalpy of saturated vapor"
    extends Modelica.Icons.Function;
    input SaturationProperties sat "Saturation property record";
    output SpecificEnthalpy hv "Dew curve specific enthalpy";
  algorithm
    hv := Modelica.Media.Water.IF97_Utilities.BaseIF97.Regions.hv_p(sat.psat);
    annotation (Inline=true);
  end enthalpyOfSaturatedVapor_sat;

  replaceable function enthalpyOfVaporization_sat
    "Return enthalpy of vaporization"
    extends Modelica.Icons.Function;
    input SaturationProperties sat "Saturation property record";
    output SpecificEnthalpy hlv "Vaporization enthalpy";
  algorithm
    hlv := enthalpyOfSaturatedVapor_sat(sat)-enthalpyOfSaturatedLiquid_sat(sat);
    annotation (Inline=true);
  end enthalpyOfVaporization_sat;

  replaceable function entropyOfSaturatedLiquid_sat
    "Return entropy of saturated liquid"
    extends Modelica.Icons.Function;
    input SaturationProperties sat "Saturation property record";
    output SpecificEntropy sl "Boiling curve specific entropy";
  algorithm
    sl := Modelica.Media.Water.IF97_Utilities.BaseIF97.Regions.sl_p(sat.psat);
    annotation (Inline=true);
  end entropyOfSaturatedLiquid_sat;

  replaceable function entropyOfSaturatedVapor_sat
    "Return entropy of saturated vapor"
    extends Modelica.Icons.Function;
    input SaturationProperties sat "Saturation property record";
    output SpecificEntropy sv "Dew curve specific entropy";
  algorithm
    sv := Modelica.Media.Water.IF97_Utilities.BaseIF97.Regions.sv_p(sat.psat);
    annotation (Inline=true);
  end entropyOfSaturatedVapor_sat;

  replaceable function entropyOfVaporization_sat
    "Return entropy of vaporization"
    extends Modelica.Icons.Function;
    input SaturationProperties sat "Saturation property record";
    output SpecificEntropy slv "Vaporization entropy";
  algorithm
    slv := entropyOfSaturatedVapor_sat(sat)-entropyOfSaturatedLiquid_sat(sat);
    annotation (Inline=true);
  end entropyOfVaporization_sat;

  replaceable function densityOfSaturatedLiquid_sat
       "Return density of saturated liquid"
    extends Modelica.Icons.Function;
    input SaturationProperties sat "Saturation property record";
    output Density dl "Boiling curve density";
  algorithm
    dl := Modelica.Media.Water.IF97_Utilities.BaseIF97.Regions.rhol_p(sat.psat)
    annotation (Inline=true);
  end densityOfSaturatedLiquid_sat;

  replaceable function densityOfSaturatedVapor_sat
    "Return density of saturated vapor"
    extends Modelica.Icons.Function;
    input SaturationProperties sat "Saturation property record";
    output Density dv "Dew curve density";
  algorithm
    dv := Modelica.Media.Water.IF97_Utilities.BaseIF97.Regions.rhov_p(sat.psat)
    annotation (Inline=true);
  end densityOfSaturatedVapor_sat;
 // Set state functions

  redeclare function extends setState_pTX
    "Return thermodynamic state as function of p, T and composition X or Xi"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input Temperature T "Temperature";
    input MassFraction X[:]=reference_X "Mass fractions";
    output ThermodynamicState state "Thermodynamic state record";
  algorithm
    /*    state := ThermodynamicState(
          d=density_pT(
            p,
            T,
            region=region),
          T=T,
          phase=1,
          h=specificEnthalpy_pT(
            p,
            T,
            region=region),
          p=p);   */
    annotation (Inline=true);
  end setState_pTX;

  redeclare function extends setState_phX
    "Return thermodynamic state as function of p, h and composition X or Xi"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input SpecificEnthalpy h "Specific enthalpy";
    input MassFraction X[:]=reference_X "Mass fractions";
    output ThermodynamicState state "Thermodynamic state record";
  algorithm
    annotation (Inline=true);
  end setState_phX;

  redeclare function extends setState_psX
    "Return thermodynamic state as function of p, s and composition X or Xi"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input SpecificEntropy s "Specific entropy";
    input MassFraction X[:]=reference_X "Mass fractions";
    output ThermodynamicState state "Thermodynamic state record";
  algorithm
    annotation (Inline=true);
  end setState_psX;

  redeclare function extends setState_dTX
    "Return thermodynamic state as function of d, T and composition X or Xi"
    extends Modelica.Icons.Function;
    input Density d "Density";
    input Temperature T "Temperature";
    input MassFraction X[:]=reference_X "Mass fractions";
    output ThermodynamicState state "Thermodynamic state record";
  algorithm
    annotation (Inline=true);
  end setState_dTX;

  redeclare function extends setSmoothState
    "Return thermodynamic state so that it smoothly approximates: if x > 0 then state_a else state_b"
    extends Modelica.Icons.Function;
    input Real x "m_flow or dp";
    input ThermodynamicState state_a "Thermodynamic state if x > 0";
    input ThermodynamicState state_b "Thermodynamic state if x < 0";
    input Real x_small(min=0)
      "Smooth transition in the region -x_small < x < x_small";
    output ThermodynamicState state
      "Smooth thermodynamic state for all x (continuous and differentiable)";
  algorithm

    annotation (
      Inline=true,
      Documentation(info="<html>
<p>
This function is used to approximate the equation
</p>
<pre>
    state = <strong>if</strong> x &gt; 0 <strong>then</strong> state_a <strong>else</strong> state_b;
</pre>

<p>
by a smooth characteristic, so that the expression is continuous and differentiable:
</p>

<pre>
   state := <strong>smooth</strong>(1, <strong>if</strong> x &gt;  x_small <strong>then</strong> state_a <strong>else</strong>
                      <strong>if</strong> x &lt; -x_small <strong>then</strong> state_b <strong>else</strong> f(state_a, state_b));
</pre>

<p>
This is performed by applying function <strong>Media.Common.smoothStep</strong>(..)
on every element of the thermodynamic state record.
</p>

<p>
If <strong>mass fractions</strong> X[:] are approximated with this function then this can be performed
for all <strong>nX</strong> mass fractions, instead of applying it for nX-1 mass fractions and computing
the last one by the mass fraction constraint sum(X)=1. The reason is that the approximating function has the
property that sum(state.X) = 1, provided sum(state_a.X) = sum(state_b.X) = 1.
This can be shown by evaluating the approximating function in the abs(x) &lt; x_small
region (otherwise state.X is either state_a.X or state_b.X):
</p>

<pre>
    X[1]  = smoothStep(x, X_a[1] , X_b[1] , x_small);
    X[2]  = smoothStep(x, X_a[2] , X_b[2] , x_small);
       ...
    X[nX] = smoothStep(x, X_a[nX], X_b[nX], x_small);
</pre>

<p>
or
</p>

<pre>
    X[1]  = c*(X_a[1]  - X_b[1])  + (X_a[1]  + X_b[1])/2
    X[2]  = c*(X_a[2]  - X_b[2])  + (X_a[2]  + X_b[2])/2;
       ...
    X[nX] = c*(X_a[nX] - X_b[nX]) + (X_a[nX] + X_b[nX])/2;
    c     = (x/x_small)*((x/x_small)^2 - 3)/4
</pre>

<p>
Summing all mass fractions together results in
</p>

<pre>
    sum(X) = c*(sum(X_a) - sum(X_b)) + (sum(X_a) + sum(X_b))/2
           = c*(1 - 1) + (1 + 1)/2
           = 1
</pre>

</html>"));
  end setSmoothState;

  replaceable function saturationState_p
    "Return saturation property record from pressure"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    output SaturationProperties sat "Saturation property record";
  algorithm
    sat.psat := p;
    sat.Tsat := saturationTemperature_p(p);
  annotation (
    smoothOrder=2,
    Documentation(info="<html>
    <p>
    Returns the saturation state for given pressure. This relation is
    valid in the region of <i>0</i> to <i>800</i> C (<i>0</i> to <i>100</i> MPa).
    This corresponds to Region 2 of the IAPWS-IF97 water medium models.
    </p>
</html>",   revisions="<html>
<ul>
<li>
May 6, 2020, by Kathryn Hinkelman:<br/>
First implementation.
</li>
</ul>
</html>"));
  end saturationState_p;
annotation (Documentation(info="<html>
<p>
The steam model based on IF97 formulations can be utilized for steam systems 
and components that use the vapor phase of water (regeion 2, quality = 1).
</p>
<p>
Thermodynamic properties are formulated from the International Association for the 
Properties of Water and Steam (IAPWS) 1997 forumulations for water and steam. The
thermodynamic regions as determiend by IAPWS-IF97 are as follows:
</p>
<p align=\"center\">
<img src=\"modelica://IBPSA/Resources/Images/Media/Steam/SteamIF97Regions.PNG\"
alt=\"IF97 Water Steam Regions\" width=\"600\"/>
</p>
<h4>
Limitations
</h4>
<ul>
<li>
The properties are valid in Region 2 shown above. The valid temperature range is
<i>0 C &le; T &le; 800 C</i>, and the valid pressure range is <i>0 MPa &le; p &le; 100 MPa</i>.
</li>
<li>
When phase change is required, this model is to be used in combination with the
<a href=\"modelica://IBPSA.Media.Water\">IBPSA.Media.Water</a> media model for
incompressible liquid water for the liquid phase (quality = 0).
</li>
<li>
The two-phase region (e.g., mixed liquid and vapor), high temperature region, 
and liquid region are not included in this medium model.
</li>
</ul>
<h4>
Applications
</h4>
For numerical robustness, applications of this medium model assume the pressure, 
and hence the saturation pressure,is constant throughout the simulation. This 
is done to improve simulation performance by decoupling the pressure drop and 
energy balance calculations. 
<h4>
References
</h4>
<p>
W. Wagner et al., “The IAPWS industrial formulation 1997 for the thermodynamic 
properties of water and steam,” <i>J. Eng. Gas Turbines Power</i>, vol. 122, 
no. 1, pp. 150–180, 2000.
</p>
</html>", revisions="<html>
<ul>
<li>
May 6, 2020, by Kathryn Hinkelman:<br/>
First implementation.
</li>
</ul>
</html>"), Icon(graphics={
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

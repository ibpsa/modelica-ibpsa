within IBPSA.Media;
package Steam "Package with model for ideal steam"
  extends Modelica.Media.Water.IdealSteam(
     mediumName="steam",
     reference_T=273.15,
     reference_p=101325,
     AbsolutePressure(start=p_default),
     Temperature(start=T_default));

  extends Modelica.Icons.Package;

  redeclare record extends ThermodynamicState
    "ThermodynamicState record for ideal steam"
  end ThermodynamicState;

  redeclare model extends BaseProperties "Base properties"

  end BaseProperties;

  replaceable function setSat_p
    "Return saturation property record from pressure"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    output SaturationProperties sat "Saturation property record";
  algorithm
    sat.psat := p;
    sat.Tsat := saturationTemperature(p);
  end setSat_p;

  replaceable function saturationTemperature
    "Return saturation temperature from a given pressure"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    output Temperature T   "Saturation temperature";
  protected
    Real a[:] = {2.8002262E+02,1.4474213E+01,1.0074890E+00,1.1009133E-02,
      5.5240262E-03,5.5702047E-04}
      "Coefficients";
  algorithm
    T := a[1] + a[2]*log(p/1000) + a[3]*log(p/1000)^2 + a[4]*log(p/1000)^3 +
      a[5]*log(p/1000)^4 + a[6]*log(p/1000)^5  "Saturation temperature";
  end saturationTemperature;

  replaceable function densityOfSaturatedLiquid
    "Return density of saturated liquid"
    extends Modelica.Icons.Function;
    input SaturationProperties sat "Saturation property record";
    output Density dl "Density of saturated liquid";
  protected
    Real m[:] = {1/3,2/3,5/3,16/3,43/3,110/3} "Powers in equation (2)";
    Real b[:] = {1.99274064,1.09965342,-0.510839303,-1.75493479,-45.5170352,-6.74694450e5}
      "Coefficients in equation (2)";
    Real tau = 1 - sat.Tsat/Tcritical  "Temperature expression";
  algorithm
    dl := dcritical*(1 + b[1]*tau^m[1] + b[2]*tau^m[2] + b[3]*tau^m[3] +
      b[4]*tau^m[4] + b[5]*tau^m[5] + b[6]*tau^m[6])
      "Density of saturated liquid, equation (2)";
  annotation (
    smoothOrder=2,
    Documentation(info="<html>
    <p>
    Density of saturated liquid is computed from temperature in the region 
    of 273.16 to 647.096 K.
    </p>
    <p>
    Source: W Wagner, A Pruss: \"International equations for the saturation 
    properties of ordinary water substance. Revised according to the international 
    temperature scale of 1990\" (1993).
    </p>
  </html>"));
  end densityOfSaturatedLiquid;

  replaceable function densityOfSaturatedVapor
    "Return density of saturated vapor"
    extends Modelica.Icons.Function;
    input SaturationProperties sat "Saturation property record";
    output Density dv "Density of saturated vapor";
  protected
    Real m[:] = {2/6,4/6,8/6,18/6,37/6,71/6}  "Powers in equation (3)";
    Real c[:] = {-2.03150240,-2.68302940,-5.38626492,-17.2991605,-44.7586581,-63.9201063}
      "Coefficients in equation (3)";
    Real tau = 1 - sat.Tsat/Tcritical  "Temperature expression";
  algorithm
    dv := dcritical*exp(c[1]*tau^m[1] + c[2]*tau^m[2] + c[3]*tau^m[3] +
      c[4]*tau^m[4] + c[5]*tau^m[5] + c[6]*tau^m[6])
      "Density of saturated vapor, equation (3)";
  annotation (
    smoothOrder=2,
    Documentation(info="<html>
    <p>
    Density of saturated vapor is computed from temperature in the region 
    of 273.16 to 647.096 K.
    </p>
    <p>
    Source: W Wagner, A Pruss: \"International equations for the saturation 
    properties of ordinary water substance. Revised according to the international 
    temperature scale of 1990\" (1993).
    </p>
  </html>"));
  end densityOfSaturatedVapor;

  replaceable function enthalpyOfSaturatedLiquid
    "Return specific enthalpy of saturated liquid"
    extends Modelica.Icons.Function;
    input SaturationProperties sat "Saturation property record";
    output SpecificEnthalpy hl "Boiling curve specific enthalpy";
  protected
    Real tau = 1 - sat.Tsat/Tcritical "Temperature expression";
    Density dl = densityOfSaturatedLiquid(sat)  "Saturated liquid density";
    Real r1 = expression1(sat)  "Intermediate expression 1";
    Real r2 = expression2(sat)  "Intermediate expression 2";
    Real a = auxiliaryAlpha(sat)  "Value for alpha";
  algorithm
    hl := a - exp(r1)*pcritical*(r2+r1*tau)/(dl*tau)
      "Saturated liquid enthalpy, derived from equation (6)";
  annotation (
    smoothOrder=2,
    Documentation(info="<html>
    <p>
    Enthalpy of saturated liquid is computed from temperature in the region 
    of 273.16 to 647.096 K.
    </p>
    <p>
    Source: W Wagner, A Pruss: \"International equations for the saturation 
    properties of ordinary water substance. Revised according to the international 
    temperature scale of 1990\" (1993).
    </p>
  </html>"));
  end enthalpyOfSaturatedLiquid;

  replaceable function enthalpyOfSaturatedVapor
    "Return specific enthalpy of saturated vapor"
    extends Modelica.Icons.Function;
    input SaturationProperties sat "Saturation property record";
    output SpecificEnthalpy hv "Dew curve specific enthalpy";
  protected
    Real tau = 1 - sat.Tsat/Tcritical "Temperature expression";
    Density dv = densityOfSaturatedVapor(sat)  "Saturated vapor density";
    Real r1 = expression1(sat)  "Intermediate expression 1";
    Real r2 = expression2(sat)  "Intermediate expression 2";
    Real a = auxiliaryAlpha(sat)  "Value for alpha";
  algorithm
    hv := a - exp(r1)*pcritical*(r2+r1*tau)/(dv*tau)
      "Saturated vapor enthalpy, derived from equation (7)";
  annotation (
    smoothOrder=2,
    Documentation(info="<html>
    <p>
    Enthalpy of saturated vapor is computed from temperature in the region 
    of 273.16 to 647.096 K.
    </p>
    <p>
    Source: W Wagner, A Pruss: \"International equations for the saturation 
    properties of ordinary water substance. Revised according to the international 
    temperature scale of 1990\" (1993).
    </p>
  </html>"));
  end enthalpyOfSaturatedVapor;

  replaceable function enthalpyOfVaporization
    "Return enthalpy of vaporization of water as a function of temperature T, 
      273.16 to 647.096 K"
    extends Modelica.Icons.Function;
    input SaturationProperties sat "Saturation property record";
    output SpecificEnthalpy hlv "Vaporization enthalpy";
  protected
    SpecificEnthalpy hv = enthalpyOfSaturatedVapor(sat)  "Saturated vapor enthalpy";
    SpecificEnthalpy hl = enthalpyOfSaturatedLiquid(sat)  "Saturated liquid enthalpy";
  algorithm
    hlv := hv - hl  "Difference of equations (7) and (6)";
  annotation (
    smoothOrder=2,
    Documentation(info="<html>
    <p>
    Enthalpy of vaporization of water is computed from temperature in the region 
    of 273.16 to 647.096 K.
    </p>
    <p>
    Source: W Wagner, A Pruss: \"International equations for the saturation 
    properties of ordinary water substance. Revised according to the international 
    temperature scale of 1990\" (1993).
    </p>
  </html>"));
  end enthalpyOfVaporization;

  replaceable function entropyOfSaturatedLiquid
    "Return specific entropy of saturated liquid"
    extends Modelica.Icons.Function;
    input SaturationProperties sat "Saturation property record";
    output SpecificEntropy sl "Saturated liquid specific enthalpy";
  protected
    Real tau = 1 - sat.Tsat/Tcritical "Temperature expression";
    Density dl = densityOfSaturatedLiquid(sat)  "Saturated liquid density";
    Real r1 = expression1(sat)  "Intermediate expression 1";
    Real r2 = expression2(sat)  "Intermediate expression 2";
    Real phi = auxiliaryPhi(sat)  "Value for phi";
  algorithm
    sl := phi - exp(r1)*pcritical*(r2 + r1*tau)/(dl*tau*sat.Tsat)
      "Saturated liquid enthalpy, derived from Equation (8)";
  annotation (
    smoothOrder=2,
    Documentation(info="<html>
    <p>
    Entropy of saturated liquid is computed from temperature in the region 
    of 273.16 to 647.096 K.
    </p>
    <p>
    Source: W Wagner, A Pruss: \"International equations for the saturation 
    properties of ordinary water substance. Revised according to the international 
    temperature scale of 1990\" (1993).
    </p>
  </html>"));
  end entropyOfSaturatedLiquid;

  replaceable function entropyOfSaturatedVapor
    "Return specific entropy of saturated vapor"
    extends Modelica.Icons.Function;
    input SaturationProperties sat "Saturation property record";
    output SpecificEntropy sv "Saturated vapor specific enthalpy";
  protected
    Real tau = 1 - sat.Tsat/Tcritical "Temperature expression";
    Density dv = densityOfSaturatedVapor(sat)  "Saturated vapor density";
    Real r1 = expression1(sat)  "Intermediate expression 1";
    Real r2 = expression2(sat)  "Intermediate expression 2";
    Real phi = auxiliaryPhi(sat)  "Value for phi";
  algorithm
    sv := phi - exp(r1)*pcritical*(r2 + r1*tau)/(dv*tau*sat.Tsat)
      "Saturated vapor enthalpy, derived from Equation (9)";
  annotation (
    smoothOrder=2,
    Documentation(info="<html>
    <p>
    Entropy of saturated vapor is computed from temperature in the region 
    of 273.16 to 647.096 K.
    </p>
    <p>
    Source: W Wagner, A Pruss: \"International equations for the saturation 
    properties of ordinary water substance. Revised according to the international 
    temperature scale of 1990\" (1993).
    </p>
  </html>"));
  end entropyOfSaturatedVapor;

  replaceable function entropyOfVaporization
    "Return entropy of vaporization of water as a function of temperature T, 
      273.16 to 647.096 K"
    extends Modelica.Icons.Function;
    input SaturationProperties sat "Saturation property record";
    output SpecificEntropy slv "Vaporization enthalpy";
  protected
    SpecificEntropy sv = entropyOfSaturatedVapor(sat)  "Saturated vapor entropy";
    SpecificEntropy sl = entropyOfSaturatedLiquid(sat)  "Saturated liquid entropy";
  algorithm
    slv := sv - sl  "Difference of equations (8) and (9)";
  annotation (
    smoothOrder=2,
    Documentation(info="<html>
    <p>
    Entropy of vaporization of water is computed from temperature in the region 
    of 273.16 to 647.096 K.
    </p>
    <p>
    Source: W Wagner, A Pruss: \"International equations for the saturation 
    properties of ordinary water substance. Revised according to the international 
    temperature scale of 1990\" (1993).
    </p>
  </html>"));
  end entropyOfVaporization;


//////////////////////////////////////////////////////////////////////
// Protected classes.
// These classes are only of use within this medium model.
// Models generally have no need to access them.
// Therefore, they are made protected. This also allows to redeclare the
// medium model with another medium model that does not provide an
// implementation of these classes.

protected
    constant Real Tcritical=647.096 "Critical temperature (K)";
    constant Real dcritical=322 "Critical density (kg/m^3)";
    constant Real pcritical=22.064e6 "Critical pressure (Pa)";
    constant Real a0 = 1000 "Auxiliary quantity for specific enthalpy (J/kg)";

  replaceable function vaporPressure
    "Returns vapor pressure for a given temperature"
    extends Modelica.Icons.Function;
    input SaturationProperties sat "Saturation property record";
    output AbsolutePressure p  "Vapor pressure";
  protected
    Real n[:] = {1,1.5,3,3.5,4,7.5} "Powers in equation (1)";
    Real a[:] = {-7.85951783,1.84408259,-11.7866497,22.6807411,-15.9618719,
        1.80122502} "Coefficients in equation (1) of [1]";
    Real tau = 1 - sat.Tsat/Tcritical "Temperature expression";
  algorithm
    p := pcritical*exp(Tcritical/sat.Tsat*(a[1]*tau^n[1] + a[2]*tau^n[2] + a[3]
        *tau^n[3] + a[4]*tau^n[4]) + a[5]*tau^n[5] + a[6]*tau^n[6])
        "Equation (1) for vapor pressure";
  annotation (
    smoothOrder=2,
    Documentation(info="<html>
    <p>
    Vapor pressure is computed from temperature in the region 
    of 273.16 to 647.096 K.
    </p>
    <p>
    Source: W Wagner, A Pruss: \"International equations for the saturation 
    properties of ordinary water substance. Revised according to the international 
    temperature scale of 1990\" (1993).
    </p>
  </html>"));
  end vaporPressure;

  function auxiliaryAlpha
    "This is auxiliary equation (4) for specific enthalpy calculations"
    extends Modelica.Icons.Function;
    input SaturationProperties sat "Saturation property record";
    output Real a  "Alpha in equation (4)";
  protected
    Real m[:] = {-19,1,4.5,5,54.5}  "Powers in equation (4)";
    Real d_a = -1135.905627715  "Coefficient in equation (4)";
    Real d[:] = {-5.65134998e-8,2690.66631,127.287297,-135.003439,0.981825814}
      "Coefficients in equation (4) and (5)";
    Real theta = sat.Tsat / Tcritical  "Temperature ratio";
  algorithm
    a := a0*(d_a + d[1]*theta^m[1] + d[2]*theta^m[2] + d[3]*theta^m[3] +
      d[4]*theta^m[4] + d[5]*theta^m[5])  "Equation (4)";
  annotation (
    smoothOrder=2,
    Documentation(info="<html>
    <p>
    Auxiliary equation for alpha, equation (4).
    </p>
    <p>
    Source: W Wagner, A Pruss: \"International equations for the saturation 
    properties of ordinary water substance. Revised according to the international 
    temperature scale of 1990\" (1993).
    </p>
  </html>"));
  end auxiliaryAlpha;

  function auxiliaryPhi
    "This is auxiliary equation (5) for specific entropy calculations"
    extends Modelica.Icons.Function;
    input SaturationProperties sat "Saturation property record";
    output Real phi  "Phi in equation (5)";
  protected
    Real m[:] = {-20,0,3.5,4,53.5}  "Powers in equation (5)";
    Real d_phi = 2319.5246  "Coefficient in equation (5)";
    Real d[:] = {-5.65134998e-8,2690.66631,127.287297,-135.003439,0.981825814}
      "Coefficients in equation (4) and (5)";
    Real a[:] = {19/20,1,9/7,5/4,109/107}  "Additional coefficients in (5)";
    Real phi0 = a0 / Tcritical  "Given reference constant";
    Real theta = sat.Tsat / Tcritical  "Temperature ratio";
  algorithm
    phi := phi0*(d_phi + a[1]*d[1]*theta^m[1] + a[2]*d[2]*log(theta) +
      a[3]*d[3]*theta^m[3] + a[4]*d[4]*theta^m[4] + a[5]*d[5]*theta^m[5])
      "Equation (5)";
  annotation (
    smoothOrder=2,
    Documentation(info="<html>
    <p>
    Auxiliary equation for phi, equation (5).
    </p>
    <p>
    Source: W Wagner, A Pruss: \"International equations for the saturation 
    properties of ordinary water substance. Revised according to the international 
    temperature scale of 1990\" (1993).
    </p>
  </html>"));
  end auxiliaryPhi;

  function expression1
    "This expression represents ln(p/pcritical), which is used in the saturated
      enthalpy and entropy functions above"
    extends Modelica.Icons.Function;
    input SaturationProperties sat "Saturation property record";
    output Real r1  "Expression 1";
  protected
    Real n[:] = {1,1.5,3,3.5,4,7.5} "Powers in equation (1)";
    Real a[:] = {-7.85951783,1.84408259,-11.7866497,22.6807411,-15.9618719,
        1.80122502} "Coefficients in equation (1) of [1]";
    Real tau = 1 - sat.Tsat/Tcritical "Temperature expression";
  algorithm
    r1 := (a[1]*Tcritical*tau^n[1])/sat.Tsat + (a[2]*Tcritical*tau^n[2])/sat.Tsat
       + (a[3]*Tcritical*tau^n[3])/sat.Tsat + (a[4]*Tcritical*tau^n[4])/sat.Tsat
       + (a[5]*Tcritical*tau^n[5])/sat.Tsat + (a[6]*Tcritical*tau^n[6])/sat.Tsat
       "Expression 1";
  annotation (
    smoothOrder=2,
    Documentation(info="<html>
    <p>
    Intermediate expression developed based on the work by Wagner & Pruss (1993), 
    which is used in calculating various saturation state properties, including
    enthalpy and entropy.
    </p>
    <p>
    Source: W Wagner, A Pruss: \"International equations for the saturation 
    properties of ordinary water substance. Revised according to the international 
    temperature scale of 1990\" (1993).
    </p>
  </html>"));
  end expression1;

  function expression2
    "This expression is used in the saturated enthalpy and entropy functions 
      above, which was formulated via evaluating the derivative dP/dT"
    extends Modelica.Icons.Function;
    input SaturationProperties sat "Saturation property record";
    output Real r2  "Expression 2";
  protected
    Real n[:] = {1,1.5,3,3.5,4,7.5} "Powers in equation (1)";
    Real a[:] = {-7.85951783,1.84408259,-11.7866497,22.6807411,-15.9618719,
        1.80122502} "Coefficients in equation (1) of [1]";
    Real tau = 1 - sat.Tsat/Tcritical "Temperature expression";
  algorithm
    r2 := a[1]*n[1]*tau^n[1] + a[2]*n[2]*tau^n[2] + a[3]*n[3]*tau^n[3] +
      a[4]*n[4]*tau^n[4] + a[5]*n[5]*tau^n[5] + a[6]*n[6]*tau^n[6]
      "Expression 2";
  annotation (
    smoothOrder=2,
    Documentation(info="<html>
    <p>
    Intermediate expression developed based on the work by Wagner & Pruss (1993), 
    which is used in calculating various saturation state properties, including
    enthalpy and entropy.
    </p>
    <p>
    Source: W Wagner, A Pruss: \"International equations for the saturation 
    properties of ordinary water substance. Revised according to the international 
    temperature scale of 1990\" (1993).
    </p>
  </html>"));
  end expression2;
annotation (Documentation(info="<html>
<p>
The steam model can be utilized for steam systems and components that use the 
vapor phase of water (quality = 1).  
</p>
<p>
States are formulated from the NASA Glenn coefficients for ideal gas \"H2O\". 
Independent variables are temperature <b>T</b> and pressure <b>p</b>. Only 
density is a function of T and p. All other quantities are solely a function 
of T. 
</p>
<p align=\"center\">
<img src=\"modelica://Modelica/Resources/Images/Media/IdealGases/SingleGases/H2O.png\"
alt=\"Specific heat of ideal steam\"/>
</p>
<h4> 
Limitations
</h4>
<p>
<ul>
<li>
The properties are valid in the range: <i>200 K &le; T &le; 6000 K</i>, with the
exception of saturated state properties, which are valid in the range: 
<i>273.16 K &le; T &le; 647.096 K</i>
</li>
<li>
When phase change is required, this model is to be used in combination with the
<a href=\"modelica://IBPSA.Media.Water\">IBPSA.Media.Water</a> media model for 
incompressible liquid water for the liquid phase (quality = 0).
</li>
<li>
The two-phase region (e.g., mixed liquid and vapor) is not included.
</li>
<li>
This model assumes the pressure/saturation pressure is steady throughout 
simulation. This is done to improve simulation performance by decoupling 
the pressure drop and energy balance calculations. Thus, a function for 
calculating saturation pressure is not provided.
</li>
</p>
<h4>
References
</h4>
<p>
S. Gordon and B. J. McBride, \"Computer Program for Calculation of Complex 
Chemical Equilibrium Compositions and Applications: I. Analysis,\" NASA Technical 
Reports, NASA-RP-1311, Cleveland, OH, 1994. Available: 
<a href=\"https://ntrs.nasa.gov/archive/nasa/casi.ntrs.nasa.gov/19950013764.pdf\">
https://ntrs.nasa.gov/archive/nasa/casi.ntrs.nasa.gov/19950013764.pdf</a>.
</p>
<p>
W. Wagner and A. Pruss, \"International Equations for the Saturation Properties of 
Ordinary Water Substance. Revised According to the International Temperature Scale 
of 1990. Addendum to J. Phys. Chem. Ref. Data 16, 893 (1987),\" <i>J. Phys. Chem. 
Ref. Data</i>, vol. 22, no. 3, pp. 783-787, 1993. doi: 
<a href=\"https://doi.org/10.1063/1.555926\">10.1063/1.555926</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
March 6, 2020, by Kathryn Hinkelman:<br/>
First implementation.
</li>
</ul>
</html>"), Icon(graphics={
      Line(
        points={{-30,30},{-50,10},{-30,-10},{-50,-30}},
        color={0,0,0},
        smooth=Smooth.Bezier),
      Line(
        points={{10,30},{-10,10},{10,-10},{-10,-30}},
        color={0,0,0},
        smooth=Smooth.Bezier),
      Line(
        points={{50,30},{30,10},{50,-10},{30,-30}},
        color={0,0,0},
        smooth=Smooth.Bezier)}));
end Steam;

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
    output Temperature T "Saturation temperature";
  protected
    Real pr = p/pcritical  "Reduced pressure";
    Real a[:]={9.37817e-3,4.98951e-4,1.11049e-5,3.34995e-7,3.44102e-8}
      "Coefficients in equation (2)";
  algorithm
    T := exp(a[1]+a[2]*pr+a[3]*pr^2+a[4]*pr^3+a[5]*pr^4)^(-0.4);
  annotation (
    smoothOrder=2,
    Documentation(info="<html>
<p>Saturation temperature for a given pressure is valid in the range of of 273.16 to 643.15 K. </p>
<p>Source: Affandi, M., Mamat, N., Kanafiah, S. N. A. M., &amp; Khalid, N. S. (2013). &quot;Simplified equations for saturated steam properties for simulation purpose&quot;. <i>Procedia Engineering</i>, 53. Malaysian Technical Universities Conference on Engineering &amp; Technology 2012, 722&ndash;726. </p>
</html>"));
  end saturationTemperature;

  replaceable function densityOfSaturatedLiquid
    "Return density of saturated liquid"
    extends Modelica.Icons.Function;
    input SaturationProperties sat "Saturation property record";
    output Density dl "Density of saturated liquid";
  protected
    Real m[:]={1/3,2/3,5/3,16/3,43/3,110/3} "Powers in equation (2)";
    Real b[:]={1.99274064,1.09965342,-0.510839303,-1.75493479,-45.5170352,-6.74694450e5}
      "Coefficients in equation (2)";
    Real tau=1 - sat.Tsat/Tcritical "Temperature expression";
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
    Real m[:]={2/6,4/6,8/6,18/6,37/6,71/6}  "Powers in equation (3)";
    Real c[:]={-2.03150240,-2.68302940,-5.38626492,-17.2991605,-44.7586581,-63.9201063}
      "Coefficients in equation (3)";
    Real tau=1 - sat.Tsat/Tcritical "Temperature expression";
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
    SpecificEnthalpy hv "Dew curve specific enthalpy";
    SpecificEnthalpy hlv "Enthalpy of vaporization";
  algorithm
    hv := enthalpyOfSaturatedVapor(sat);
    hlv := enthalpyOfVaporization(sat.Tsat);
    hl :=hv - hlv;
  end enthalpyOfSaturatedLiquid;

  replaceable function enthalpyOfSaturatedVapor
    "Return specific enthalpy of saturated vapor"
    extends Modelica.Icons.Function;
    input SaturationProperties sat "Saturation property record";
    output SpecificEnthalpy hv "Dew curve specific enthalpy";
  end enthalpyOfSaturatedVapor;

  replaceable function enthalpyOfVaporization
    "Return enthalpy of vaporization of water as a function of temperature T, 
      273.16 to 647.096 K"
    extends Modelica.Icons.Function;
    input Temperature T "Temperature";
    output SpecificEnthalpy r0 "Vaporization enthalpy";
    //    Real Tcritical=647.096 "Critical temperature";
    //    Real dcritical=322 "Critical density";
    //    Real pcritical=22.064e6 "Critical pressure";
  protected
    Real n[:]={1,1.5,3,3.5,4,7.5} "Powers in equation (1)";
    Real a[:]={-7.85951783,1.84408259,-11.7866497,22.6807411,-15.9618719,
        1.80122502} "Coefficients in equation (1) of [1]";
    Real m[:]={1/3,2/3,5/3,16/3,43/3,110/3} "Powers in equation (2)";
    Real b[:]={1.99274064,1.09965342,-0.510839303,-1.75493479,-45.5170352,-6.74694450e5}
      "Coefficients in equation (2) of [1]";
    Real o[:]={2/6,4/6,8/6,18/6,37/6,71/6} "Powers in equation (3)";
    Real c[:]={-2.03150240,-2.68302940,-5.38626492,-17.2991605,-44.7586581,-63.9201063}
      "Coefficients in equation (3) of [1]";
    Real tau=1 - T/Tcritical "Temperature expression";
    Real r1=(a[1]*Tcritical*tau^n[1])/T + (a[2]*Tcritical*tau^n[2])/T + (a[3]
        *Tcritical*tau^n[3])/T + (a[4]*Tcritical*tau^n[4])/T + (a[5]*
        Tcritical*tau^n[5])/T + (a[6]*Tcritical*tau^n[6])/T "Expression 1";
    Real r2=a[1]*n[1]*tau^n[1] + a[2]*n[2]*tau^n[2] + a[3]*n[3]*tau^n[3] + a[
        4]*n[4]*tau^n[4] + a[5]*n[5]*tau^n[5] + a[6]*n[6]*tau^n[6]
      "Expression 2";
    Real dp=dcritical*(1 + b[1]*tau^m[1] + b[2]*tau^m[2] + b[3]*tau^m[3] + b[
        4]*tau^m[4] + b[5]*tau^m[5] + b[6]*tau^m[6])
      "Density of saturated liquid";
    Real dpp=dcritical*exp(c[1]*tau^o[1] + c[2]*tau^o[2] + c[3]*tau^o[3] + c[
        4]*tau^o[4] + c[5]*tau^o[5] + c[6]*tau^o[6])
      "Density of saturated vapor";
  algorithm
    r0 := -(((dp - dpp)*exp(r1)*pcritical*(r2 + r1*tau))/(dp*dpp*tau))
      "Difference of equations (7) and (6)";
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
  end entropyOfSaturatedLiquid;

  replaceable function entropyOfSaturatedVapor
    "Return specific entropy of saturated vapor"
    extends Modelica.Icons.Function;
    input SaturationProperties sat "Saturation property record";
    output SpecificEntropy sv "Saturated vapor specific enthalpy";
  end entropyOfSaturatedVapor;
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
    input Temperature T  "Temperature";
    output AbsolutePressure p  "Vapor pressure";
  protected
    Real n[:]={1,1.5,3,3.5,4,7.5} "Powers in equation (1)";
    Real a[:]={-7.85951783,1.84408259,-11.7866497,22.6807411,-15.9618719,
        1.80122502} "Coefficients in equation (1) of [1]";
    Real tau=1 - T/Tcritical "Temperature expression";
  algorithm
    p := pcritical*exp(Tcritical/T*(a[1]*tau^n[1] + a[2]*tau^n[2] + a[3]
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
Limitation
</h4>
<p>
<ul>
<li>
The properties are valid in the range: <i>200 K &le; T &le; 6000 K</i>
</li>
<li>
When phase change is required, this model is to be used in combination with the
<a href=\"modelica://IBPSA.Media.Water\">IBPSA.Media.Water</a> media model for 
incompressible liquid water for the liquid phase (quality = 0).
</li>
<li>
The two-phase region (e.g., mixed liquid and vapor) is not included.
</li>
</p>
<h4>
Reference
</h4>
<p>
Computer program for calculation of complex chemical equilibrium compositions 
and applications. Part 1: Analysis Document ID: 19950013764 N (95N20180) File 
Series: NASA Technical Reports Report Number: NASA-RP-1311 E-8017 NAS 1.61:1311 
Authors: Gordon, Sanford (NASA Lewis Research Center) Mcbride, Bonnie J. 
(NASA Lewis Research Center) Published: Oct 01, 1994.
</p>
</html>", revisions="<html>
<ul>
<li>
January 16, 2020, by Kathryn Hinkelman:<br/>
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

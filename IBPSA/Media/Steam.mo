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

function enthalpyOfVaporization_default
  "Return vaporization enthalpy of condensing fluid at default state"
  extends Modelica.Icons.Function;
  input Temperature T "Temperature";
  output SpecificEnthalpy r0 "Vaporization enthalpy";
algorithm
  r0 := h_fg;
end enthalpyOfVaporization_default;

function enthalpyOfVaporization_T
  "Return enthalpy of vaporization of water as a function of temperature T, 
    273.16 to 647.096 K"
  extends Modelica.Icons.Function;
  input Temperature T "Temperature";
  output SpecificEnthalpy r0 "Vaporization enthalpy";
  protected
  Real Tcritical=647.096 "Critical temperature";
  Real dcritical=322 "Critical density";
  Real pcritical=22.064e6 "Critical pressure";
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
<p>Enthalpy of vaporization of water is computed from temperature in the region of 273.16 to 647.096 K.</p>
<p>Source: W Wagner, A Pruss: \"International equations for the saturation properties of ordinary water substance. Revised according to the international temperature scale of 1990\" (1993).</p>
</html>"));
end enthalpyOfVaporization_T;

function enthalpySteam
    "Enthalpy of steam"
  extends Modelica.Icons.Function;
  input Temperature T "temperature";
//  input ThermodynamicState state "Thermodynamic state";
  output SpecificEnthalpy h "steam enthalpy";
algorithm
  h := (T-reference_T) * cp + h_fg;
  annotation(smoothOrder=5,
  Inline=true,
  derivative=der_enthalpySteam);
end enthalpySteam;
protected
  constant Modelica.SIunits.SpecificHeatCapacity cp=
    IBPSA.Utilities.Psychrometrics.Constants.cpSte
    "Specific heat capacity at constant pressure";
//  constant Modelica.SIunits.SpecificHeatCapacity cp=
//    specificHeatCapacityCp(state)
//    "Specific heat at constant pressure";

  constant Modelica.SIunits.SpecificEnergy h_fg=
    IBPSA.Utilities.Psychrometrics.Constants.h_fg
    "Default latent heat of evaporation of water";
//  constant Modelica.SIunits.SpecificEnergy h_f=
//    specificEnthalpy(state0)
//    "Enthalpy of fusion";
//  constant Modelica.SIunits.SpecificEnergy h_g=
//    specificEnthalpy(state1)
//    "Enthalpy of evaporation";
//  constant Modelica.SIunits.SpecificEnergy h_fg=h_g - h_f
//    "Latent heat of vaporization";
//  constant ThermodynamicState state "Thermodynamic state of steam";
//  constant ThermodynamicState state0=setState_pTX(p,T,X=0)
//    "Thermodynamic state of steam at current pressure and quality x=0";
//  constant ThermodynamicState state1
//    "Thermodynamic state of steam at current pressure and quality x=1";

//  constant Temperature T(start=T_default) "Temperature";

replaceable function der_enthalpySteam
    "Derivative of enthalpy of steam"
  extends Modelica.Icons.Function;
  input Temperature T "temperature";
  input Real der_T "temperature derivative";
  output Real der_h "derivative of steam enthalpy";
algorithm
  der_h := cp*der_T;
  annotation(Inline=true);
end der_enthalpySteam;
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
Limitation [UPDATE!!!!!!!!!!!!!!!!]
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
<li>
This model uses standard physical equations to calculate enthalpy from temperature for different regions, 
and use backward equations to calculate temperature from enthalpy to avoid iterations.
The numerical differences between basic equations and backward equations in terms of temperature is shown in the following figure.
</li>
<li>
The steam model has discontious properties when changing from liquid phase to vapor phase. Details can be observed in 
<a href=\"modelica://IBPSA.Media.Examples.SteamProperties\">IBPSA.Media.Examples.SteamProperties</a>.
</li>
</ul>
</p>
<p align=\"center\">
<img src=\"modelica://IBPSA/Resources/Images/Media/Steam/numericalError.png\"  
alt=\"Numerical errors of temperature between basic equations and backward equations\"/>
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

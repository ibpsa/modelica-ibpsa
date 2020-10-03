within IBPSA.Media;
package Steam2  "Package with model for region 2 (steam) water according to IF97 standard"
  extends Modelica.Media.Interfaces.PartialCondensingGases(
     mediumName="steam",
     final substanceNames={"water"},
     final singleState = false,
     final fluidConstants = Modelica.Media.IdealGases.Common.FluidData.H2O,
     reference_T=273.15,
     reference_p=101325,
     AbsolutePressure(start=p_default),
     Temperature(start=T_default),
     SpecificEnthalpy(start=1.0e5, nominal=5.0e5),
     Density(start=150, nominal=500),
     T_default=Modelica.SIunits.Conversions.from_degC(100));
  extends Modelica.Icons.Package;

  redeclare record extends ThermodynamicState "Thermodynamic state"
    //    SpecificEnthalpy h "Specific enthalpy";
    //    Density d "Density";
    //    Temperature T "Temperature";
    //    AbsolutePressure p "Pressure";
  end ThermodynamicState;

  redeclare replaceable model extends BaseProperties(
    T(stateSelect=if preferredMediumStates then StateSelect.prefer
           else StateSelect.default),
    p(stateSelect=if preferredMediumStates then StateSelect.prefer
           else StateSelect.default))
    "Base properties (p, d, T, h, u, R, MM, sat) of water"
  SaturationProperties sat "Saturation properties at the medium pressure";
  equation
    // Temperature and pressure values must be within acceptable max & min bounds
    // Assert statements
    MM = fluidConstants[1].molarMass;
    h = specificEnthalpy(state);
    d = density(state);
    u = h - p/d;
    R = Modelica.Constants.R/fluidConstants[1].molarMass;
    p = state.p;
    T = state.T;
  end BaseProperties;

   redeclare replaceable function saturationPressure
    "Return saturation pressure of condensing fluid"
    //    input Temperature Tsat "Saturation temperature";
    //    output AbsolutePressure psat "Saturation pressure";
   algorithm

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
      a[5]*logP^4 + a[6]*logP^5  "Saturation temperature";
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
/*
  redeclare replaceable function enthalpyOfVaporization
    "Return vaporization enthalpy of condensing fluid"
    //    input Temperature T "Temperature";
    //    output SpecificEnthalpy r0 "Vaporization enthalpy";
  algorithm 

  end enthalpyOfVaporization;

  redeclare replaceable function enthalpyOfLiquid
    "Return liquid enthalpy of condensing fluid"
    //    input Temperature T "Temperature";
    //    output SpecificEnthalpy h "Liquid enthalpy";
  algorithm 

  end enthalpyOfLiquid;

  redeclare replaceable function enthalpyOfGas
    "Return enthalpy of non-condensing gas mixture"
    //    input Temperature T "Temperature";
    //    input MassFraction[:] X "Vector of mass fractions";
    //    output SpecificEnthalpy h "Specific enthalpy";
  algorithm 
   

end enthalpyOfGas;
 */

end Steam2;

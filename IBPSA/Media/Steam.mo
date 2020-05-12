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

  constant FluidConstants[1] fluidConstants=
     Modelica.Media.Water.waterConstants
     "Constant data for water";

  redeclare record extends ThermodynamicState "Thermodynamic state"
    SpecificEnthalpy h "Specific enthalpy";
    Density d "Density";
    Temperature T "Temperature";
    AbsolutePressure p "Pressure";
  end ThermodynamicState;
  constant Integer Region = 2 "Region of IF97, if known, zero otherwise";
  constant Integer phase = 1 "1 for one-phase";

  redeclare replaceable partial model extends BaseProperties
    "Base properties (p, d, T, h, u, R, MM, sat) of water"
    SaturationProperties sat "Saturation properties at the medium pressure";

  equation
    MM = fluidConstants[1].molarMass;
    h = specificEnthalpy_pT(
          p,
          T,
          Region);
    d = density_pT(
          p,
          T,
          Region);
    sat.psat = p;
    sat.Tsat = saturationTemperature(p);
    u = h - p/d;
    R = Modelica.Constants.R/fluidConstants[1].molarMass;
    h = state.h;
    p = state.p;
    T = state.T;
    d = state.d;
    phase = phase;
  end BaseProperties;
/*  replaceable function saturationState_p
    "Return saturation property record from pressure"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    output SaturationProperties sat "Saturation property record";
  algorithm 
    sat.psat := p;
    sat.Tsat := saturationTemperature(p);
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
*/

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
</html>"));
end Steam;

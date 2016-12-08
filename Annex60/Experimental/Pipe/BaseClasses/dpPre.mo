within Annex60.Experimental.Pipe.BaseClasses;
function dPpre
  "Calculate dp assuming turbulent flow based on a specific temperature, nominal mass flow rate and diameter"
package Medium =
      Annex60.Media.Specialized.Water.TemperatureDependentDensity;

  input Modelica.SIunits.Length length "Length";
  input Modelica.SIunits.Diameter d "Diameter";
  input Modelica.SIunits.MassFlowRate m_flow "Nominal mass flow rate";
  input Modelica.SIunits.Temperature T_nominal "Nominal Temperature";
  input Modelica.SIunits.Pressure p_nominal = 200000
    "Nominal static gauge pressure";
  output Modelica.SIunits.Pressure dp "Pressure loss along the pipe";

  final parameter Modelica.SIunits.Pressure p_nom_abs = 101325+p_nominal
    "Convert to absolute pressure";

protected
  Modelica.SIunits.DynamicViscosity eta
    "Dynamic viscosity at nominal conditions";
  Modelica.SIunits.Density rho "Density at nominal conditions";
  Modelica.SIunits.ReynoldsNumber Re "Reynolds number";
  Modelica.SIunits.Velocity v "Fluid velocity";
  Modelica.SIunits.Area A_cross "Cross sectional area";
  Modelica.SIunits.CoefficientOfFriction f "Friction factor";
  Real e = 2.5e-5 "Roughness";

algorithm
  eta :=Medium.dynamicViscosity(Medium.setState_pTX(
    p_nom_abs,
    T_nominal,
    {1}));
  rho :=Medium.density(Medium.setState_pTX(
    p_nom_abs,
    T_nominal,
    {1}));
  A_cross := Modelica.Constants.pi*(d/2)^2;
  (Re,v) := Modelica.Fluid.Dissipation.Utilities.Functions.General.ReynoldsNumber(A_cross,Modelica.Constants.pi*d,rho,eta,m_flow);
  f := 0.25/(log10((e/(3.7*d))+(5.74/(Re^0.9))))^2;
  dp := f*(length/d)*rho*v*v/2;

  annotation (Documentation(info="<html>
<p>
The function <code>dpPre</code> is used to precalculate the nominal pressure drop along the pipe based on the 
pipe dimensions (length  <code>length</code>,diameter  <code>d</code> and roughness <code>e=2.5e-5</code>) 
and nominal conditions (temperature and mass flow rate). 
</p>
<p>
The functions calculate the water properties (density <code>rho</code> and dynamic viscosity <code>eta</code>) at the given temperature <code>T_nominal</code>and uses then the Swamee-Jain equation as approximation of the 
Coolebrook equation to calculate the Darcy friction factor <code>f</code>.
</p>
<p>
Pressure drop is finally calculated with the following equation:
</p>
dp = f &sdot; (length/2d) &sdot; rho &sdot; v<sup>2</sup>

<p>
</p>
</html>"));
end dPpre;

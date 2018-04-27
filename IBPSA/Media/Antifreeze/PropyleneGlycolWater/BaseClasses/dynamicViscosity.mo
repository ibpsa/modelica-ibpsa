within IBPSA.Media.Antifreeze.PropyleneGlycolWater.BaseClasses;
function dynamicViscosity
  "Evaluate dynamic viscosity of propylene glycol - water"
  extends Modelica.Icons.Function;

  input Modelica.SIunits.MassFraction w "Mass fraction of propylene glycol";
  input Modelica.SIunits.Temperature T "Temperature of propylene glycol - water";

  output Modelica.SIunits.DynamicViscosity eta "Dynamic Viscosity of propylene glycol - water";

protected
  Modelica.SIunits.MassFraction wm=30.7031 "Reference mass fraction";
  Modelica.SIunits.Temperature Tm=32.7089 "Reference temperature";
  Integer nw=6 "Order of polynomial in x";
  Integer nT[nw]={4,4,4,3,2,1} "Order of polynomial in y";
  Real coeff[18]={6.837e-1, -3.045e-2, 2.525e-4, -1.399e-6, 3.328e-2, -3.984e-4, 4.332e-6, -1.860e-8, 5.453e-5, -8.600e-8, -1.593e-8, -4.465e-11, -3.900e-6, 1.054e-7, -1.589e-9, -1.587e-8, 4.475e-10, 3.564e-9}
    "Polynomial coefficients";

algorithm

  eta := 1e-3*exp(IBPSA.Media.Antifreeze.BaseClasses.polynomialProperty(
    w*100,
    Modelica.SIunits.Conversions.to_degC(T),
    wm,
    Tm,
    nw,
    nT,
    coeff));
annotation (
Documentation(info="<html>
<p>
Dynamic viscosity of propylene glycol - water at specified mass fraction and
temperature, based on Melinder (2010).
</p>
<h4>References</h4>
<p>
Melinder, &#197;ke. 2010. Properties of Secondary Working Fluids (Secondary
Refrigerants or Coolants, Heat Transfer Fluids) for Indirect Systems. Paris:
IIR/IIF.
</p>
</html>", revisions="<html>
<ul>
<li>
March 16, 2018 by Massimo Cimmino:<br/>
First implementation.
This function is used by
<a href=\"modelica://IBPSA.Media.Antifreeze.PropyleneGlycolWater\">
IBPSA.Media.Antifreeze.PropyleneGlycolWater</a>.
</li>
</ul>
</html>"));
end dynamicViscosity;

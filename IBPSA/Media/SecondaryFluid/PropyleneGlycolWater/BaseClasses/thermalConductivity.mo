within IBPSA.Media.SecondaryFluid.PropyleneGlycolWater.BaseClasses;
function thermalConductivity
  "Evaluate thermal conductivity of propylene glycol - water"
  extends Modelica.Icons.Function;

  input Modelica.SIunits.MassFraction w "Mass fraction of propylene glycol";
  input Modelica.SIunits.Temperature T "Temperature of propylene glycol - water";

  output Modelica.SIunits.ThermalConductivity lambda "Thermal conductivity of propylene glycol - water";

protected
  Modelica.SIunits.MassFraction wm=30.7031 "Reference mass fraction";
  Modelica.SIunits.Temperature Tm=32.7089 "Reference temperature";
  Integer nw=6 "Order of polynomial in x";
  Integer nT[nw]={4,4,4,3,2,1} "Order of polynomial in y";
  Real coeff[18]={4.513e-1, 7.955e-4, 3.482e-8, -5.966e-9, -4.795e-3, -1.678e-5, 8.941e-8, 1.493e-10, 2.076e-5, 1.563e-7, -4.615e-9, 9.897e-12, -9.083e-8, -2.518e-9, 6.543e-11, -5.952e-10, -3.605e-11, 2.104e-11}
    "Polynomial coefficients";

algorithm

  lambda := IBPSA.Media.SecondaryFluid.BaseClasses.polynomialProperty(
    w*100,
    Modelica.SIunits.Conversions.to_degC(T),
    wm,
    Tm,
    nw,
    nT,
    coeff);
annotation (
Documentation(info="<html>
<p>
Thermal conductivity of propylene glycol - water at specified mass fraction and
temperature, based on Melinder (2010).
</p>
<h4>References</h4>
<p>
Melinder, Åke. 2010. Properties of Secondary Working Fluids (Secondary
Refrigerants or Coolants, Heat Transfer Fluids) for Indirect Systems. Paris:
IIR/IIF.
</p>
</html>", revisions="<html>
<ul>
<li>
March 16, 2018 by Massimo Cimmino:<br/>
First implementation.
This function is used by
<a href=\"modelica://IBPSA.Media.SecondaryFluid.PropyleneGlycolWater\">
IBPSA.Media.SecondaryFluid.PropyleneGlycolWater</a>.
</li>
</ul>
</html>"));
end thermalConductivity;

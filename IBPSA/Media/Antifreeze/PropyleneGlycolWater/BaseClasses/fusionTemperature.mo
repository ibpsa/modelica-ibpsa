within IBPSA.Media.Antifreeze.PropyleneGlycolWater.BaseClasses;
function fusionTemperature
  "Evaluate temperature of fusion of propylene glycol - water"
  extends Modelica.Icons.Function;

  input Modelica.SIunits.MassFraction w "Mass fraction of propylene glycol";
  input Modelica.SIunits.Temperature T "Temperature of propylene glycol - water";

  output Modelica.SIunits.Temperature Tf "Temperature of fusion of propylene glycol - water";

protected
  Modelica.SIunits.MassFraction wm=30.7031 "Reference mass fraction";
  Modelica.SIunits.Temperature Tm=32.7089 "Reference temperature";
  Integer nw=6 "Order of polynomial in x";
  Integer nT[nw]={4,4,4,3,2,1} "Order of polynomial in y";
  Real coeff[18]={-1.325e1, -3.820e-5, 7.865e-7, -1.733e-9, -6.631e-1, 6.774e-6, -6.242e-8, -7.819e-10, -1.094e-2, 5.332e-8, -4.169e-9, 3.288e-11, -2.283e-4, -1.131e-8, 1.918e-10, -3.409e-6, 8.035e-11, 1.465e-8}
    "Polynomial coefficients";

algorithm

  Tf := Modelica.SIunits.Conversions.from_degC(
    IBPSA.Media.Antifreeze.BaseClasses.polynomialProperty(
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
fusion temperature of propylene glycol - water at specified mass fraction and
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
<a href=\"modelica://IBPSA.Media.Antifreeze.PropyleneGlycolWater\">
IBPSA.Media.Antifreeze.PropyleneGlycolWater</a>.
</li>
</ul>
</html>"));
end fusionTemperature;

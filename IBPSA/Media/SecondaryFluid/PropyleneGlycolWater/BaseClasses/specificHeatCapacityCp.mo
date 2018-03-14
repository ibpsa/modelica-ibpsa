within IBPSA.Media.SecondaryFluid.PropyleneGlycolWater.BaseClasses;
function specificHeatCapacityCp
  "Evaluate specific heat capacity of propylene glycol - water"
  extends Modelica.Icons.Function;

  input Modelica.SIunits.MassFraction w "Mass fraction of propylene glycol";
  input Modelica.SIunits.Temperature T "Temperature of propylene glycol - water";

  output Modelica.SIunits.SpecificHeatCapacity cp "Specific heat capacity of propylene glycol - water";

protected
  Modelica.SIunits.MassFraction wm=30.7031 "Reference mass fraction";
  Modelica.SIunits.Temperature Tm=32.7089 "Reference temperature";
  Integer nw=6 "Order of polynomial in x";
  Integer nT[nw]={4,4,4,3,2,1} "Order of polynomial in y";
  Real coeff[18]={3.882e3, 2.699e0, -1.659e-3, -1.032e-5, -1.304e1, 5.070e-2, -4.752e-5, 1.522e-6, -1.598e-1, 9.534e-5, 1.167e-5, -4.870e-8, 3.539e-4, 3.102e-5, -2.950e-7, 5.000e-5, -7.135e-7, -4.959e-7}
    "Polynomial coefficients";

algorithm

  cp := IBPSA.Media.SecondaryFluid.BaseClasses.polynomialProperty(
    w*100,
    Modelica.SIunits.Conversions.to_degC(T),
    wm,
    Tm,
    nw,
    nT,
    coeff);

end specificHeatCapacityCp;

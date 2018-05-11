within IBPSA.Media.Antifreeze.BaseClasses.Validation;
model PolynomialProperty
  "Model that tests the implementation of function polynomialProperty"
  extends Modelica.Icons.Example;

  Modelica.SIunits.Temperature T "Temperature of antifreeze-water mixture";
  Modelica.SIunits.Density d "Density of antifreeze-water mixture";

protected
  parameter Modelica.SIunits.MassFraction w = 0.20 "Mass fraction of antifreeze";
  parameter Modelica.SIunits.MassFraction wm = 0.307031 "Reference mass fraction";
  parameter Modelica.SIunits.Temperature Tm = 273.15+32.7089 "Reference temperature";
  parameter Integer nw = 6 "Order of polynomial in x";
  parameter Integer nT[nw] = {4,4,4,3,2,1} "Order of polynomial in y";
  parameter Real coeff[18] = {1.018e3, -5.406e-1, -2.666e-3, 1.347e-5, 7.604e-1, -9.450e-3, 5.541e-5, -1.343e-7, -2.498e-3, 2.700e-5, -4.018e-7, 3.376e-9, -1.550e-4, 2.829e-6, -7.175e-9, -1.131e-6, -2.221e-8, 2.342e-8}
    "Polynomial coefficients";
  parameter Modelica.SIunits.Temperature T_min = 273.15
    "Minimum temperature of mixture";
  parameter Modelica.SIunits.Temperature T_max = 323.15
    "Maximum temperature of mixture";
  parameter Modelica.SIunits.Time dt = 1
    "Simulation length";
  parameter Real convT(unit="K/s") = (T_max-T_min)/dt
    "Rate of temperature change";

equation

  T = T_min + convT*time;
  d =
    IBPSA.Media.Antifreeze.BaseClasses.polynomialProperty(
    w*100,
    T,
    wm*100,
    Tm,
    nw,
    nT,
    coeff);

   annotation(experiment(Tolerance=1e-6, StopTime=1.0),
__Dymola_Commands(file="modelica://IBPSA/Resources/Scripts/Dymola/Media/Antifreeze/BaseClasses/Validation/PolynomialProperty.mos"
        "Simulate and plot"),
      Documentation(info="<html>
<p>
This example checks the implementation of function
<a href=\"modelica://IBPSA.Media.Antifreeze.BaseClasses.polynomialProperty\">IBPSA.Media.Antifreeze.BaseClasses.polynomialProperty</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
April 30, 2018, by Massimo Cimmino:
First implementation.
</li>
</ul>
</html>"));
end PolynomialProperty;

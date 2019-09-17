within IBPSA.Media.Examples.BaseClasses;
partial model TestTemperatureEnthalpyInversionError
  "Model to check computation of h(T) and its inverse with a controlleable tolerance"
   replaceable package Medium =
        Modelica.Media.Interfaces.PartialMedium;
     parameter Modelica.SIunits.Temperature T0=273.15+20 "Temperature";
     parameter Real tol = 1E-8 "Numerical tolerance";
     Modelica.SIunits.Temperature T "Temperature";
     Modelica.SIunits.SpecificEnthalpy h "Enthalpy";
     Medium.MassFraction Xi[:] = Medium.reference_X "Mass fraction";
     Real err;
equation
    h = Medium.specificEnthalpy_pTX(p=101325, T=T0, X=Xi);
    T = Medium.temperature_phX(p=101325, h=h,  X=Xi);
    err = T - T0;
    annotation (preferredView="info", Documentation(info="<html>
This model computes <code>h=f(T0)</code> and
<code>T=g(h)</code>. It then checks whether <code>T=T0</code>.
Hence, it checks whether the function <code>T_phX</code> is
implemented correctly.
</html>", revisions="<html>
<ul>
<li>
September 16, 2019 by Yangyang Fu:<br/>
Added a parameter <code>tol</code> to control numerical errors.
</li>
<li>
June 6, 2015 by Michael Wetter:<br/>
Changed <code>Medium</code> base class to avoid a translation error
in Dymola 2016 using pedantic mode.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/266\">#266</a>.
</li>
<li>
February 12, 2015 by Michael Wetter:<br/>
Replaced <code>h_pTX</code> with <code>specificEnthalpy_pTX</code>
and
<code>T_phX</code> with <code>temperature_phX</code>
as the old names are not present in all media.
</li>
<li>
January 21, 2010 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end TestTemperatureEnthalpyInversionError;

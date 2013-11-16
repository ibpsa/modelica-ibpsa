within Annex60.Media.GasesConstantDensity;
package MoistAir "Package with moist air model with constant density"
  extends Annex60.Media.GasesConstantDensity.MoistAirUnsaturated(
    mediumName="GasesConstantDensity.MoistAir");

  redeclare model BaseProperties "Base properties"

   InputAbsolutePressure p(
     stateSelect=if preferredMediumStates then StateSelect.prefer else StateSelect.default)
      "Absolute pressure of medium";
    InputMassFraction[nXi] Xi(start=reference_X[1:nXi],
     each stateSelect=if preferredMediumStates then StateSelect.prefer else StateSelect.default)
      "Structurally independent mass fractions";
    InputSpecificEnthalpy h "Specific enthalpy of medium";
    Density d "Density of medium";
    Temperature T(
     stateSelect=if preferredMediumStates then StateSelect.prefer else StateSelect.default)
      "Temperature of medium";
    MassFraction[nX] X(start=reference_X)
      "Mass fractions (= (component mass)/total mass  m_i/m)";
    SpecificInternalEnergy u "Specific internal energy of medium";
    SpecificHeatCapacity R "Gas constant (of mixture if applicable)";
    MolarMass MM "Molar mass (of mixture or single fluid)";
    ThermodynamicState state
      "Thermodynamic state record for optional functions";
    parameter Boolean preferredMediumStates=false
      "= true if StateSelect.prefer shall be used for the independent property variables of the medium"
      annotation (Evaluate=true, Dialog(tab="Advanced"));
    parameter Boolean standardOrderComponents=true
      "If true, and reducedX = true, the last element of X will be computed from the other ones";
    Modelica.SIunits.Conversions.NonSIunits.Temperature_degC T_degC=
        Modelica.SIunits.Conversions.to_degC(T)
      "Temperature of medium in [degC]";
    Modelica.SIunits.Conversions.NonSIunits.Pressure_bar p_bar=
        Modelica.SIunits.Conversions.to_bar(p)
      "Absolute pressure of medium in [bar]";

    // Local connector definition, used for equation balancing check
    connector InputAbsolutePressure = input Modelica.SIunits.AbsolutePressure
      "Pressure as input signal connector";
    connector InputSpecificEnthalpy = input Modelica.SIunits.SpecificEnthalpy
      "Specific enthalpy as input signal connector";
    connector InputMassFraction = input Modelica.SIunits.MassFraction
      "Mass fraction as input signal connector";

    MassFraction x_water "Mass of total water/mass of dry air";
    Real phi "Relative humidity";

  protected
    constant Modelica.SIunits.MolarMass[2] MMX = {steam.MM,dryair.MM}
      "Molar masses of components";

    Modelica.SIunits.MassFraction X_liquid "Mass fraction of liquid water";
    Modelica.SIunits.MassFraction X_steam "Mass fraction of steam water";
    Modelica.SIunits.MassFraction X_air "Mass fraction of air";
    Modelica.SIunits.MassFraction X_sat
      "Steam water mass fraction of saturation boundary in kg_water/kg_moistair";
    Modelica.SIunits.AbsolutePressure p_steam_sat
      "Partial saturation pressure of steam";
    Modelica.SIunits.TemperatureDifference dT
      "Temperature difference used to compute enthalpy";
  equation
      Xi = X[1:nXi];
      X[nX] = 1 - sum(Xi);
      for i in 1:nX loop
        assert(X[i] >= -1.e-5 and X[i] <= 1 + 1.e-5, "Mass fraction X[" +
          String(i) + "] = " + String(X[i]) + "of substance " +
          substanceNames[i] + "\nof medium " + mediumName +
          " is not in the range 0..1");
      end for;

    assert(p >= 0.0, "Pressure (= " + String(p) + " Pa) of medium \"" +
      mediumName + "\" is negative\n(Temperature = " + String(T) + " K)");

    assert(T >= TMin and T <= TMax, "
Temperature T is not in the allowed range " + String(TMin) + " <= (T ="
               + String(T) + " K) <= " + String(TMax) + " K
required from medium model \""     + mediumName + "\".");

    MM = 1/(Xi[Water]/MMX[Water]+(1.0-Xi[Water])/MMX[Air]);

    p_steam_sat = saturationPressure(T);
    X_sat       = min(p_steam_sat*k_mair/max(100*Modelica.Constants.eps, p - p_steam_sat)
                  *(1 - Xi[Water]), 1.0);
    X_liquid    = max(Xi[Water] - X_sat, 0.0);
    X_steam     = Xi[Water]-X_liquid;
    X_air       = 1-Xi[Water];

    //h = specificEnthalpy_pTX(p,T,Xi);
    dT =  state.T - 273.15;
    h  =  dT*dryair.cp * X_air +
         (dT * steam.cp + 2501014.5) * X_steam +
         dT*4186*X_liquid;
    R = dryair.R*(1 - X_steam/(1 - X_liquid)) + steam.R*X_steam/(1 - X_liquid);

    // Equation for ideal gas, from h=u+p*v and R*T=p*v, from which follows that  u = h-R*T.
    // u = h-R*T;

    // However, in this medium, the gas law is d=dStp (=constant), from which follows using h=u+pv that
    // u= h-p*v = h-p/d = h-p/dStp
    u = h-p/dStp;

    //    d = p/(R*T);
    d=dStp;// = p/pStp;

    /* Note, u and d are computed under the assumption that the volume of the liquid
         water is neglible with respect to the volume of air and of steam
      */
    state.p = p;
    state.T = T;
    state.X = X;

    // this x_steam is water load / dry air!!!!!!!!!!!
    x_water = Xi[Water]/max(X_air,100*Modelica.Constants.eps);
    phi = p/p_steam_sat*Xi[Water]/(Xi[Water] + k_mair*X_air);
  end BaseProperties;

redeclare function specificEnthalpy
    "Compute specific enthalpy from pressure, temperature and mass fraction"
  extends Annex60.Media.IdealGases.MoistAir.specificEnthalpy;
end specificEnthalpy;

redeclare function temperature_phX
    "Compute temperature from specific enthalpy and mass fraction"
  extends Annex60.Media.IdealGases.MoistAir.temperature_phX;
end temperature_phX;
  // Minimum and maximum temperatures that are checked in the BaseProperties.
  // These values are also used in Brent's algorithm in temperature_phX
protected
  constant Modelica.SIunits.Temperature TMin = 200 "Minimum temperature";
  constant Modelica.SIunits.Temperature TMax = 400 "Maximum temperature";

  annotation (preferredView="info", Documentation(info="<html>
<p>
This medium package models moist air using a constant density. 
The specific heat capacities at constant pressure and at constant volume are constant.
The air can become saturated, at which point the humidity is in both, liquid
and vapor form. As this is typically not needed to model air-conditioning equipment
(even dehumidifying cooling coils), user's should generally use
<a href=\"modelica://Annex60.Media.GasesConstantDensity.MoistAirUnsaturated\">
Annex60.Media.GasesConstantDensity.MoistAirUnsaturated</a>
instead of this medium.
</p>
<p>
Using a constant density avoids the fast pressure transients in volumes. 
However, in flow networks, the coupled nonlinear system of equations is generally larger compared
to using a medium model in which the density depends on the pressure.
</p>
<p>
This medium model is identical to 
<a href=\"modelica://Annex60.Media.IdealGases.MoistAir\">
Annex60.Media.IdealGases.MoistAir</a>, except the 
equation <code>d = p/(R*T)</code> has been replaced with 
<code>d =dStp</code>, where 
<code>dStp</code> is a constant density.
</p>
<p>
The use of a constant density avoids having pressure as a state variable in mixing volumes. Hence, fast transients
introduced by a change in pressure are avoided. 
The drawback is that the dimensionality of the coupled
nonlinear equation system is typically larger for flow
networks.
</p>
<p>
As in
<a href=\"modelica://Annex60.Media.IdealGases.MoistAir\">
Annex60.Media.IdealGases.MoistAir</a>, the
specific enthalpy <i>h</i> and specific internal energy <i>u</i> are only
a function of temperature <i>T</i> and 
species concentration <i>X</i> and all other provided medium
quantities are constant.
</p>
</html>", revisions="<html>
<ul>
<li>
November 14, 2013, by Michael Wetter:<br/>
Removed function
<code>HeatCapacityOfWater</code>
which is neither needed nor implemented in the
Modelica Standard Library.
</li>
<li>
March 29, 2013, by Michael Wetter:<br/>
Added <code>final standardOrderComponents=true</code> in the
<code>BaseProperties</code> declaration. This avoids an error
when models are checked in Dymola 2014 in the pedenatic mode.
</li>
<li>
April 12, 2012, by Michael Wetter:<br/>
Added keyword <code>each</code> to <code>Xi(stateSelect=...</code>.
</li>
<li>
April 4, 2012, by Michael Wetter:<br/>
Added redeclaration of <code>ThermodynamicState</code> to avoid a warning
during model check and translation.
</li>
<li>
August 3, 2011, by Michael Wetter:<br/>
Fixed bug in <code>u=h-R*T</code>, which is only valid for ideal gases. 
For this medium, the function is <code>u=h-p/dStp</code>.
</li>
<li>
August 2, 2011, by Michael Wetter:<br/>
Fixed error in the function <code>density</code> which returned a non-constant density,
and added a call to <code>ModelicaError(...)</code> in <code>setState_dTX</code> since this
function cannot assign the medium pressure based on the density (as density is a constant
in this model).
</li>
<li>
January 13, 2010, by Michael Wetter:<br/>
Added function <code>enthalpyOfNonCondensingGas</code> and its derivative.
</li>
<li>
January 13, 2010, by Michael Wetter:<br/>
Fixed implementation of derivative functions.
</li>
<li>
August 28, 2008, by Michael Wetter:<br/>
Referenced <code>spliceFunction</code> from package 
<a href=\"modelica://Annex60.Utilities.Math\">Annex60.Utilities.Math</a>
to avoid duplicate code.
</li>
<li>
August 21, 2008, by Michael Wetter:<br/>
Replaced <code>d*pStp = p*dStp</code> by
<code>d/dStp = p/pStp</code> to indicate that division by 
<code>dStp</code> and <code>pStp</code> is allowed.
</li>
<li>
August 22, 2008, by Michael Wetter:<br/>
Changed function 
<a href=\"modelica://Annex60.Media.GasesConstantDensity.MoistAir.density\">
density</a> so that it uses <code>rho=p/pStd*rhoStp</code>
instead of the ideal gas law.
</li>
<li>
August 18, 2008, by Michael Wetter:<br/>
Changed function 
<a href=\"modelica://Annex60.Media.GasesConstantDensity.MoistAir.temperature_phX\">
temperature_phX</a> so that it uses the implementation of
<a href=\"Annex60.Media.IdealGases.MoistAir.temperature_phX\">
Annex60.Media.IdealGases.MoistAir.temperature_phX</a>.
</li>
<li>
August 15, 2008, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end MoistAir;

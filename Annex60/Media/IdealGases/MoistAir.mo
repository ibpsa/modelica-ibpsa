within Annex60.Media.IdealGases;
package MoistAir
  "Moist air model with constant specific heat capacities and ideal gas law"
  extends Annex60.Media.IdealGases.MoistAirUnsaturated(
    mediumName="Moist air ideal gas");

  redeclare model BaseProperties

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
    //
    u = h - R*T;
    d = p/(R*T);
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
  extends Modelica.Icons.Function;

  input ThermodynamicState state "Thermodynamic state record";
  output SpecificEnthalpy h "Specific enthalpy";

  protected
  Modelica.SIunits.AbsolutePressure p_steam_sat
      "Partial saturation pressure of steam";
  Modelica.SIunits.MassFraction X_sat
      "Absolute humidity per unit mass of moist air";
  Modelica.SIunits.MassFraction X_liquid "Mass fraction of liquid water";
  Modelica.SIunits.MassFraction X_steam "Mass fraction of steam water";
  Modelica.SIunits.MassFraction X_air "Mass fraction of air";
  Modelica.SIunits.TemperatureDifference dT
      "Temperature difference used to compute enthalpy";
algorithm
  p_steam_sat :=saturationPressure(state.T);
  X_sat       :=min(p_steam_sat*k_mair/max(100*Modelica.Constants.eps, state.p
       - p_steam_sat)*(1 - state.X[Water]), 1.0);
  X_liquid    :=max(state.X[Water] - X_sat, 0.0);
  X_steam  := state.X[Water] - X_liquid;
  X_air    := 1 - state.X[Water];

/* THIS DOES NOT WORK --------------------------    
  h := enthalpyOfDryAir(T) * X_air + 
       Modelica.Media.Air.MoistAir.enthalpyOfCondensingGas(T) * X_steam + enthalpyOfLiquid(T)*X_liquid;
--------------------------------- */

/* THIS WORKS!!!! +++++++++++++++++++++
  h := (T - 273.15)*dryair.cp * X_air + 
       Modelica.Media.Air.MoistAir.enthalpyOfCondensingGas(T) * X_steam + enthalpyOfLiquid(T)*X_liquid;
 +++++++++++++++++++++*/
  dT := state.T - 273.15;
  h  := dT*dryair.cp * X_air +
       (dT * steam.cp + 2501014.5) * X_steam +
       dT*4186*X_liquid;
  annotation(Inline=false,smoothOrder=1);
end specificEnthalpy;

redeclare function temperature_phX
    "Compute temperature from specific enthalpy and mass fraction"
    extends Modelica.Icons.Function;
  input AbsolutePressure p "Pressure";
  input SpecificEnthalpy h "Specific enthalpy";
  input MassFraction X[:] "Mass fractions of composition";
  output Temperature T "Temperature";

  protected
package Internal
      "Solve h(data,T) for T with given h (use only indirectly via temperature_phX)"
  extends Modelica.Media.Common.OneNonLinearEquation;

  redeclare record extends f_nonlinear_Data
        "Data to be passed to non-linear function"
    extends Modelica.Media.IdealGases.Common.DataRecord;
  end f_nonlinear_Data;

  redeclare function extends f_nonlinear
  algorithm
      y := specificEnthalpy_pTX(p,x,X);
  end f_nonlinear;

  // Dummy definition has to be added for current Dymola
  redeclare function extends solve
  end solve;
end Internal;
  protected
constant Modelica.Media.IdealGases.Common.DataRecord steam=
              Modelica.Media.IdealGases.Common.SingleGasesData.H2O;
  protected
 Modelica.SIunits.AbsolutePressure p_steam_sat
      "Partial saturation pressure of steam";
 Modelica.SIunits.MassFraction x_sat
      "steam water mass fraction of saturation boundary";
  // Min and max values, used for Brent's algorithm in T_hpX
algorithm
  T := 273.15 + (h - 2501014.5 * X[Water])/((1 - X[Water])*dryair.cp + X[Water] *
     Annex60.Media.IdealGases.Common.SingleGasData.H2O.cp);
  // check for saturation
  p_steam_sat :=saturationPressure(T);
  x_sat    :=k_mair*p_steam_sat/(p - p_steam_sat);
  // If the state is in the fog region, then the above equation is not valid, and
  // T is computed by inverting specificEnthalpy_pTX(), which is much more costly.
  // For Annex60.Fluid.HeatExchangers.Examples.WetEffectivenessNTUPControl, the
  // computation above reduces the computing time by about a factor of 2.
  if (X[Water] > x_sat/(1 + x_sat)) then
     T := Internal.solve(h, TMin, TMax, p, X[1:nXi], steam);
  end if;
    annotation (inverse(h=specificEnthalpy_pTX(p, T, X)),
Documentation(info="<html>
Temperature is computed from pressure, specific enthalpy and composition via 
numerical inversion of function 
<a href=\"modelica://Annex60.Media.IdealGases.MoistAir.specificEnthalpy_pTX\">
Annex60.Media.IdealGases.MoistAir.specificEnthalpy_pTXspecificEnthalpy_pTX</a>.
</html>"));
end temperature_phX;

protected
  constant Modelica.SIunits.Temperature TMin = 200 "Minimum temperature";
  constant Modelica.SIunits.Temperature TMax = 400 "Maximum temperature";

  annotation (preferredView="info", Documentation(info="<html>
<p>
This medium package models moist air using the ideal gas law. 
The specific heat capacities at constant pressure and at constant volume are constant.
The air can become saturated, at which point the humidity is in both, liquid
and vapor form. As this is typically not needed to model air-conditioning equipment
(even dehumidifying cooling coils), user's should generally use
<a href=\"modelica://Annex60.Media.IdealGases.MoistAirUnsaturated\">
Annex60.Media.IdealGases.MoistAirUnsaturated</a>
instead of this medium.
</p>
<h4>Implementation</h4>
<p>
Because water may be in liquid and vapor form, computing temperature
from specific enthalpy and water concentration requires the solution of
a nonlinear equation. This equation is solved internally in the function
<a href=\"modelica://Annex60.Media.IdealGases.MoistAir.temperature_phX\">
Annex60.Media.IdealGases.MoistAir.temperature_phX</a>.
Whenever this equation is used, it is not possible for a code generator 
to compute a symbolic expression for the Jacobian matrix.
Therefore, a numerical differentiation will be used during the simulation,
which can considerably increase computing time. 
</p>
</html>", revisions="<html>
<ul>
<li>
November 15, 2013, by Michael Wetter:<br/>
Completely revised and simplified the implementation to extend from
<a href=\"modelica://Annex60.Media.IdealGases.MoistAirUnsaturated</a>
Annex60.Media.IdealGases.MoistAirUnsaturated</a>.
</li>
<li>
May 8, 2008, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end MoistAir;

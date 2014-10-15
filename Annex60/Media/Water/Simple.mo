within Annex60.Media;
package Simple "Package with model for liquid water with constant properties"
   extends Modelica.Media.Water.ConstantPropertyLiquidWater(
     final cp_const=4184,
     final cv_const=4184,
     p_default=300000);
  // cp_const and cv_const have been made final because the model sets u=h.


  redeclare model BaseProperties "Base properties"
    Modelica.SIunits.Temperature T(stateSelect=if
          preferredMediumStates then StateSelect.prefer else StateSelect.default)
    "Temperature of medium";
    InputAbsolutePressure p(stateSelect=if
          preferredMediumStates then StateSelect.prefer else StateSelect.default)
    "Absolute pressure of medium";
    InputMassFraction[nXi] Xi=fill(0, 0)
    "Structurally independent mass fractions";
    InputSpecificEnthalpy h "Specific enthalpy of medium";
    Modelica.SIunits.SpecificInternalEnergy u
    "Specific internal energy of medium";
    Modelica.SIunits.Density d=d_const "Density of medium";
    Modelica.SIunits.MassFraction[nX] X={1}
    "Mass fractions (= (component mass)/total mass  m_i/m)";
    final Modelica.SIunits.SpecificHeatCapacity R=0
    "Gas constant (of mixture if applicable)";
    final Modelica.SIunits.MolarMass MM=MM_const
    "Molar mass (of mixture or single fluid)";
    ThermodynamicState state
    "Thermodynamic state record for optional functions";
    parameter Boolean preferredMediumStates=false
    "= true if StateSelect.prefer shall be used for the independent property variables of the medium"
      annotation (Evaluate=true, Dialog(tab="Advanced"));
    final parameter Boolean standardOrderComponents=true
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

  equation
    assert(T >= T_min and T <= T_max, "
Temperature T (= "
                 + String(T) + " K) is not
in the allowed range ("
                      + String(T_min) + " K <= T <= " + String(T_max) + " K)
required from medium model \""
                             + mediumName + "\".
");

    h = cp_const*(T-T0);
    //h = specificEnthalpy_pTX(p, T, X);
    u = h;
    state.T = T;
    state.p = p;
    annotation (Documentation(info="<html>
    <p>
    This base properties model is identical to
    <a href=\"modelica://Modelica.Media.Water.ConstantPropertyLiquidWater\">
    Modelica.Media.Water.ConstantPropertyLiquidWater</a>,
    except that the equation
    <code>u = cv_const*(T - T0)</code>
    has been replaced by <code>u=h</code> because
    <code>cp_const=cv_const</code>.
    </p>
</html>"));
  end BaseProperties;


  annotation (preferredView="info", Documentation(info="<html>
This medium model is identical to 
<a href=\"modelica://Modelica.Media.Water.ConstantPropertyLiquidWater\">
Modelica.Media.Water.ConstantPropertyLiquidWater</a>.
</html>", revisions="<html>
<ul>
<li>
October 15, 2014, by Michael Wetter:<br/>
Reimplemented media based on 
<a href=\"https://github.com/iea-annex60/modelica-annex60/blob/446aa83720884052476ad6d6d4f90a6a29bb8ec9/Annex60/Media/Water.mo\">446aa83</a>.
</li>
<li>
November 15, 2013, by Michael Wetter:<br/>
Complete new reimplementation because the previous version
had the option to add a compressibility to the medium, which
has never been used.
</li>
</ul>
</html>"));
end Simple;

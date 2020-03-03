within IBPSA.Media.Examples;
model SteamSaturatedProperties
  "Model that tests the implementation of the steam properties at saturated liquid and vapor states"
  extends Modelica.Icons.Example;

  package Medium = IBPSA.Media.Steam  "Steam medium model";

  parameter Modelica.SIunits.Temperature TMin = 273.15
    "Minimum temperature for the simulation";
  parameter Modelica.SIunits.Temperature TMax = 293.15
    "Maximum temperature for the simulation";
  parameter Modelica.SIunits.Pressure pMin = 1e5
    "Minimum pressure for the simulation";
  parameter Modelica.SIunits.Pressure pMax = 10e5
    "Maximum pressure for the simulation";
  parameter Modelica.SIunits.Pressure p "Pressure";
  parameter Modelica.SIunits.MassFraction X[Medium.nX]=
    Medium.X_default "Mass fraction";
  Medium.Temperature T =  Medium.T_default  "Temperature";
  Modelica.SIunits.Conversions.NonSIunits.Temperature_degC T_degC
    "Celsius temperature";

//protected
  constant Real conv(unit="1/s") = 1 "Conversion factor to satisfy unit check";

  function checkState
    extends Modelica.Icons.Function;
    input Medium.ThermodynamicState state1 "Medium state";
    input Medium.ThermodynamicState state2 "Medium state";
    input String message "Message for error reporting";
  algorithm
    assert(abs(Medium.temperature(state1)-Medium.temperature(state2))
       < 1e-8, "Error in temperature of " + message);
    assert(abs(Medium.pressure(state1)-Medium.pressure(state2))
       < 1e-8, "Error in pressure of " + message);
  end checkState;

equation
    // Compute temperatures that are used as input to the functions
    p = pMin + conv*time * (pMax-pMin);
    T_degC = Modelica.SIunits.Conversions.to_degC(T);

    // Check the implementation of the functions


   annotation(experiment(Tolerance=1e-6, StopTime=1.0),
__Dymola_Commands(file="modelica://IBPSA/Resources/Scripts/Dymola/Media/Examples/SteamProperties.mos"
        "Simulate and plot"),
      Documentation(info="<html>
<p>
This example checks the saturation properties of the medium.
</p>
</html>",
revisions="<html>
<ul>
<li>
March 4, 2020, by Kathryn Hinkelman:<br/>
First implementation.
</li>
</ul>
</html>"));
end SteamSaturatedProperties;

within IBPSA.Media.Examples;
model SteamProperties
  "Model that tests the implementation of the steam properties"
  extends Modelica.Icons.Example;
  extends IBPSA.Media.Examples.BaseClasses.FluidProperties(
    redeclare package Medium = IBPSA.Media.Steam,
    TMin=273.16,
    TMax=647);
    // Min and max temperature ranges limited by h_fg(T) formulation

  Modelica.SIunits.SpecificEnthalpy h_fg "Enthalpy of vaporization";
  Modelica.SIunits.SpecificEnthalpy hSte "Enthalpy of steam";

equation
  // Check the implementation of the base properties
  basPro.state.p=p;
  basPro.state.T=T;

  h_fg = Medium.enthalpyOfVaporization(T);
  hSte = Medium.enthalpySteam(T);

   annotation(experiment(Tolerance=1e-6, StopTime=1.0),
__Dymola_Commands(file="modelica://IBPSA/Resources/Scripts/Dymola/Media/Examples/SteamProperties.mos"
        "Simulate and plot"),
      Documentation(info="<html>
<p>
This example checks thermophysical properties of the medium.
</p>
</html>",
revisions="<html>
<ul>
<li>
January 16, 2020, by Kathryn Hinkelman:<br/>
Change medium to ideal steam to eliminate discontinuities.
</li>
<li>
September 12, 2019, by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"));
end SteamProperties;

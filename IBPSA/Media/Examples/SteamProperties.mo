within IBPSA.Media.Examples;
model SteamProperties
  "Model that tests the implementation of the steam properties"
  extends Modelica.Icons.Example;
  extends IBPSA.Media.Examples.BaseClasses.PartialProperties(
    redeclare package Medium = IBPSA.Media.Steam,
    TMin=273.15+100,
    TMax=273.15+800,
    p=100000);

  Medium.ThermodynamicState state_phX "Medium state";
  Medium.ThermodynamicState state_psX "Medium state";

  Modelica.Media.Interfaces.Types.DerDensityByPressure ddpT
    "Density derivative w.r.t. pressure";
  Modelica.Media.Interfaces.Types.DerDensityByTemperature ddTp
    "Density derivative w.r.t. temperature";
  Modelica.SIunits.Density[Medium.nX] dddX
    "Density derivative w.r.t. mass fraction";

equation

   // Check setting the states
    state_pTX = Medium.setState_pTX(p=p, T=T, X=X);
    state_phX = Medium.setState_phX(p=p, h=h, X=X);
    state_psX = Medium.setState_psX(p=p, s=s, X=X);
    checkState(state_pTX, state_phX, "state_phX");
    checkState(state_pTX, state_psX, "state_psX");

    // Check the implementation of the functions
    ddpT = Medium.density_derp_T(state_pTX);
    ddTp = Medium.density_derT_p(state_pTX);
    dddX   = Medium.density_derX(state_pTX);

  // Check the implementation of the base properties
  basPro.state.p=p;
  basPro.state.T=T;

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
March 6, 2020, by Kathryn Hinkelman:<br/>
Change medium to ideal steam to eliminate discontinuities.
</li>
<li>
September 12, 2019, by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"));
end SteamProperties;

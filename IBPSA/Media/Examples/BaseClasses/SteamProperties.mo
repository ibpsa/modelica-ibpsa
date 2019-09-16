within IBPSA.Media.Examples.BaseClasses;
partial model SteamProperties
  "Model that tests the implementation of the fluid properties"
  extends PartialProperties;

  Medium.ThermodynamicState state_pTX "Medium state";

  Modelica.Media.Interfaces.Types.DerDensityByPressure ddph
    "Density derivative w.r.t. pressure";
  Modelica.Media.Interfaces.Types.DerDensityByEnthalpy ddhp
    "Density derivative w.r.t. enthalpy";

  Integer region;
  Modelica.Media.Common.IF97BaseTwoPhase aux;

equation
    // Check the water region
    aux = Modelica.Media.Water.IF97_Utilities.waterBaseProp_pT(p=p,T=T);
    region = aux.region;

    // Check setting the states
    state_pTX = Medium.setState_pTX(p=p, T=T, X=X);

    // Check the implementation of the functions
    ddhp = Medium.density_derh_p(state_pTX);
    ddph = Medium.density_derp_h(state_pTX);
   annotation (
Documentation(info="<html>
<p>
This example checks thermophysical properties of the steam medium.
</p>
</html>",
revisions="<html>
<ul>
<li>
September 12, 2019, by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"));
end SteamProperties;

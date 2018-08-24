within IDEAS.LIDEAS.Components;
model LinZone "Linearisable zone model"
  extends IDEAS.Buildings.Components.Zone(
    redeclare IDEAS.Buildings.Components.ZoneAirModels.WellMixedAir
      airModel(vol(T(stateSelect=StateSelect.prefer))),
      redeclare IDEAS.Buildings.Components.InterzonalAirFlow.n50FixedPressure interzonalAirFlow);
  parameter Boolean linearise=sim.linearise "Linearise model equations";

equation
  assert(Medium.nX ==1, "LinZone model does not allow moist air or air with CO2 medium. Use the IDEAS.Media.Specialized.DryAir medium.");
  annotation (Documentation(info="<html>
<p>
Extension of <code>IDEAS.Buildings.Components.Zone</code> to make linearization of the zone possible.
The model is therefore pre-configured to used the well-mixed air model with the temperature as preferred state of the
mixing volume and using <code>Buildings.Components.InterzonalAirFlow.n50FixedPressure</code> for the infiltration.
</p>
<p>
An assert statement is added to ensure that the user only use the <code>IDEAS.Media.Specialized.DryAir</code> model as
the linearization does not work with other type of Media.
</p>

</html>", revisions="<html>
<ul>
<li>August 21, 2018 by Damien Picard: <br/>Remove custom air model and use 
<code>IDEAS.Buildings.Components.ZoneAirModels.WellMixedAir</code> with correct
parametrization instead.</li>
</ul>
</html>"));
end LinZone;

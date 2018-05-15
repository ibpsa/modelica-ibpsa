within IDEAS.LIDEAS.Components;
model LinZone "Linearisable zone model"
  extends IDEAS.Buildings.Components.Zone(redeclare replaceable BaseClasses.LinearAirModel
      airModel(linearise=linearise));
  parameter Boolean linearise=sim.linearise "Linearise model equations";
end LinZone;

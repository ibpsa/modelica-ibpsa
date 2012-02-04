within IDEAS.Buildings.Validation.BaseClasses;
model NightVentilation "BesTest nightventilation system"
  extends IDEAS.Interfaces.VentilationSystem(nZones=1);

IDEAS.Occupants.Components.Schedule occ(occupancy=3600*{7, 18},firstEntryOccupied=true);
final parameter Real corrCV = 0.822;

algorithm
if occ.occupied then
  heatPortCon.Q_flow := zeros(nZones);
else
  heatPortCon.Q_flow := ones(nZones)*(TSensor[1] - sim.Te) * 1703.16 * corrCV * 1012 * 1.024 / 3600;
end if;

end NightVentilation;

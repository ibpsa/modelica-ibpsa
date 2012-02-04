within IDEAS.Buildings.Validation.BaseClasses;
model NightVentilation "BesTest nightventilation system"
  extends IDEAS.Interfaces.VentilationSystem;

parameter IDEAS.Occupants.Components.Schedule occ(occupancy=3600*{7, 18},firstEntryOccupied=true);
parameter Modelica.SIunits.Temperature[1] Tset={273.15+27}
    "Heating on below 20°C and cooling on above 27°C";
final parameter Real corrCV = 0.822;

algorithm
if occ.occupied then
  heatPortCon.Q_flow := 0;
else
  heatPortCon.Q_flow := (TSensor - sim.Te) * 1703.16 * corrCV * 1012 * 1.024 / 3600;
end if;

end NightVentilation;

within IDEAS.Buildings.Validation.BaseClasses;
package VentilationSystem

    extends Modelica.Icons.Package;

  model None "None"
    extends IDEAS.Interfaces.VentilationSystem;

  algorithm
  for i in 1:nZones loop
    heatPortCon[i].Q_flow := 0;
  end for;

  end None;

  model NightVentilation "BESTEST nightventilation system"
    extends IDEAS.Interfaces.VentilationSystem;

    IDEAS.Occupants.Components.Schedule occ(occupancy=3600*{7, 18},firstEntryOccupied=true)
      "Occupancy shedule";
    final parameter Real corrCV = 0.822
      "Air density correction for BESTEST at hig altitude";

  algorithm
  for i in 1:nZones loop
    if not occ.occupied then
      heatPortCon[i].Q_flow := (TSensor[i] - sim.Te) * 1703.16 * corrCV * 1012 * 1.024 / 3600;
    else
      heatPortCon[i].Q_flow := 0;
    end if;
  end for;
  end NightVentilation;

end VentilationSystem;

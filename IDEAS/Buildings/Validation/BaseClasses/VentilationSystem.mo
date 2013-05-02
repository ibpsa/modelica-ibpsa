within IDEAS.Buildings.Validation.BaseClasses;
package VentilationSystem

    extends Modelica.Icons.Package;

  model None "None"
    extends IDEAS.Interfaces.VentilationSystem(nLoads=1);

  equation
  wattsLawPlug.P[1] = 0;
  wattsLawPlug.Q[1] = 0;
  for i in 1:nZones loop
    heatPortCon[i].Q_flow =  0;
  end for;
    annotation (Diagram(graphics));
  end None;

  model NightVentilation "BESTEST nightventilation system"
    extends IDEAS.Interfaces.VentilationSystem(nLoads=1);

    IDEAS.Occupants.Components.Schedule occ(occupancy=3600*{7, 18},firstEntryOccupied=true)
      "Occupancy shedule";
    final parameter Real corrCV = 0.822
      "Air density correction for BESTEST at hig altitude";

  equation
  wattsLawPlug.P[1] = 0;
  wattsLawPlug.Q[1] = 0;

  for i in 1:nZones loop
    if not occ.occupied then
      heatPortCon[i].Q_flow =  (TSensor[i] - sim.Te) * 1703.16 * corrCV * 1012 * 1.024 / 3600;
    else
      heatPortCon[i].Q_flow =  0;
    end if;
  end for;

    annotation (Diagram(graphics));
  end NightVentilation;

end VentilationSystem;

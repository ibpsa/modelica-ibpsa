within IDEAS.Buildings.Validation.Cases;
model Case610
Modelica.SIunits.Power PHea = min(heatingSystem.heatPortCon[1].Q_flow,0);
Modelica.SIunits.Power PCoo = max(heatingSystem.heatPortCon[1].Q_flow,0);

    extends IDEAS.Buildings.Validation.Interfaces.BesTestCase(
    redeclare BaseClasses.Occupant.Gain occupant,
    redeclare BaseClasses.Structure.Bui610 building,
    redeclare BaseClasses.VentilationSystem.None ventilationSystem,
    redeclare BaseClasses.HeatingSystem.Deadband heatingSystem(VZones=building.VZones),
    redeclare IDEAS.Interfaces.BaseClasses.CausalInhomeFeeder inHomeGrid);
end Case610;

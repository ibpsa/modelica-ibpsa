within IDEAS.Buildings.Validation.Cases;
model Case950
  extends IDEAS.Buildings.Validation.Interfaces.BesTestCase(
    redeclare BaseClasses.Structure.Bui900 building,
    redeclare BaseClasses.Occupant.Gain occupant,
    redeclare BaseClasses.VentilationSystem.NightVentilation ventilationSystem,
    redeclare BaseClasses.HeatingSystem.Deadband_650 heatingSystem(VZones=
          building.VZones),
    redeclare IDEAS.Templates.Interfaces.BaseClasses.CausalInhomeFeeder
      inHomeGrid);

end Case950;

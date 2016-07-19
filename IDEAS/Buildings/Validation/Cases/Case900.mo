within IDEAS.Buildings.Validation.Cases;
model Case900
  extends IDEAS.Buildings.Validation.Interfaces.BesTestCase(
    redeclare BaseClasses.Structure.Bui900 building,
    redeclare final BaseClasses.Occupant.Gain occupant,
    redeclare final BaseClasses.HeatingSystem.Deadband heatingSystem(VZones=
          building.VZones),
    redeclare final BaseClasses.VentilationSystem.None ventilationSystem,
    redeclare final IDEAS.Templates.Interfaces.BaseClasses.CausalInhomeFeeder
      inHomeGrid);
end Case900;

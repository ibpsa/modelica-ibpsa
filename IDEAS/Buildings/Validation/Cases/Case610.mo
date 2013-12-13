within IDEAS.Buildings.Validation.Cases;
model Case610
  extends IDEAS.Buildings.Validation.Interfaces.BesTestCase(
    redeclare BaseClasses.Occupant.Gain occupant,
    redeclare BaseClasses.Structure.Bui610 building,
    redeclare BaseClasses.VentilationSystem.None ventilationSystem,
    redeclare BaseClasses.HeatingSystem.Deadband heatingSystem,
    redeclare IDEAS.Interfaces.BaseClasses.CausalInhomeFeeder inHomeGrid);
end Case610;

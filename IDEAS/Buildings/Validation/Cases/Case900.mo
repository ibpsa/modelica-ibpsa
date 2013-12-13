within IDEAS.Buildings.Validation.Cases;
model Case900
  extends IDEAS.Buildings.Validation.Interfaces.BesTestCase(
    redeclare final BaseClasses.Structure.Bui900 building,
    redeclare final BaseClasses.Occupant.Gain occupant,
    redeclare final BaseClasses.HeatingSystem.Deadband heatingSystem,
    redeclare final BaseClasses.VentilationSystem.None ventilationSystem,
    redeclare final IDEAS.Interfaces.BaseClasses.CausalInhomeFeeder inHomeGrid);
end Case900;

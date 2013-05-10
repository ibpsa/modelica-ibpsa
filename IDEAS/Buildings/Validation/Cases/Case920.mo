within IDEAS.Buildings.Validation.Cases;
model Case920
  extends IDEAS.Buildings.Validation.Interfaces.BesTestCase(
    redeclare BaseClasses.Structure.Bui620 building,
    redeclare BaseClasses.Occupant.Gain occupant,
    redeclare BaseClasses.VentilationSystem.None ventilationSystem,
    redeclare BaseClasses.HeatingSystem.Deadband heatingSystem,
    redeclare IDEAS.Interfaces.BaseClasses.CausalInhomeFeeder
                                                inHomeGrid);
end Case920;

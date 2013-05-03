within IDEAS.Buildings.Validation.Cases;
model Case900FF
  extends IDEAS.Buildings.Validation.Interfaces.BesTestCase(
    redeclare BaseClasses.Structure.Bui900 building,
    redeclare BaseClasses.Occupant.Gain occupant,
    redeclare BaseClasses.HeatingSystem.Deadband heatingSystem,
    redeclare BaseClasses.VentilationSystem.None ventilationSystem,
    redeclare IDEAS.Interfaces.CausalInHomeGrid inHomeGrid);
end Case900FF;

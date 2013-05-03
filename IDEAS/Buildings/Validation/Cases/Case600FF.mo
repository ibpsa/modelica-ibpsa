within IDEAS.Buildings.Validation.Cases;
model Case600FF
  extends IDEAS.Buildings.Validation.Interfaces.BesTestCase(
    redeclare BaseClasses.Structure.Bui600 building,
    redeclare BaseClasses.Occupant.Gain occupant,
    redeclare BaseClasses.HeatingSystem.None heatingSystem,
    redeclare BaseClasses.VentilationSystem.None ventilationSystem,
    redeclare IDEAS.Interfaces.CausalInHomeGrid inHomeGrid);
end Case600FF;

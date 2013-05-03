within IDEAS.Buildings.Validation.Cases;
model Case640
  extends IDEAS.Buildings.Validation.Interfaces.BesTestCase(
    redeclare BaseClasses.Structure.Bui600 building,
    redeclare BaseClasses.Occupant.Gain occupant,
    redeclare BaseClasses.VentilationSystem.None ventilationSystem,
    redeclare BaseClasses.HeatingSystem.ThermostatSetback heatingSystem,
    redeclare IDEAS.Interfaces.CausalInHomeGrid inHomeGrid);
end Case640;

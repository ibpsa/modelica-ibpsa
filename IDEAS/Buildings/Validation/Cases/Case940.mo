within IDEAS.Buildings.Validation.Cases;
model Case940
  extends IDEAS.Buildings.Validation.Cases.Case900(
    redeclare BaseClasses.VentilationSystem.None ventilationSystem,
    redeclare BaseClasses.HeatingSystem.ThermostatSetback heatingSystem(VZones=
          building.VZones));
end Case940;

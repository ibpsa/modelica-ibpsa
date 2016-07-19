within IDEAS.Buildings.Validation.Cases;
model Case650
  extends IDEAS.Buildings.Validation.Cases.Case600(
    redeclare BaseClasses.HeatingSystem.Deadband_650 heatingSystem(VZones=
          building.VZones),
    redeclare BaseClasses.VentilationSystem.NightVentilation ventilationSystem);

end Case650;

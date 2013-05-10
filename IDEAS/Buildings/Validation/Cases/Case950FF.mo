within IDEAS.Buildings.Validation.Cases;
model Case950FF
  extends IDEAS.Buildings.Validation.Interfaces.BesTestCase(
    redeclare BaseClasses.Occupant.Gain occupant,
    redeclare BaseClasses.Structure.Bui900 building,
    redeclare BaseClasses.HeatingSystem.None heatingSystem,
    redeclare BaseClasses.VentilationSystem.NightVentilation ventilationSystem,
    redeclare IDEAS.Interfaces.CausalInHomeGrid inHomeGrid);

end Case950FF;

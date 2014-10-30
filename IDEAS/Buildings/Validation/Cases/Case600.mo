within IDEAS.Buildings.Validation.Cases;
model Case600
  import IDEAS;

Modelica.SIunits.Power PHea = min(heatingSystem.heatPortCon[1].Q_flow,0);
Modelica.SIunits.Power PCoo = max(heatingSystem.heatPortCon[1].Q_flow,0);

  extends IDEAS.Buildings.Validation.Interfaces.BesTestCase(
    redeclare IDEAS.Buildings.Validation.BaseClasses.Structure.Bui600 building,
    redeclare IDEAS.Buildings.Validation.BaseClasses.Occupant.Gain occupant,
    redeclare IDEAS.Buildings.Validation.BaseClasses.HeatingSystem.Deadband
      heatingSystem(VZones=building.VZones),
    redeclare IDEAS.Buildings.Validation.BaseClasses.VentilationSystem.None
      ventilationSystem,
    redeclare IDEAS.Interfaces.BaseClasses.CausalInhomeFeeder inHomeGrid);

end Case600;

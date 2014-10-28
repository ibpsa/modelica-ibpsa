within IDEAS.Buildings.Validation.Cases;
model Case195
  import IDEAS;

Modelica.SIunits.Power PHea = min(heatingSystem.heatPortCon[1].Q_flow,0);
Modelica.SIunits.Power PCoo = max(heatingSystem.heatPortCon[1].Q_flow,0);
Modelica.SIunits.Temperature TAir = building.TSensor[1];

  extends IDEAS.Buildings.Validation.Interfaces.BesTestCase(
    redeclare IDEAS.Buildings.Validation.BaseClasses.Structure.Bui195 building,
    redeclare IDEAS.Buildings.Validation.BaseClasses.Occupant.None occupant,
    redeclare IDEAS.Buildings.Validation.BaseClasses.HeatingSystem.Bangbang
      heatingSystem(VZones=building.VZones),
    redeclare IDEAS.Buildings.Validation.BaseClasses.VentilationSystem.None
      ventilationSystem,
    redeclare IDEAS.Interfaces.BaseClasses.CausalInhomeFeeder inHomeGrid);

end Case195;

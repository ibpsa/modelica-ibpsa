within IDEAS.Buildings.Validation.Cases;
model Case900
Modelica.SIunits.Power PHea = min(heatingSystem.heatPortCon[1].Q_flow,0);
Modelica.SIunits.Power PCoo = max(heatingSystem.heatPortCon[1].Q_flow,0);

  extends IDEAS.Buildings.Validation.Interfaces.BesTestCase(
    redeclare final BaseClasses.Structure.Bui900 building,
    redeclare final BaseClasses.Occupant.Gain occupant,
    redeclare final BaseClasses.HeatingSystem.Deadband heatingSystem(VZones=
          building.VZones),
    redeclare final BaseClasses.VentilationSystem.None ventilationSystem,
    redeclare final IDEAS.Interfaces.BaseClasses.CausalInhomeFeeder inHomeGrid);
end Case900;

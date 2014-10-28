within IDEAS.Buildings.Validation.Cases;
model Case650FF
Modelica.SIunits.Power PHea = min(heatingSystem.heatPortCon[1].Q_flow,0);
Modelica.SIunits.Power PCoo = max(heatingSystem.heatPortCon[1].Q_flow,0);

  extends IDEAS.Buildings.Validation.Interfaces.BesTestCase(
    redeclare BaseClasses.Occupant.Gain occupant,
    redeclare BaseClasses.Structure.Bui900 building,
    redeclare BaseClasses.HeatingSystem.None heatingSystem,
    redeclare BaseClasses.VentilationSystem.NightVentilation ventilationSystem,
    redeclare IDEAS.Interfaces.BaseClasses.CausalInhomeFeeder inHomeGrid);

end Case650FF;

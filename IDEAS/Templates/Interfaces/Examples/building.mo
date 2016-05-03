within IDEAS.Templates.Interfaces.Examples;
model building
  extends IDEAS.Templates.Interfaces.Building(
    redeclare Buildings.Examples.BaseClasses.structure building,
    redeclare Templates.Ventilation.None ventilationSystem,
    redeclare Occupants.Standards.None occupant,
    redeclare Templates.Heating.None heatingSystem,
    redeclare BaseClasses.CausalInhomeFeeder inHomeGrid);

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics));
end building;

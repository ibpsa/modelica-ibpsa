within IDEAS.Buildings.Validation.Cases;
model Case600FF
  extends IDEAS.Buildings.Validation.Cases.Case600(
    redeclare BaseClasses.HeatingSystem.None heatingSystem,
    redeclare BaseClasses.VentilationSystem.None ventilationSystem);
end Case600FF;

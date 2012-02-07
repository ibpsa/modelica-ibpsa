within IDEAS.Buildings.Validation;
model BESTEST_singleCase

    inner IDEAS.Climate.SimInfoManager sim(redeclare
      IDEAS.Climate.Meteo.Files.min60   detail, redeclare
      IDEAS.Climate.Meteo.Locations.BesTest   city,
    DST=false)
      annotation (Placement(transformation(extent={{-92,68},{-82,78}})));
  Interfaces.Building case600FF(redeclare
      IDEAS.Buildings.Validation.BaseClasses.Structure.Bui600  building,
      redeclare IDEAS.Buildings.Validation.BaseClasses.Occupant.Gain  occupant,
    redeclare IDEAS.Buildings.Validation.BaseClasses.HeatingSystem.None heatingSystem,
    redeclare IDEAS.Buildings.Validation.BaseClasses.InhomeFeeder.None inhomeGrid,
    redeclare IDEAS.Buildings.Validation.BaseClasses.VentilationSystem.None
      ventilationSystem)
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
end BESTEST_singleCase;

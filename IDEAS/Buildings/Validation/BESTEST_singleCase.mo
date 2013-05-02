within IDEAS.Buildings.Validation;
model BESTEST_singleCase

    inner IDEAS.SimInfoManager         sim(redeclare
      IDEAS.Climate.Meteo.Files.min60   detail, redeclare
      IDEAS.Climate.Meteo.Locations.BesTest   city,
    DST=false,
    PV=false,
    occBeh=false)
      annotation (Placement(transformation(extent={{-92,68},{-82,78}})));
  Interfaces.Building case600FF(redeclare
      IDEAS.Buildings.Validation.BaseClasses.Structure.Bui600  building,
      redeclare IDEAS.Buildings.Validation.BaseClasses.Occupant.Gain  occupant,
    redeclare IDEAS.Buildings.Validation.BaseClasses.HeatingSystem.None heatingSystem,
    redeclare IDEAS.Buildings.Validation.BaseClasses.VentilationSystem.None
      ventilationSystem,
    redeclare IDEAS.Interfaces.CausalInHomeGrid inHomeGrid)
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  annotation (Diagram(graphics),
    experiment(
      StopTime=3.1536e+007,
      Interval=3600,
      Tolerance=1e-007),
    __Dymola_experimentSetupOutput);
end BESTEST_singleCase;

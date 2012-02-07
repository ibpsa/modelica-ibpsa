within IDEAS.Buildings.Validation;
model BESTEST

    inner IDEAS.Climate.SimInfoManager sim(redeclare
      IDEAS.Climate.Meteo.Files.min60   detail, redeclare
      IDEAS.Climate.Meteo.Locations.BesTest   city)
      annotation (Placement(transformation(extent={{-92,68},{-82,78}})));
  Interfaces.Building case600(redeclare
      IDEAS.Buildings.Validation.BaseClasses.Structure.Bui600  building,
      redeclare IDEAS.Buildings.Validation.BaseClasses.Occupant.Gain  occupant,
    redeclare IDEAS.Buildings.Validation.BaseClasses.HeatingSystem.Deadband
      heatingSystem,
    redeclare IDEAS.Buildings.Validation.BaseClasses.InhomeFeeder.None
      inhomeGrid,
    redeclare IDEAS.Buildings.Validation.BaseClasses.VentilationSystem.None
      ventilationSystem)
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Interfaces.Building case600FF(redeclare
      IDEAS.Buildings.Validation.BaseClasses.Structure.Bui600  building,
      redeclare IDEAS.Buildings.Validation.BaseClasses.Occupant.Gain  occupant,
    redeclare IDEAS.Buildings.Validation.BaseClasses.HeatingSystem.None heatingSystem,
    redeclare IDEAS.Buildings.Validation.BaseClasses.InhomeFeeder.None inhomeGrid,
    redeclare IDEAS.Buildings.Validation.BaseClasses.VentilationSystem.None
      ventilationSystem)
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  Interfaces.Building case620(redeclare
      IDEAS.Buildings.Validation.BaseClasses.Structure.Bui620  building,
      redeclare IDEAS.Buildings.Validation.BaseClasses.Occupant.Gain  occupant,
    redeclare IDEAS.Buildings.Validation.BaseClasses.InhomeFeeder.None inhomeGrid,
    redeclare IDEAS.Buildings.Validation.BaseClasses.VentilationSystem.None
      ventilationSystem,
    redeclare IDEAS.Buildings.Validation.BaseClasses.HeatingSystem.Deadband
      heatingSystem)
    annotation (Placement(transformation(extent={{-20,60},{0,80}})));
  Interfaces.Building case640(redeclare
      IDEAS.Buildings.Validation.BaseClasses.Structure.Bui600  building,
      redeclare IDEAS.Buildings.Validation.BaseClasses.Occupant.Gain  occupant,
    redeclare IDEAS.Buildings.Validation.BaseClasses.InhomeFeeder.None inhomeGrid,
    redeclare IDEAS.Buildings.Validation.BaseClasses.VentilationSystem.None
      ventilationSystem,
    redeclare
      IDEAS.Buildings.Validation.BaseClasses.HeatingSystem.ThermostatSetback
      heatingSystem)
    annotation (Placement(transformation(extent={{20,60},{40,80}})));
  Interfaces.Building case650(redeclare
      IDEAS.Buildings.Validation.BaseClasses.Structure.Bui600  building,
      redeclare IDEAS.Buildings.Validation.BaseClasses.Occupant.Gain  occupant,
    redeclare IDEAS.Buildings.Validation.BaseClasses.InhomeFeeder.None inhomeGrid,
    redeclare
      IDEAS.Buildings.Validation.BaseClasses.VentilationSystem.NightVentilation
      ventilationSystem,
    redeclare IDEAS.Buildings.Validation.BaseClasses.HeatingSystem.Deadband
      heatingSystem)
    annotation (Placement(transformation(extent={{40,60},{60,80}})));
  Interfaces.Building case650FF(
      redeclare IDEAS.Buildings.Validation.BaseClasses.Occupant.Gain  occupant,
    redeclare IDEAS.Buildings.Validation.BaseClasses.Structure.Bui900 building,
    redeclare IDEAS.Buildings.Validation.BaseClasses.HeatingSystem.None heatingSystem,
    redeclare IDEAS.Buildings.Validation.BaseClasses.InhomeFeeder.None inhomeGrid,
    redeclare
      IDEAS.Buildings.Validation.BaseClasses.VentilationSystem.NightVentilation
      ventilationSystem)
    annotation (Placement(transformation(extent={{60,60},{80,80}})));
  Interfaces.Building case900(redeclare
      IDEAS.Buildings.Validation.BaseClasses.Structure.Bui900  building,
      redeclare IDEAS.Buildings.Validation.BaseClasses.Occupant.Gain  occupant,
    redeclare IDEAS.Buildings.Validation.BaseClasses.HeatingSystem.Deadband
      heatingSystem,
    redeclare IDEAS.Buildings.Validation.BaseClasses.InhomeFeeder.None
      inhomeGrid,
    redeclare IDEAS.Buildings.Validation.BaseClasses.VentilationSystem.None
      ventilationSystem)
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Interfaces.Building case900FF(redeclare
      IDEAS.Buildings.Validation.BaseClasses.Structure.Bui900  building,
      redeclare IDEAS.Buildings.Validation.BaseClasses.Occupant.Gain  occupant,
    redeclare IDEAS.Buildings.Validation.BaseClasses.HeatingSystem.Deadband
      heatingSystem,
    redeclare IDEAS.Buildings.Validation.BaseClasses.InhomeFeeder.None
      inhomeGrid,
    redeclare IDEAS.Buildings.Validation.BaseClasses.VentilationSystem.None
      ventilationSystem)
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Interfaces.Building case920(redeclare
      IDEAS.Buildings.Validation.BaseClasses.Structure.Bui620  building,
      redeclare IDEAS.Buildings.Validation.BaseClasses.Occupant.Gain  occupant,
    redeclare IDEAS.Buildings.Validation.BaseClasses.InhomeFeeder.None inhomeGrid,
    redeclare IDEAS.Buildings.Validation.BaseClasses.VentilationSystem.None
      ventilationSystem,
    redeclare IDEAS.Buildings.Validation.BaseClasses.HeatingSystem.Deadband
      heatingSystem)
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));
  Interfaces.Building case940(redeclare
      IDEAS.Buildings.Validation.BaseClasses.Structure.Bui900  building,
      redeclare IDEAS.Buildings.Validation.BaseClasses.Occupant.Gain  occupant,
    redeclare IDEAS.Buildings.Validation.BaseClasses.InhomeFeeder.None inhomeGrid,
    redeclare IDEAS.Buildings.Validation.BaseClasses.VentilationSystem.None
      ventilationSystem,
    redeclare
      IDEAS.Buildings.Validation.BaseClasses.HeatingSystem.ThermostatSetback
      heatingSystem)
    annotation (Placement(transformation(extent={{20,40},{40,60}})));
  Interfaces.Building case950(redeclare
      IDEAS.Buildings.Validation.BaseClasses.Structure.Bui900  building,
      redeclare IDEAS.Buildings.Validation.BaseClasses.Occupant.Gain  occupant,
    redeclare IDEAS.Buildings.Validation.BaseClasses.InhomeFeeder.None inhomeGrid,
    redeclare
      IDEAS.Buildings.Validation.BaseClasses.VentilationSystem.NightVentilation
      ventilationSystem,
    redeclare IDEAS.Buildings.Validation.BaseClasses.HeatingSystem.Deadband
      heatingSystem)
    annotation (Placement(transformation(extent={{40,40},{60,60}})));
  Interfaces.Building case950FF(
      redeclare IDEAS.Buildings.Validation.BaseClasses.Occupant.Gain  occupant,
    redeclare IDEAS.Buildings.Validation.BaseClasses.Structure.Bui900 building,
    redeclare IDEAS.Buildings.Validation.BaseClasses.HeatingSystem.None heatingSystem,
    redeclare IDEAS.Buildings.Validation.BaseClasses.InhomeFeeder.None inhomeGrid,
    redeclare
      IDEAS.Buildings.Validation.BaseClasses.VentilationSystem.NightVentilation
      ventilationSystem)
    annotation (Placement(transformation(extent={{60,40},{80,60}})));
  Interfaces.Building case610(
      redeclare IDEAS.Buildings.Validation.BaseClasses.Occupant.Gain  occupant,
    redeclare IDEAS.Buildings.Validation.BaseClasses.InhomeFeeder.None inhomeGrid,
    redeclare IDEAS.Buildings.Validation.BaseClasses.Structure.Bui610 building,
    redeclare IDEAS.Buildings.Validation.BaseClasses.VentilationSystem.None
      ventilationSystem,
    redeclare IDEAS.Buildings.Validation.BaseClasses.HeatingSystem.Deadband
      heatingSystem)
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
  Interfaces.Building case910(
      redeclare IDEAS.Buildings.Validation.BaseClasses.Occupant.Gain  occupant,
    redeclare IDEAS.Buildings.Validation.BaseClasses.InhomeFeeder.None inhomeGrid,
    redeclare IDEAS.Buildings.Validation.BaseClasses.Structure.Bui910 building,
    redeclare IDEAS.Buildings.Validation.BaseClasses.VentilationSystem.None
      ventilationSystem,
    redeclare IDEAS.Buildings.Validation.BaseClasses.HeatingSystem.Deadband
      heatingSystem)
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Interfaces.Building case630(
      redeclare IDEAS.Buildings.Validation.BaseClasses.Occupant.Gain  occupant,
    redeclare IDEAS.Buildings.Validation.BaseClasses.InhomeFeeder.None inhomeGrid,
    redeclare IDEAS.Buildings.Validation.BaseClasses.Structure.Bui630 building,
    redeclare IDEAS.Buildings.Validation.BaseClasses.VentilationSystem.None
      ventilationSystem,
    redeclare IDEAS.Buildings.Validation.BaseClasses.HeatingSystem.Deadband
      heatingSystem)
    annotation (Placement(transformation(extent={{0,60},{20,80}})));
  Interfaces.Building case930(
      redeclare IDEAS.Buildings.Validation.BaseClasses.Occupant.Gain  occupant,
    redeclare IDEAS.Buildings.Validation.BaseClasses.InhomeFeeder.None inhomeGrid,
    redeclare IDEAS.Buildings.Validation.BaseClasses.Structure.Bui930 building,
    redeclare IDEAS.Buildings.Validation.BaseClasses.VentilationSystem.None
      ventilationSystem,
    redeclare IDEAS.Buildings.Validation.BaseClasses.HeatingSystem.Deadband
      heatingSystem)
    annotation (Placement(transformation(extent={{0,40},{20,60}})));
end BESTEST;

within IDEAS.Buildings.Validation.BesTest;
model Case600 "Case 600 of the ANSI/ASHRAE Standard 140-2007"

  inner Climate.SimInfoManager sim(redeclare IDEAS.Climate.Meteo.Files.min60
      detail, redeclare IDEAS.Climate.Meteo.Locations.BesTest city)
    annotation (Placement(transformation(extent={{-90,80},{-80,90}})));
  Interfaces.Building building(redeclare
      IDEAS.Buildings.Validation.BaseClasses.Bui600 building, redeclare
      IDEAS.Buildings.Validation.BaseClasses.Deadband heatingSystem)
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
equation

      annotation (experiment(StopTime=3.1536e+007, Interval=120),
          __Dymola_experimentSetupOutput(derivatives=false, events=false),
    Diagram(graphics));
end Case600;

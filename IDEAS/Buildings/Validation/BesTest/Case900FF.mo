within IDEAS.Buildings.Validation.BesTest;
model Case900FF "Case 900 of the ANSI/ASHRAE Standard 140-2007"

  inner Commons.SimInfoManager sim(redeclare Commons.Meteo.Files.min60 detail,
    redeclare Commons.Meteo.Locations.BesTest city);
  //Building model
  BWFlib.BesTest.Cases.bui900 bui;

      annotation (experiment(StopTime=3.1536e+007, Interval=120),
          __Dymola_experimentSetupOutput(derivatives=false, events=false));
end Case900FF;

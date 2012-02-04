within IDEAS.Buildings.Validation.BesTest;
model Case600 "Case 600 of the ANSI/ASHRAE Standard 140-2007"

  inner IDEAS.Climate.SimInfoManager sim(redeclare Commons.Meteo.Files.min60 detail,
    redeclare Commons.Meteo.Locations.BesTest city);
  //Building model
  BWFlib.BesTest.Cases.bui600 bui;
  //Heating
  BWFlib.BesTest.Setpoint.Deadband heating( V=129.6, corrCV=0.822);

equation
  connect(heating.port_a,bui.zone.gainCon);

      annotation (experiment(StopTime=3.1536e+007, Interval=120),
          __Dymola_experimentSetupOutput(derivatives=false, events=false));
end Case600;

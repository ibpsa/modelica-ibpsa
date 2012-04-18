within IDEAS.Buildings.Validation.BesTest;
model Case950FF

  inner Commons.SimInfoManager sim(redeclare Commons.Meteo.Files.min60 detail,
    redeclare Commons.Meteo.Locations.BesTest city);
  //Building model
  BWFlib.BesTest.Cases.bui900 bui;
  //Ventilation
  BWFlib.BesTest.Setpoint.NightVentilation ventilation( V=129.6, corrCV=0.822);

equation
  connect(ventilation.port_a,bui.zone.gainCon);

      annotation (experiment(StopTime=3.1536e+007, Interval=120),
          __Dymola_experimentSetupOutput(derivatives=false, events=false));
end Case950FF;

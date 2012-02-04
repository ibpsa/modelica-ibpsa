within IDEAS.Buildings.Validation.BesTest;
model CaseTest

    IDEAS.Interfaces.Building building(redeclare BaseClasses.Bui600
                                                   building)
      annotation (Placement(transformation(extent={{-60,20},{-40,40}})));

    inner IDEAS.Climate.SimInfoManager sim(redeclare
      IDEAS.Climate.Meteo.Files.min60   detail, redeclare
      IDEAS.Climate.Meteo.Locations.BesTest   city)
      annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
end CaseTest;

within IDEAS.BaseClasses.Testers;
model Tester_RadSol

  IDEAS.Climate.Meteo.Solar.RadSol radSol(
    inc=34,
    azi=0,
    A=1) annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
  inner IDEAS.Climate.SimInfoManager sim(redeclare Climate.Meteo.Files.min15
                                detail, redeclare Climate.Meteo.Locations.Uccle
                                    city)
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
end Tester_RadSol;

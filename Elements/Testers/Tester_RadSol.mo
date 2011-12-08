within IDEAS.Elements.Testers;
model Tester_RadSol

  IDEAS.Elements.Meteo.Solar.RadSol radSol(
    inc=34,
    azi=0,
    A=1) annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
  inner IDEAS.SimInfoManager sim(redeclare IDEAS.Elements.Meteo.Files.min15 detail,
      redeclare IDEAS.Elements.Meteo.Locations.Uccle city)
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
end Tester_RadSol;

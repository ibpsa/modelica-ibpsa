within IDEAS.Buildings.Validation.BesTest;
model Case600 "Case 600 of the ANSI/ASHRAE Standard 140-2007"

  BaseClasses.Bui600 bui600
    annotation (Placement(transformation(extent={{-50,40},{-20,60}})));
  BaseClasses.Deadband deadband(VZones=bui600.VZones)
    annotation (Placement(transformation(extent={{0,40},{20,60}})));
  inner Climate.SimInfoManager sim(redeclare IDEAS.Climate.Meteo.Files.min60
      detail, redeclare IDEAS.Climate.Meteo.Locations.BesTest city)
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
equation

  connect(bui600.heatPortEmb, deadband.heatPortEmb)   annotation (Line(
      points={{-20,56},{0,56}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(bui600.heatPortCon, deadband.heatPortCon)   annotation (Line(
      points={{-20,52},{0,52}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(bui600.heatPortRad, deadband.heatPortRad)   annotation (Line(
      points={{-20,48},{0,48}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(bui600.TSensor, deadband.TSensor)   annotation (Line(
      points={{-19.4,44},{0.4,44}},
      color={0,0,127},
      smooth=Smooth.None));
      annotation (experiment(StopTime=3.1536e+007, Interval=120),
          __Dymola_experimentSetupOutput(derivatives=false, events=false),
    Diagram(graphics));
end Case600;

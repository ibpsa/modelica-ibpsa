within IDEAS.Electric.Examples;
model TestGridAndPVSystemGeneral
  "Test to see if Grid and PV(from file) work as it should"

  Distribution.GridGeneral gridGeneral(
    Phases=3,
    redeclare IDEAS.Electric.Data.Grids.TestGrid2Nodes grid,
    VSource=(230*1.02) + 0*MCM.j,
    traPre=true)
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  Photovoltaics.PVSystemGeneral pVSystemGeneral(numPha=3, redeclare
      IDEAS.Electric.Data.PvPanels.SanyoHIP230HDE1 pvPanel)
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  inner IDEAS.SimInfoManager sim(redeclare IDEAS.Climate.Meteo.Files.min10
      detail, redeclare IDEAS.Climate.Meteo.Locations.Uccle city)
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  BaseClasses.AC.Con3PlusNTo3 con3PlusNTo3_1 annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-20,42})));
equation
  connect(con3PlusNTo3_1.threeWire, pVSystemGeneral.pin) annotation (Line(
      points={{-20,52},{-20,74},{-39.8,74}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(con3PlusNTo3_1.fourWire, gridGeneral.gridNodes4L[:, 2]) annotation (
      Line(
      points={{-20,32},{-20,10},{-40,10}},
      color={85,170,255},
      smooth=Smooth.None));
  annotation (
    Diagram(graphics),
    experiment(
      StartTime=1.8144e+007,
      StopTime=1.93536e+007,
      Interval=600),
    __Dymola_experimentSetupOutput);
end TestGridAndPVSystemGeneral;

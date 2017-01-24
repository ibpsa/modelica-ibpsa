within IDEAS.Electric.Examples;
model TestGridAndPVFromFile
  "Test to see if Grid and PV(from file) work as it should"

  Distribution.GridGeneral gridGeneral(
    Phases=3,
    VSource=(230*1.02) + 0*MCM.j,
    traPre=true,
    redeclare IDEAS.Electric.Data.Grids.Ieee34_AL120 grid)
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  Photovoltaics.PvSystemGeneralFromFile pVFromFilePQ(numPha=3)
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  inner IDEAS.Electric.Photovoltaics.Components.ForInputFiles.PVProfileReader
    PV1 annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
equation
  connect(pVFromFilePQ.pin, gridGeneral.gridNodes3P[:, 2]) annotation (Line(
      points={{-39.8,74},{-30,74},{-30,10},{-40,10}},
      color={85,170,255},
      smooth=Smooth.None));
  annotation (
    Diagram(graphics),
    experiment(
      StartTime=1.8144e+007,
      StopTime=1.93536e+007,
      Interval=600),
    __Dymola_experimentSetupOutput);
end TestGridAndPVFromFile;

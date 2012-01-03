within IDEAS.Electric;
package Examples

  extends Modelica.Icons.ExamplesPackage;

  model TestGridAndPVFromFile
    "Test to see if Grid and PV(from file) work as it should"
    DistributionGrid.GridGeneral gridGeneral(
      Phases=3,
      redeclare IDEAS.Electric.Data.Grids.TestGrid2Nodes grid,
      VSource=(230*1.02) + 0*MCM.j,
      traPre=true,
      houCon=true)
      annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
    BaseClasses.WattsLaw wattsLaw(numPha=3) annotation (Placement(
          transformation(
          extent={{-10,-10},{10,10}},
          rotation=0,
          origin={-10,50})));
    Photovoltaic.PVFromFilePQ pVFromFilePQ
      annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
    inner Photovoltaic.Components.ForInputFiles.Read10minPV PV1
      annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  equation
    connect(wattsLaw.vi, gridGeneral.gridNodes3P[:, 2]) annotation (Line(
        points={{0,50},{20,50},{20,10},{-40,10}},
        color={85,170,255},
        smooth=Smooth.None));
    connect(pVFromFilePQ.pin, wattsLaw.vi) annotation (Line(
        points={{-40.2,74},{0,74},{0,50}},
        color={85,170,255},
        smooth=Smooth.None));
    connect(pVFromFilePQ.PQ[1], wattsLaw.P) annotation (Line(
        points={{-39.4,69.5},{-30,69.5},{-30,54},{-20,54}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(pVFromFilePQ.PQ[2], wattsLaw.Q) annotation (Line(
        points={{-39.4,70.5},{-36,70.5},{-36,48},{-20,48}},
        color={0,0,127},
        smooth=Smooth.None));
    annotation (
      Diagram(graphics),
      experiment(
        StartTime=1.8144e+007,
        StopTime=1.93536e+007,
        Interval=600),
      __Dymola_experimentSetupOutput);
  end TestGridAndPVFromFile;

  model TestGridAndPVSystemGeneral
    "Test to see if Grid and PV(from file) work as it should"
    DistributionGrid.GridGeneral gridGeneral(
      Phases=3,
      redeclare IDEAS.Electric.Data.Grids.TestGrid2Nodes grid,
      VSource=(230*1.02) + 0*MCM.j,
      traPre=true,
      houCon=true)
      annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
    Photovoltaic.PVSystemGeneral pVSystemGeneral(numPha=3, redeclare
        IDEAS.Electric.Data.PvPanels.SanyoHIP230HDE1 pvPanel)
      annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
    inner Climate.SimInfoManager sim(redeclare IDEAS.Climate.Meteo.Files.min10
        detail, redeclare IDEAS.Climate.Meteo.Locations.Uccle city)
      annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  equation
    connect(pVSystemGeneral.pin, gridGeneral.gridNodes3P[:, 2]) annotation (
        Line(
        points={{-39.8,74},{-20,74},{-20,10},{-40,10}},
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
end Examples;

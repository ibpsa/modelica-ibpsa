within IDEAS.Electric.Distribution.AC.Examples;
model TestGridGeneral3P
  import IDEAS;
  IDEAS.Electric.Distribution.AC.Examples.Components.SinePower risingflankSingle1[3](
      amplitude=4000)
    annotation (Placement(transformation(extent={{40,0},{60,20}})));

  IDEAS.Electric.Distribution.AC.Grid_3P grid3PGeneral(
    redeclare IDEAS.Electric.Data.Grids.TestGrid2Nodes grid,
    redeclare IDEAS.Electric.Data.TransformerImp.Transfo_250kVA transformer,
    traTCal=true)
    annotation (Placement(transformation(extent={{-36,0},{-16,20}})));
  inner IDEAS.SimInfoManager sim
    annotation (Placement(transformation(extent={{-92,74},{-72,94}})));
equation

  connect(grid3PGeneral.gridNodes3P[:, 2], risingflankSingle1.nodes)
    annotation (Line(
      points={{-16,10},{40,10}},
      color={85,170,255},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}),
            graphics),
    experiment(StopTime=1.2096e+006, Interval=600),
    __Dymola_experimentSetupOutput);
end TestGridGeneral3P;

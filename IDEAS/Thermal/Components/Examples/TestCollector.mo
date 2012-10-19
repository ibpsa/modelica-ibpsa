within IDEAS.Thermal.Components.Examples;
model TestCollector

  parameter Thermal.Data.Interfaces.Medium medium=Data.Media.Water();

  IDEAS.Thermal.Components.Production.CollectorG
                                       collectorG(
    medium=medium,
    h_g=2,
    ACol=5,
    nCol=2,
    T0=283.15)
    annotation (Placement(transformation(extent={{-84,-28},{-64,-8}})));
  IDEAS.Thermal.Components.BaseClasses.Pipe_HeatPort
                                            heatedPipe(medium=medium, m=5)
    annotation (Placement(transformation(extent={{-46,-28},{-26,-8}})));
  Thermal.Components.BaseClasses.Pump pump(
    medium=medium,
    m=0,
    useInput=true,
    m_flowNom=0.08)
    annotation (Placement(transformation(extent={{-10,-28},{10,-8}})));
  Thermal.Components.Storage.StorageTank storageTank(
    medium=medium,
    volumeTank=0.5,
    heightTank=2)
    annotation (Placement(transformation(extent={{54,-68},{74,-48}})));
  IDEAS.Thermal.Components.BaseClasses.Pipe_HeatPort
                                            heatedPipe1(medium=medium, m=5)
    annotation (Placement(transformation(extent={{-26,-78},{-46,-58}})));
  Thermal.Components.BaseClasses.AbsolutePressure absolutePressure(medium=
        medium, p=300000)
    annotation (Placement(transformation(extent={{6,6},{18,18}})));

  Thermal.Control.SolarThermalControl_DT solarThermalControl_DT(TSafetyMax=
        363.15)
    annotation (Placement(transformation(extent={{54,44},{34,64}})));
  inner IDEAS.SimInfoManager         sim(redeclare
      IDEAS.Climate.Meteo.Files.min5                                              detail,
      redeclare IDEAS.Climate.Meteo.Locations.Uccle city)
    annotation (Placement(transformation(extent={{-92,76},{-72,96}})));
equation
  solarThermalControl_DT.TTankBot = storageTank.nodes[5].T;
  solarThermalControl_DT.TSafety = storageTank.nodes[3].T;
  connect(collectorG.flowPort_b, heatedPipe.flowPort_a) annotation (Line(
      points={{-64,-18},{-46,-18}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(heatedPipe.flowPort_b, pump.flowPort_a) annotation (Line(
      points={{-26,-18},{-10,-18}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(pump.flowPort_b, storageTank.flowPorts[3]) annotation (Line(
      points={{10,-18},{34,-18},{34,-58.1667},{54,-58.1667}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(storageTank.flowPort_b, heatedPipe1.flowPort_a) annotation (Line(
      points={{64,-68},{-26,-68}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(heatedPipe1.flowPort_b, collectorG.flowPort_a) annotation (Line(
      points={{-46,-68},{-92,-68},{-92,-18},{-84,-18}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(absolutePressure.flowPort, pump.flowPort_a) annotation (Line(
      points={{6,12},{-10,12},{-10,-18}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(solarThermalControl_DT.onOff, pump.m_flowSet) annotation (Line(
      points={{33.4,56},{0,56},{0,-8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(collectorG.TCol, solarThermalControl_DT.TCollector) annotation (Line(
      points={{-63.6,-24},{-54,-24},{-54,80},{82,80},{82,54},{54.6,54}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(graphics));
end TestCollector;

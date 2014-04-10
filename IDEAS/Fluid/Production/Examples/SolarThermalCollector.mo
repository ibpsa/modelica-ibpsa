within IDEAS.Fluid.Production.Examples;
model SolarThermalCollector
  "Simple circuit with a solar thermal collector and storage tank"

  extends Modelica.Icons.Example;

  parameter Thermal.Data.Interfaces.Medium medium=Thermal.Data.Media.Water();

  IDEAS.Fluid.Production.SolarCollector_Glazed collectorG(
    medium=medium,
    h_g=2,
    ACol=5,
    nCol=2,
    T0=283.15)
    annotation (Placement(transformation(extent={{-84,-28},{-64,-8}})));
  IDEAS.Fluid.FixedResistances.Pipe_HeatPort heatedPipe(medium=medium, m=5)
    annotation (Placement(transformation(extent={{-46,-28},{-26,-8}})));
  Fluid.Movers.Pump pump(
    medium=medium,
    m=0,
    useInput=true,
    m_flowNom=0.08)
    annotation (Placement(transformation(extent={{-10,-28},{10,-8}})));
  Fluid.Storage.StorageTank storageTank(
    medium=medium,
    volumeTank=0.5,
    heightTank=2)
    annotation (Placement(transformation(extent={{74,-68},{54,-48}})));
  IDEAS.Fluid.FixedResistances.Pipe_HeatPort heatedPipe1(medium=medium, m=5)
    annotation (Placement(transformation(extent={{-26,-76},{-46,-56}})));
  Thermal.Components.BaseClasses.AbsolutePressure absolutePressure(medium=
        medium, p=300000)
    annotation (Placement(transformation(extent={{-22,4},{-34,16}})));

  Thermal.Control.Ctrl_SolarThermal_Simple solarThermalControl_DT(TSafetyMax=
        363.15) annotation (Placement(transformation(extent={{54,44},{34,64}})));
  inner IDEAS.SimInfoManager sim(redeclare IDEAS.Climate.Meteo.Locations.Uccle
      city, redeclare IDEAS.Climate.Meteo.Files.min60 detail)
    annotation (Placement(transformation(extent={{-92,76},{-72,96}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=
        293.15)
    annotation (Placement(transformation(extent={{6,-58},{16,-48}})));
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
      points={{10,-18},{34,-18},{34,-52.8671},{54,-52.8671}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(storageTank.flowPort_b, heatedPipe1.flowPort_a) annotation (Line(
      points={{54,-66.4615},{24,-66.4615},{24,-66},{-26,-66}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(heatedPipe1.flowPort_b, collectorG.flowPort_a) annotation (Line(
      points={{-46,-66},{-92,-66},{-92,-18},{-84,-18}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(absolutePressure.flowPort, pump.flowPort_a) annotation (Line(
      points={{-22,10},{-10,10},{-10,-18}},
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
  connect(fixedTemperature.port, storageTank.heatExchEnv) annotation (Line(
      points={{16,-53},{20,-53},{20,-54},{28,-54},{28,-58.7692},{57.3333,
          -58.7692}},
      color={191,0,0},
      smooth=Smooth.None));

  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}), graphics),
    experiment(StopTime=604800, Interval=900),
    __Dymola_experimentSetupOutput);
end SolarThermalCollector;

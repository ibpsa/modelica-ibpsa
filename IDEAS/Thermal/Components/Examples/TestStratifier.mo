within IDEAS.Thermal.Components.Examples;
model TestStratifier
  parameter Thermal.Data.Interfaces.Medium medium=Data.Media.Water()
    "Medium in the tank";
  //parameter Real[5] TInitial =

  Thermal.Components.Storage.StorageTank storageTank(
    medium=medium,
    nbrNodes=5,
    heightTank=2,
    TInitial=340:-10:300,
    volumeTank=0.2)
    annotation (Placement(transformation(extent={{-2,12},{18,32}})));
  Thermal.Components.Storage.StratifiedInlet stratifiedInlet(
    medium=medium,
    nbrNodes=5,
    TNodes=storageTank.nodes.T)
    annotation (Placement(transformation(extent={{-58,12},{-38,32}})));
  Thermal.Components.BaseClasses.AbsolutePressure absolutePressure(medium=
        medium, p=200000)
    annotation (Placement(transformation(extent={{28,-12},{48,8}})));
  Thermal.Components.BaseClasses.Pump pump(
    medium=medium,
    m=1,
    m_flowNom=0.05,
    useInput=true)
    annotation (Placement(transformation(extent={{-14,-22},{-34,-2}})));
  IDEAS.Thermal.Components.BaseClasses.Pipe_HeatPort
                                            heatedPipe(
    medium=medium,
    m=2,
    TInitial=278.15)
    annotation (Placement(transformation(extent={{-78,-22},{-58,-2}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow(Q_flow=1000)
    annotation (Placement(transformation(extent={{-100,-54},{-80,-34}})));
  Modelica.Blocks.Sources.Pulse pulse(period=300)
    annotation (Placement(transformation(extent={{-46,-66},{-26,-46}})));
equation
  connect(storageTank.flowPort_b, pump.flowPort_a) annotation (Line(
      points={{8,12},{8,-12},{-14,-12}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(pump.flowPort_b, heatedPipe.flowPort_b) annotation (Line(
      points={{-34,-12},{-58,-12}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(heatedPipe.flowPort_a, stratifiedInlet.flowPort_a) annotation (Line(
      points={{-78,-12},{-88,-12},{-88,22},{-58,22}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(stratifiedInlet.flowPorts, storageTank.flowPorts) annotation (Line(
      points={{-38,22},{-2,22}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(absolutePressure.flowPort, storageTank.flowPort_b) annotation (Line(
      points={{28,-2},{8,-2},{8,12}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(fixedHeatFlow.port, heatedPipe.heatPort) annotation (Line(
      points={{-80,-44},{-68,-44},{-68,-22}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(pulse.y, pump.m_flowSet) annotation (Line(
      points={{-25,-56},{-8,-56},{-8,8},{-24,8},{-24,-2}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(graphics));
end TestStratifier;

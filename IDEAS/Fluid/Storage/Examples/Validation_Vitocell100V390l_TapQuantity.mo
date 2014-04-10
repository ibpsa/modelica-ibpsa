within IDEAS.Fluid.Storage.Examples;
model Validation_Vitocell100V390l_TapQuantity
  "Check the tap quantity for a hot tank as function of number of nodes"
  import IDEAS;

  extends Modelica.Icons.Example;

  SI.Temperature TOut5Nodes=storageTank.nodes[1].T;
  SI.Temperature TOut10Nodes=storageTank1.nodes[1].T;
  SI.Temperature TOut20Nodes=storageTank2.nodes[1].T;
  SI.Temperature TOut40Nodes=storageTank3.nodes[1].T;
  SI.Temperature TOut80Nodes=storageTank4.nodes[1].T;

  SI.Volume mFlow_Int(start=0);

  StorageTank_OneIntHX storageTank(
    medium=IDEAS.Thermal.Data.Media.Water(),
    mediumHX=IDEAS.Thermal.Data.Media.Water(),
    UIns=0.4,
    UACon=1.61,
    preventNaturalDestratification=true,
    volumeTank=0.39,
    heightTank=1.4,
    TInitial={273.15 + 55 for i in 1:storageTank.nbrNodes},
    nbrNodes=5)
    annotation (Placement(transformation(extent={{-58,14},{-38,34}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=
        293.15) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={126,-12})));
  Thermal.Components.BaseClasses.AbsolutePressure absolutePressure(medium=
        IDEAS.Thermal.Data.Media.Water(),
                            p=200000)
    annotation (Placement(transformation(extent={{-78,70},{-58,92}})));

  IDEAS.Thermal.Components.BaseClasses.Ambient1 ambient(
    medium=IDEAS.Thermal.Data.Media.Water(),
    constantAmbientPressure=300000,
    constantAmbientTemperature=283.15)
    annotation (Placement(transformation(extent={{36,-96},{56,-76}})));
  IDEAS.Fluid.Movers.Pump pump(
    medium=IDEAS.Thermal.Data.Media.Water(),
    m=0,
    TInitial=283.15,
    m_flowNom=15/60,
    etaTot=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-48,-50})));
  IDEAS.Thermal.Components.BaseClasses.Ambient1 ambient1(
    medium=IDEAS.Thermal.Data.Media.Water(),
    constantAmbientPressure=300000,
    constantAmbientTemperature=283.15) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={12,90})));
  StorageTank_OneIntHX storageTank1(
    medium=IDEAS.Thermal.Data.Media.Water(),
    mediumHX=IDEAS.Thermal.Data.Media.Water(),
    UIns=0.4,
    UACon=1.61,
    preventNaturalDestratification=true,
    volumeTank=0.39,
    heightTank=1.4,
    TInitial={273.15 + 55 for i in 1:storageTank1.nbrNodes},
    nbrNodes=10)
    annotation (Placement(transformation(extent={{-24,14},{-4,34}})));
  StorageTank_OneIntHX storageTank2(
    medium=IDEAS.Thermal.Data.Media.Water(),
    mediumHX=IDEAS.Thermal.Data.Media.Water(),
    UIns=0.4,
    UACon=1.61,
    preventNaturalDestratification=true,
    volumeTank=0.39,
    heightTank=1.4,
    TInitial={273.15 + 55 for i in 1:storageTank2.nbrNodes},
    nbrNodes=20)
    annotation (Placement(transformation(extent={{12,14},{32,34}})));
  StorageTank_OneIntHX storageTank3(
    medium=IDEAS.Thermal.Data.Media.Water(),
    mediumHX=IDEAS.Thermal.Data.Media.Water(),
    UIns=0.4,
    UACon=1.61,
    preventNaturalDestratification=true,
    volumeTank=0.39,
    heightTank=1.4,
    TInitial={273.15 + 55 for i in 1:storageTank3.nbrNodes},
    nbrNodes=40)
    annotation (Placement(transformation(extent={{46,14},{66,34}})));
  StorageTank_OneIntHX storageTank4(
    medium=IDEAS.Thermal.Data.Media.Water(),
    mediumHX=IDEAS.Thermal.Data.Media.Water(),
    UIns=0.4,
    UACon=1.61,
    preventNaturalDestratification=true,
    volumeTank=0.39,
    heightTank=1.4,
    TInitial={273.15 + 55 for i in 1:storageTank4.nbrNodes},
    nbrNodes=80)
    annotation (Placement(transformation(extent={{76,14},{96,34}})));
  IDEAS.Fluid.Movers.Pump pump1(
    medium=IDEAS.Thermal.Data.Media.Water(),
    m=0,
    TInitial=283.15,
    m_flowNom=15/60,
    etaTot=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={58,-50})));
  IDEAS.Fluid.Movers.Pump pump2(
    medium=IDEAS.Thermal.Data.Media.Water(),
    m=0,
    TInitial=283.15,
    m_flowNom=15/60,
    etaTot=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={22,-50})));
  IDEAS.Fluid.Movers.Pump pump3(
    medium=IDEAS.Thermal.Data.Media.Water(),
    m=0,
    TInitial=283.15,
    m_flowNom=15/60,
    etaTot=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-14,-50})));
  IDEAS.Fluid.Movers.Pump pump4(
    medium=IDEAS.Thermal.Data.Media.Water(),
    m=0,
    TInitial=283.15,
    m_flowNom=15/60,
    etaTot=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={94,-52})));
equation
  der(mFlow_Int) = pump.flowPort_a.m_flow/995.6;
  connect(absolutePressure.flowPort, storageTank.flowPortHXUpper) annotation (
      Line(
      points={{-78,81},{-80,81},{-80,20.1538},{-58,20.1538}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(pump.flowPort_b, storageTank.flowPort_b) annotation (Line(
      points={{-48,-40},{-48,-12.95},{-48,15.5385},{-38,15.5385}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(fixedTemperature.port, storageTank.heatExchEnv) annotation (Line(
      points={{116,-12},{-34,-12},{-34,23.2308},{-41.3333,23.2308}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(storageTank.flowPort_a, ambient1.flowPort) annotation (Line(
      points={{-38,32.4615},{-38,80},{12,80}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(pump3.flowPort_b, storageTank1.flowPort_b) annotation (Line(
      points={{-14,-40},{-14,-12.95},{-14,15.5385},{-4,15.5385}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(pump2.flowPort_b, storageTank2.flowPort_b) annotation (Line(
      points={{22,-40},{22,-12.95},{22,15.5385},{32,15.5385}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(pump1.flowPort_b, storageTank3.flowPort_b) annotation (Line(
      points={{58,-40},{58,15.5385},{66,15.5385}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(pump4.flowPort_b, storageTank4.flowPort_b) annotation (Line(
      points={{94,-42},{90,-42},{90,15.5385},{96,15.5385}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(ambient.flowPort, pump.flowPort_a) annotation (Line(
      points={{36,-86},{-48,-86},{-48,-60}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(ambient.flowPort, pump3.flowPort_a) annotation (Line(
      points={{36,-86},{8,-86},{8,-84},{-14,-84},{-14,-60}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(ambient.flowPort, pump2.flowPort_a) annotation (Line(
      points={{36,-86},{22,-86},{22,-60}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(ambient.flowPort, pump1.flowPort_a) annotation (Line(
      points={{36,-86},{36,-72},{60,-72},{60,-60},{58,-60}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(ambient.flowPort, pump4.flowPort_a) annotation (Line(
      points={{36,-86},{36,-72},{94,-72},{94,-62}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(fixedTemperature.port, storageTank1.heatExchEnv) annotation (Line(
      points={{116,-12},{60,-12},{60,-10},{0,-10},{0,23.2308},{-7.33333,23.2308}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(fixedTemperature.port, storageTank2.heatExchEnv) annotation (Line(
      points={{116,-12},{38,-12},{38,23.2308},{28.6667,23.2308}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(fixedTemperature.port, storageTank3.heatExchEnv) annotation (Line(
      points={{116,-12},{96,-12},{96,-10},{68,-10},{68,23.2308},{62.6667,
          23.2308}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(fixedTemperature.port, storageTank4.heatExchEnv) annotation (Line(
      points={{116,-12},{112,-12},{112,-10},{98,-10},{98,23.2308},{92.6667,
          23.2308}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(absolutePressure.flowPort, storageTank1.flowPortHXUpper) annotation (
      Line(
      points={{-78,81},{-80,81},{-80,46},{-30,46},{-30,20.1538},{-24,20.1538}},
      color={255,0,0},
      smooth=Smooth.None));

  connect(absolutePressure.flowPort, storageTank2.flowPortHXUpper) annotation (
      Line(
      points={{-78,81},{-80,81},{-80,46},{8,46},{8,20.1538},{12,20.1538}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(absolutePressure.flowPort, storageTank3.flowPortHXUpper) annotation (
      Line(
      points={{-78,81},{-80,81},{-80,46},{42,46},{42,20.1538},{46,20.1538}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(absolutePressure.flowPort, storageTank4.flowPortHXUpper) annotation (
      Line(
      points={{-78,81},{-80,81},{-80,46},{72,46},{72,20.1538},{76,20.1538}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(storageTank1.flowPort_a, ambient1.flowPort) annotation (Line(
      points={{-4,32.4615},{-4,80},{12,80}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(storageTank2.flowPort_a, ambient1.flowPort) annotation (Line(
      points={{32,32.4615},{20,32.4615},{20,80},{12,80}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(storageTank3.flowPort_a, ambient1.flowPort) annotation (Line(
      points={{66,32.4615},{54,32.4615},{54,80},{12,80}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(storageTank4.flowPort_a, ambient1.flowPort) annotation (Line(
      points={{96,32.4615},{84,32.4615},{84,80},{12,80}},
      color={255,0,0},
      smooth=Smooth.None));
  annotation (
    Diagram(graphics),
    experiment(StopTime=2000, Interval=10),
    __Dymola_experimentSetupOutput);
end Validation_Vitocell100V390l_TapQuantity;

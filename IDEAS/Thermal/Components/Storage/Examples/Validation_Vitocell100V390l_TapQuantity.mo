within IDEAS.Thermal.Components.Storage.Examples;
model Validation_Vitocell100V390l_TapQuantity
  "Check the tap quantity for a hot tank"

  SI.Temperature TOut5Nodes=storageTank.nodes[1].T;
  SI.Temperature TOut10Nodes=storageTank1.nodes[1].T;
  SI.Temperature TOut20Nodes=storageTank2.nodes[1].T;
  SI.Temperature TOut40Nodes=storageTank3.nodes[1].T;
  SI.Temperature TOut80Nodes=storageTank4.nodes[1].T;

  SI.Volume mFlow_Int( start=0);

  StorageTank_OneIntHX                   storageTank(
    medium=Data.Media.Water(),
    mediumHX=Data.Media.Water(),
    UIns=0.4,
    UACon=1.61,
    preventNaturalDestratification=true,
    volumeTank=0.39,
    heightTank=1.4,
    lamBuo=1000,
    TInitial={273.15 + 55 for i in 1:storageTank.nbrNodes},
    nbrNodes=5)
    annotation (Placement(transformation(extent={{-58,14},{-38,34}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=293.15)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=180,
        origin={126,-12})));
  Thermal.Components.BaseClasses.AbsolutePressure absolutePressure(medium=
        Data.Media.Water(), p=200000)
    annotation (Placement(transformation(extent={{-78,70},{-58,92}})));

  BaseClasses.Ambient ambient(medium=IDEAS.Thermal.Data.Media.Water(),constantAmbientPressure=300000,
      constantAmbientTemperature=283.15)
    annotation (Placement(transformation(extent={{36,-96},{56,-76}})));
  BaseClasses.Pump pump(
    medium=IDEAS.Thermal.Data.Media.Water(),
    m=0,
    TInitial=283.15,
    m_flowNom=15/60,
    etaTot=1)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-48,-50})));
  BaseClasses.Ambient ambient1(
                              medium=IDEAS.Thermal.Data.Media.Water(),constantAmbientPressure=300000,
      constantAmbientTemperature=283.15)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={12,90})));
  StorageTank_OneIntHX                   storageTank1(
    medium=Data.Media.Water(),
    mediumHX=Data.Media.Water(),
    UIns=0.4,
    UACon=1.61,
    preventNaturalDestratification=true,
    volumeTank=0.39,
    heightTank=1.4,
    lamBuo=1000,
    TInitial={273.15 + 55 for i in 1:storageTank1.nbrNodes},
    nbrNodes=10)
    annotation (Placement(transformation(extent={{-24,14},{-4,34}})));
  StorageTank_OneIntHX                   storageTank2(
    medium=Data.Media.Water(),
    mediumHX=Data.Media.Water(),
    UIns=0.4,
    UACon=1.61,
    preventNaturalDestratification=true,
    volumeTank=0.39,
    heightTank=1.4,
    lamBuo=1000,
    TInitial={273.15 + 55 for i in 1:storageTank2.nbrNodes},
    nbrNodes=20)
    annotation (Placement(transformation(extent={{12,14},{32,34}})));
  StorageTank_OneIntHX                   storageTank3(
    medium=Data.Media.Water(),
    mediumHX=Data.Media.Water(),
    UIns=0.4,
    UACon=1.61,
    preventNaturalDestratification=true,
    volumeTank=0.39,
    heightTank=1.4,
    lamBuo=1000,
    TInitial={273.15 + 55 for i in 1:storageTank3.nbrNodes},
    nbrNodes=40)
    annotation (Placement(transformation(extent={{46,14},{66,34}})));
  StorageTank_OneIntHX                   storageTank4(
    medium=Data.Media.Water(),
    mediumHX=Data.Media.Water(),
    UIns=0.4,
    UACon=1.61,
    preventNaturalDestratification=true,
    volumeTank=0.39,
    heightTank=1.4,
    lamBuo=1000,
    TInitial={273.15 + 55 for i in 1:storageTank4.nbrNodes},
    nbrNodes=80)
    annotation (Placement(transformation(extent={{76,14},{96,34}})));
  BaseClasses.Pump pump1(
    medium=IDEAS.Thermal.Data.Media.Water(),
    m=0,
    TInitial=283.15,
    m_flowNom=15/60,
    etaTot=1)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={58,-50})));
  BaseClasses.Pump pump2(
    medium=IDEAS.Thermal.Data.Media.Water(),
    m=0,
    TInitial=283.15,
    m_flowNom=15/60,
    etaTot=1)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={22,-50})));
  BaseClasses.Pump pump3(
    medium=IDEAS.Thermal.Data.Media.Water(),
    m=0,
    TInitial=283.15,
    m_flowNom=15/60,
    etaTot=1)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-14,-50})));
  BaseClasses.Pump pump4(
    medium=IDEAS.Thermal.Data.Media.Water(),
    m=0,
    TInitial=283.15,
    m_flowNom=15/60,
    etaTot=1)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={94,-52})));
equation
  der(mFlow_Int)=pump.flowPort_a.m_flow / 995.6;
  connect(absolutePressure.flowPort, storageTank.flowPortHXUpper) annotation (
      Line(
      points={{-78,81},{-80,81},{-80,26.1},{-58.1,26.1}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(pump.flowPort_b, storageTank.flowPort_b) annotation (Line(
      points={{-48,-40},{-48,-12.95},{-48,14.1},{-48.1,14.1}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(fixedTemperature.port, storageTank.heatExchEnv) annotation (Line(
      points={{116,-12},{-34,-12},{-34,24},{-41.6,24}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(storageTank.flowPort_a, ambient1.flowPort) annotation (Line(
      points={{-48.1,33.9},{-48.1,80},{12,80}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(pump3.flowPort_b, storageTank1.flowPort_b) annotation (Line(
      points={{-14,-40},{-14,-12.95},{-14,14.1},{-14.1,14.1}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(pump2.flowPort_b, storageTank2.flowPort_b) annotation (Line(
      points={{22,-40},{22,-12.95},{22,14.1},{21.9,14.1}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(pump1.flowPort_b, storageTank3.flowPort_b) annotation (Line(
      points={{58,-40},{58,14.1},{55.9,14.1}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(pump4.flowPort_b, storageTank4.flowPort_b) annotation (Line(
      points={{94,-42},{90,-42},{90,14.1},{85.9,14.1}},
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
      points={{116,-12},{60,-12},{60,-10},{0,-10},{0,24},{-7.6,24}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(fixedTemperature.port, storageTank2.heatExchEnv) annotation (Line(
      points={{116,-12},{38,-12},{38,24},{28.4,24}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(fixedTemperature.port, storageTank3.heatExchEnv) annotation (Line(
      points={{116,-12},{96,-12},{96,-10},{68,-10},{68,24},{62.4,24}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(fixedTemperature.port, storageTank4.heatExchEnv) annotation (Line(
      points={{116,-12},{112,-12},{112,-10},{98,-10},{98,24},{92.4,24}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(absolutePressure.flowPort, storageTank1.flowPortHXUpper) annotation (
      Line(
      points={{-78,81},{-80,81},{-80,46},{-30,46},{-30,26.1},{-24.1,26.1}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(absolutePressure.flowPort, storageTank2.flowPortHXUpper) annotation (
      Line(
      points={{-78,81},{-80,81},{-80,46},{8,46},{8,26.1},{11.9,26.1}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(absolutePressure.flowPort, storageTank3.flowPortHXUpper) annotation (
      Line(
      points={{-78,81},{-80,81},{-80,46},{42,46},{42,26.1},{45.9,26.1}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(absolutePressure.flowPort, storageTank4.flowPortHXUpper) annotation (
      Line(
      points={{-78,81},{-80,81},{-80,46},{72,46},{72,26.1},{75.9,26.1}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(storageTank1.flowPort_a, ambient1.flowPort) annotation (Line(
      points={{-14.1,33.9},{-14.1,80},{12,80}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(storageTank2.flowPort_a, ambient1.flowPort) annotation (Line(
      points={{21.9,33.9},{20,33.9},{20,80},{12,80}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(storageTank3.flowPort_a, ambient1.flowPort) annotation (Line(
      points={{55.9,33.9},{54,33.9},{54,80},{12,80}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(storageTank4.flowPort_a, ambient1.flowPort) annotation (Line(
      points={{85.9,33.9},{84,33.9},{84,80},{12,80}},
      color={255,0,0},
      smooth=Smooth.None));
  annotation (Diagram(graphics),
    experiment(
      StopTime=2000,
      Interval=10,
      Algorithm="Lsodar"),
    __Dymola_experimentSetupOutput);
end Validation_Vitocell100V390l_TapQuantity;

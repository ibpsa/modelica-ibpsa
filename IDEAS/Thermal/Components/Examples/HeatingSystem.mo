within IDEAS.Thermal.Components.Examples;
model HeatingSystem

  Thermal.Components.BaseClasses.AbsolutePressure absolutePressure(medium=
        Data.Media.Water(), p=200000)
    annotation (Placement(transformation(extent={{-88,40},{-68,60}})));
  Thermal.Components.BaseClasses.Pump pump1(
    medium=Data.Media.Water(),
    useInput=true,
    m_flowNom=0.048,
    m=0)
    annotation (Placement(transformation(extent={{-8,8},{12,28}})));
  IDEAS.Thermal.Components.Production.HP_AWMod
                      HP(
   medium=Data.Media.Water(),
   TSet = 45+273.15,
    QNom=5000) annotation (Placement(transformation(extent={{-54,8},{-34,28}})));
  inner IDEAS.Climate.SimInfoManager sim(redeclare
      IDEAS.Climate.Meteo.Files.min15
      detail, redeclare IDEAS.Climate.Meteo.Locations.Uccle city)
    annotation (Placement(transformation(extent={{-84,68},{-64,88}})));
  Thermal.Components.BaseClasses.Pump pump2(
    medium=Data.Media.Water(),
    useInput=true,
    m_flowNom=0.048,
    m=0)
    annotation (Placement(transformation(extent={{-6,-52},{14,-32}})));
  IDEAS.Thermal.Components.Emission.Radiator_Old
                      radiator(medium=Data.Media.Water())
    annotation (Placement(transformation(extent={{34,8},{54,28}})));
  IDEAS.Thermal.Components.Emission.Radiator_Old
                      radiator1(
    medium=Data.Media.Water(),
    QNom=2000)
    annotation (Placement(transformation(extent={{34,-52},{54,-32}})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor heatCapacitor(C=1e5)
    annotation (Placement(transformation(extent={{32,54},{52,74}})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor heatCapacitor1(C=1e5)
    annotation (Placement(transformation(extent={{34,-18},{54,2}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature TAmb1
    annotation (Placement(transformation(extent={{138,42},{118,62}})));
  Modelica.Thermal.HeatTransfer.Components.Convection convection1
    annotation (Placement(transformation(extent={{80,42},{100,62}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature TAmb2
    annotation (Placement(transformation(extent={{140,-26},{120,-6}})));
  Modelica.Thermal.HeatTransfer.Components.Convection convection2
    annotation (Placement(transformation(extent={{82,-26},{102,-6}})));
  Modelica.Blocks.Sources.Pulse[2] TOpSet(
    each width=67,
    each startTime=3600*7,
    each offset=0,
    period={86400,86400},
    each amplitude=1)
    annotation (Placement(transformation(extent={{-48,60},{-28,80}})));
equation
   TAmb1.T = sim.Te;
   convection1.Gc = 100;
      TAmb2.T = sim.Te;
   convection2.Gc = 200;
  connect(HP.flowPort_b, pump1.flowPort_a)       annotation (Line(
      points={{-34,18},{-8,18}},
      color={255,0,0},
      thickness=0.5,
      smooth=Smooth.None));
  connect(HP.flowPort_b, pump2.flowPort_a)       annotation (Line(
      points={{-34,18},{-20,18},{-20,-42},{-6,-42}},
      color={255,0,0},
      thickness=0.5,
      smooth=Smooth.None));
  connect(pump1.flowPort_b, radiator.flowPort_a)       annotation (Line(
      points={{12,18},{34,18}},
      color={255,0,0},
      thickness=0.5,
      smooth=Smooth.None));
  connect(radiator.flowPort_b, HP.flowPort_a) annotation (Line(
      points={{54,18},{70,18},{70,-80},{-70,-80},{-70,18},{-54,18}},
      color={255,0,0},
      thickness=0.5,
      smooth=Smooth.None));
  connect(pump2.flowPort_b, radiator1.flowPort_a)       annotation (Line(
      points={{14,-42},{34,-42}},
      color={255,0,0},
      thickness=0.5,
      smooth=Smooth.None));
  connect(radiator1.flowPort_b, HP.flowPort_a) annotation (Line(
      points={{54,-42},{60,-42},{60,-72},{-54,-72},{-54,18}},
      color={255,0,0},
      thickness=0.5,
      smooth=Smooth.None));
  connect(heatCapacitor.port, radiator.heatPortConv) annotation (Line(
      points={{42,54},{42,28},{41,28}},
      color={191,0,0},
      thickness=0.5,
      smooth=Smooth.None));
  connect(heatCapacitor.port, radiator.heatPortRad) annotation (Line(
      points={{42,54},{46,54},{46,28},{49,28}},
      color={191,0,0},
      thickness=0.5,
      smooth=Smooth.None));
  connect(radiator1.heatPortConv, heatCapacitor1.port) annotation (Line(
      points={{41,-32},{42,-32},{42,-18},{44,-18}},
      color={191,0,0},
      thickness=0.5,
      smooth=Smooth.None));
  connect(radiator1.heatPortRad, heatCapacitor1.port) annotation (Line(
      points={{49,-32},{49,-26},{44,-26},{44,-18}},
      color={191,0,0},
      thickness=0.5,
      smooth=Smooth.None));
  connect(convection1.fluid, TAmb1.port)
                                       annotation (Line(
      points={{100,52},{118,52}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(convection2.fluid, TAmb2.port)
                                       annotation (Line(
      points={{102,-16},{120,-16}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(convection2.solid, heatCapacitor1.port) annotation (Line(
      points={{82,-16},{64,-16},{64,-18},{44,-18}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(convection1.solid, heatCapacitor.port) annotation (Line(
      points={{80,52},{62,52},{62,54},{42,54}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TOpSet[1].y, pump1.m_flowSet) annotation (Line(
      points={{-27,70},{-14,70},{-14,68},{2,68},{2,28}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TOpSet[2].y, pump2.m_flowSet) annotation (Line(
      points={{-27,70},{-18,70},{-18,-32},{4,-32}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(absolutePressure.flowPort, HP.flowPort_a) annotation (Line(
      points={{-88,50},{-88,18},{-54,18}},
      color={255,0,0},
      smooth=Smooth.None));
  annotation (Diagram(graphics));
end HeatingSystem;

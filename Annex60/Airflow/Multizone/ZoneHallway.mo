within Annex60.Airflow.Multizone;
model ZoneHallway
  "Zone representing a hallway connecting multiple SimpleZone models"

  parameter Modelica.SIunits.Temperature TRoom = 293.15
    "Indoor air temperature of room in K";
  parameter Modelica.SIunits.Height heightRoom = 3 "Height of room in m";
  parameter Modelica.SIunits.Length lengthRoom = 5 "Length of room in m";
  parameter Modelica.SIunits.Length widthRoom = 3 "Width of room in m";

  replaceable package Medium = Modelica.Media.Air.SimpleAir;

  Fluid.MixingVolumes.MixingVolume volumeHall(
    redeclare package Medium = Medium,
    m_flow_nominal=0.001,
    V=heightRoom*lengthRoom*widthRoom,
    nPorts=8,
    T_start=TRoom,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Air volume of hallway element"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature TAir(T=TRoom)
    "Fixed air temperature for room"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor conRoom(G=1E9)
    "Thermal conductor between fixed T and Volume"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  MediumColumn col(
    redeclare package Medium = Medium,
    h=heightRoom/2,
    densitySelection=Annex60.Airflow.Multizone.Types.densitySelection.fromTop)
    annotation (Placement(transformation(extent={{50,-40},{70,-20}})));
  MediumColumn col1(
    redeclare package Medium = Medium,
    h=heightRoom/2,
    densitySelection=Annex60.Airflow.Multizone.Types.densitySelection.fromBottom)
    annotation (Placement(transformation(extent={{50,20},{70,40}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{-110,50},{-90,70}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{-110,-70},{-90,-50}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a1(redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{90,50},{110,70}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b1(redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{90,-70},{110,-50}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a2(redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{-70,-110},{-50,-90}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a3(redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{-70,90},{-50,110}})));
  Orifice oriOutTop(redeclare package Medium = Medium, A=0.01)
    annotation (Placement(transformation(extent={{68,50},{88,70}})));
  Orifice oriOutBottom(redeclare package Medium = Medium, A=0.01)
    annotation (Placement(transformation(extent={{68,-70},{88,-50}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b2(redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{50,-110},{70,-90}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b3(redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{50,90},{70,110}})));
  MediumColumn col2(
    redeclare package Medium = Medium,
    densitySelection=Annex60.Airflow.Multizone.Types.densitySelection.fromBottom,

    h=heightRoom/2) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-20,-60})));
  MediumColumn col3(
    redeclare package Medium = Medium,
    densitySelection=Annex60.Airflow.Multizone.Types.densitySelection.fromTop,
    h=heightRoom/2) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={20,-60})));
  Orifice ori(redeclare package Medium = Medium, A=widthRoom*heightRoom/2)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-40,-80})));
  Orifice ori1(redeclare package Medium = Medium, A=widthRoom*heightRoom/2)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={40,-80})));
equation
  connect(TAir.port, conRoom.port_a) annotation (Line(
      points={{-40,0},{-20,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conRoom.port_b, volumeHall.heatPort) annotation (Line(
      points={{0,0},{20,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(port_a, volumeHall.ports[1]) annotation (Line(
      points={{-100,60},{-80,60},{-80,-24},{24,-24},{26.5,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(port_b, volumeHall.ports[2]) annotation (Line(
      points={{-100,-60},{-80,-60},{-80,-28},{26,-28},{27.5,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(col.port_b, oriOutBottom.port_a) annotation (Line(
      points={{60,-40},{60,-60},{68,-60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(oriOutBottom.port_b, port_b1) annotation (Line(
      points={{88,-60},{100,-60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(col1.port_a, oriOutTop.port_a) annotation (Line(
      points={{60,40},{60,60},{68,60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(oriOutTop.port_b, port_a1) annotation (Line(
      points={{88,60},{100,60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(port_a2, port_a2) annotation (Line(
      points={{-60,-100},{-60,-100}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(ori.port_b, port_a2) annotation (Line(
      points={{-40,-90},{-40,-94},{-60,-100}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(ori1.port_b, port_b2) annotation (Line(
      points={{40,-90},{40,-92},{60,-100}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(ori.port_a, col2.port_a) annotation (Line(
      points={{-40,-70},{-40,-60},{-30,-60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(col3.port_b, ori1.port_a) annotation (Line(
      points={{30,-60},{40,-60},{40,-70}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(col2.port_b, volumeHall.ports[3]) annotation (Line(
      points={{-10,-60},{-6,-60},{-6,-30},{28,-30},{28.5,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(col3.port_a, volumeHall.ports[4]) annotation (Line(
      points={{10,-60},{2,-60},{2,-34},{30,-34},{29.5,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(col.port_a, volumeHall.ports[5]) annotation (Line(
      points={{60,-20},{60,-10},{52,-10},{52,-36},{34,-36},{30.5,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(col1.port_b, volumeHall.ports[6]) annotation (Line(
      points={{60,20},{60,-4},{50,-4},{50,-32},{38,-32},{31.5,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(volumeHall.ports[7], port_b3) annotation (Line(
      points={{32.5,-10},{40,-30},{48,-30},{48,80},{60,80},{60,100}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(volumeHall.ports[8], port_a3) annotation (Line(
      points={{33.5,-10},{42,-28},{44,-28},{44,80},{-60,80},{-60,100}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(extent={{-100,-100},{100,100}},
          preserveAspectRatio=false), graphics),                         Icon(
        coordinateSystem(extent={{-100,-100},{100,100}})));
end ZoneHallway;

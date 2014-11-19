within Annex60.Airflow.Multizone;
model SimpleZone "A room as a thermal zone represented by its air volume"

  parameter Modelica.SIunits.Temperature TRoom = 298.15
    "Indoor air temperature of room in K";
  parameter Modelica.SIunits.Height heightRoom = 3 "Height of room in m";
  parameter Modelica.SIunits.Length lengthRoom = 5 "Length of room in m";
  parameter Modelica.SIunits.Length widthRoom = 5 "Width of room in m";
  parameter Real doorOpening = 1
    "Opening of door (between 0:closed and 1:open)";

  replaceable package Medium = Modelica.Media.Air.SimpleAir;

  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature TAir(T=TRoom)
    "Fixed air temperature for room"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor conRoom(G=1E9)
    "Thermal conductor between fixed T and Volume"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  Fluid.MixingVolumes.MixingVolume volRoom(
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T_start=TRoom,
    m_flow_nominal=0.001,
    V=heightRoom*lengthRoom*widthRoom,
    redeclare package Medium = Medium,
    nPorts=2) "Indoor air volume of room"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{90,50},{110,70}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{90,-70},{110,-50}})));
  DoorDiscretizedOperable door(
  redeclare package Medium = Medium,
  LClo=20*1E-4,
  wOpe=1,
  hOpe=2.2,
  CDOpe=0.78,
  CDClo=0.78,
  nCom=10,
  hA=3/2,
  hB=3/2,
  dp_turbulent(displayUnit="Pa") = 0.01) "Discretized door"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Modelica.Blocks.Sources.Constant const(k=doorOpening)
    annotation (Placement(transformation(extent={{28,40},{48,60}})));
equation
  connect(TAir.port, conRoom.port_a) annotation (Line(
      points={{-40,0},{-20,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conRoom.port_b, volRoom.heatPort) annotation (Line(
      points={{0,0},{20,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(volRoom.ports[1], door.port_b2) annotation (Line(
      points={{28,-10},{28,-34},{52,-34},{52,-6},{60,-6}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(volRoom.ports[2], door.port_a1) annotation (Line(
      points={{32,-10},{32,-24},{44,-24},{44,6},{60,6}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(door.port_b1, port_a) annotation (Line(
      points={{80,6},{86,6},{86,60},{100,60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(door.port_a2, port_b) annotation (Line(
      points={{80,-6},{86,-6},{86,-60},{100,-60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(const.y, door.y) annotation (Line(
      points={{49,50},{54,50},{54,0},{59,0}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics));
end SimpleZone;

within Annex60.Airflow.Multizone;
model SimpleZone "A room as a thermal zone represented by its air volume"

  parameter Modelica.SIunits.Temperature TRoom = 293.15
    "Indoor air temperature of room in K";
  parameter Modelica.SIunits.Height heightRoom = 3 "Height of room in m";
  parameter Modelica.SIunits.Length lengthRoom = 5 "Length of room in m";
  parameter Modelica.SIunits.Length widthRoom = 5 "Width of room in m";

  package Medium = Modelica.Media.Air.SimpleAir;

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
  Modelica.Fluid.Interfaces.FluidPort_a port_a
    annotation (Placement(transformation(extent={{90,30},{110,50}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b
    annotation (Placement(transformation(extent={{90,-50},{110,-30}})));
equation
  connect(TAir.port, conRoom.port_a) annotation (Line(
      points={{-40,0},{-20,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conRoom.port_b, volRoom.heatPort) annotation (Line(
      points={{0,0},{20,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(volRoom.ports[1], port_a) annotation (Line(
      points={{28,-10},{28,-24},{58,-24},{58,40},{100,40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(volRoom.ports[2], port_b) annotation (Line(
      points={{32,-10},{32,-40},{100,-40}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics));
end SimpleZone;

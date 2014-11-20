within Annex60.Airflow.Multizone;
model OutsideEnvironment
  "Outside Environment air volume for simple air flow benchmark"

  replaceable package Medium = Modelica.Media.Air.SimpleAir;

  parameter Modelica.SIunits.Height heightRoom = 3
    "Height of room connected to outdoor air in m";

  Fluid.Sources.FixedBoundary outdoorVolume(
    redeclare package Medium = Medium,
    nPorts=2,
    p=101325,
    T=283.15) "Volume representing the outdoor air"
                                          annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={30,0})));
  MediumColumn colOutBot(
    redeclare package Medium = Medium,
    h=heightRoom/2,
    densitySelection=Annex60.Airflow.Multizone.Types.densitySelection.fromTop)
    annotation (Placement(transformation(extent={{-10,-40},{10,-20}})));
  MediumColumn colOutTop(
    redeclare package Medium = Medium,
    h=heightRoom/2,
    densitySelection=Annex60.Airflow.Multizone.Types.densitySelection.fromBottom)
    annotation (Placement(transformation(extent={{-10,20},{10,40}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{-110,50},{-90,70}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{-110,-70},{-90,-50}})));
equation
  connect(colOutBot.port_a, outdoorVolume.ports[1]) annotation (Line(
      points={{0,-20},{0,-2},{20,-2}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(colOutTop.port_b, outdoorVolume.ports[2]) annotation (Line(
      points={{0,20},{0,2},{20,2}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(port_a, colOutTop.port_a) annotation (Line(
      points={{-100,60},{0,60},{0,40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(port_b, colOutBot.port_b) annotation (Line(
      points={{-100,-60},{0,-60},{0,-40}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics));
end OutsideEnvironment;

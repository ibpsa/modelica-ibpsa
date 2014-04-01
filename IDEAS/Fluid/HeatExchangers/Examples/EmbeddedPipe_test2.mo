within IDEAS.Fluid.HeatExchangers.Examples;
model EmbeddedPipe_test2
  "Testing the floorheating according to Koschenz, par. 4.5.1"

  extends Modelica.Icons.Example;

  package Medium = IDEAS.Media.Water;

  Movers.Pump pump(
    m=4,
    useInput=true,
    redeclare package Medium = Medium,
    m_flow_nominal=12*24/3600,
    T_start=303.15)
    annotation (Placement(transformation(extent={{-36,-14},{-16,6}})));
  inner IDEAS.SimInfoManager sim(redeclare IDEAS.Climate.Meteo.Locations.Uccle
      city, redeclare IDEAS.Climate.Meteo.Files.min60 detail)
    annotation (Placement(transformation(extent={{-84,68},{-64,88}})));
  FixedResistances.Pipe_HeatPort                     heatedPipe(
    m=5,
    redeclare package Medium = Medium,
    m_flow_nominal=12*24/3600,
    T_start=303.15,
    dynamicBalance=true)
    annotation (Placement(transformation(extent={{0,6},{20,-16}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature TSet
    annotation (Placement(transformation(extent={{-28,-50},{-8,-30}})));
  Modelica.Blocks.Sources.Pulse pulse(
    period=7200,
    offset=0,
    startTime=0)
    annotation (Placement(transformation(extent={{-58,30},{-38,50}})));
  BaseClasses.RadSlaCha_ValidationEmpa radSlaCha_ValidationEmpa
    annotation (Placement(transformation(extent={{-90,-96},{-70,-76}})));
  Modelica.Fluid.Sources.Boundary_pT boundary(nPorts=1, redeclare package
      Medium = Medium)
    annotation (Placement(transformation(extent={{70,-50},{50,-30}})));
equation
  TSet.T = smooth(1, if time < 5*3600 then 273.15 + 30 else 273.15 + 20);

  connect(TSet.port, heatedPipe.heatPort) annotation (Line(
      points={{-8,-40},{2,-40},{2,-38},{10,-38},{10,-16}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(pulse.y, pump.m_flowSet) annotation (Line(
      points={{-37,40},{-26,40},{-26,6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pump.port_b, heatedPipe.port_a) annotation (Line(
      points={{-16,-4},{-8,-4},{-8,-5},{0,-5}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(heatedPipe.port_b, pump.port_a) annotation (Line(
      points={{20,-5},{34,-5},{34,-82},{-50,-82},{-50,-4},{-36,-4}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(heatedPipe.port_b, boundary.ports[1]) annotation (Line(
      points={{20,-5},{34,-5},{34,-6},{50,-6},{50,-40}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                      graphics));
end EmbeddedPipe_test2;

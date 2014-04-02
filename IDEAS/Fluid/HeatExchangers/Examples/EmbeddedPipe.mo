within IDEAS.Fluid.HeatExchangers.Examples;
model EmbeddedPipe "Testing the floorheating according to Koschenz, par. 4.5.1"

  extends Modelica.Icons.Example;

  package Medium = IDEAS.Media.Water;

  Sources.FixedBoundary                           absolutePressure(medium=
        Medium,
    nPorts=2,
    redeclare package Medium = Medium,
    p=200000)
    annotation (Placement(transformation(extent={{78,-62},{58,-42}})));
  Movers.Pump                         volumeFlow1(
    m=4,
    useInput=true,
    redeclare package Medium = Medium,
    m_flow_nominal=12*24/3600,
    m_flow(start=12*24/3600),
    TInitial=303.15)
    annotation (Placement(transformation(extent={{-36,-14},{-16,6}})));
  inner IDEAS.SimInfoManager sim(redeclare IDEAS.Climate.Meteo.Locations.Uccle
      city, redeclare IDEAS.Climate.Meteo.Files.min60 detail)
    annotation (Placement(transformation(extent={{-84,68},{-64,88}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature prescribedTemperature(
      T=293.15) annotation (Placement(transformation(extent={{8,64},{28,84}})));
  FixedResistances.Pipe_HeatPort                     heatedPipe(
    m=5,
    redeclare package Medium = Medium,
    m_flow_nominal=12*24/3600,
    TInitial=303.15)
    annotation (Placement(transformation(extent={{0,6},{20,-16}})));
  Modelica.Thermal.HeatTransfer.Components.Convection convection annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={78,46})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature TSet
    annotation (Placement(transformation(extent={{-28,-50},{-8,-30}})));
  Modelica.Blocks.Sources.Pulse pulse(
    period=7200,
    offset=0,
    startTime=0)
    annotation (Placement(transformation(extent={{-58,30},{-38,50}})));
  BaseClasses.NakedTabs nakedTabs(FHChars=radSlaCha_ValidationEmpa)
    annotation (Placement(transformation(extent={{68,2},{88,22}})));
  RadiantSlab.EmbeddedPipe embeddedPipe(
    redeclare package Medium = Medium,
    m_flow_nominal=12*24/3600,
    m_flowMin=0.01)
    annotation (Placement(transformation(extent={{30,-16},{50,4}})));
  BaseClasses.RadSlaCha_ValidationEmpa radSlaCha_ValidationEmpa
    annotation (Placement(transformation(extent={{-90,-96},{-70,-76}})));
  Modelica.Blocks.Sources.RealExpression convTabs(y=11)
    "\"convection coefficient for the tabs\""
    annotation (Placement(transformation(extent={{28,36},{48,56}})));
equation
  TSet.T = smooth(1, if time < 5*3600 then 273.15 + 30 else 273.15 + 20);

  connect(convection.fluid, prescribedTemperature.port) annotation (Line(
      points={{78,56},{50,56},{50,74},{28,74}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TSet.port, heatedPipe.heatPort) annotation (Line(
      points={{-8,-40},{2,-40},{2,-38},{10,-38},{10,-16}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(pulse.y, volumeFlow1.m_flowSet) annotation (Line(
      points={{-37,40},{-26,40},{-26,6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(volumeFlow1.port_b, heatedPipe.port_a) annotation (Line(
      points={{-16,-4},{-8,-4},{-8,-5},{0,-5}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(convection.solid, nakedTabs.port_a) annotation (Line(
      points={{78,36},{78,22}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(nakedTabs.port_b, convection.solid) annotation (Line(
      points={{78,2.2},{78,-6},{96,-6},{96,36},{78,36}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(heatedPipe.port_b, embeddedPipe.port_a) annotation (Line(
      points={{20,-5},{26,-5},{26,-6},{30,-6}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(embeddedPipe.heatPortEmb, nakedTabs.portCore) annotation (Line(
      points={{40,4},{40,12},{68,12}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(embeddedPipe.port_b, absolutePressure.ports[1]) annotation (Line(
      points={{50,-6},{58,-6},{58,-50}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(absolutePressure.ports[2], volumeFlow1.port_a) annotation (Line(
      points={{58,-54},{58,-66},{-60,-66},{-60,-4},{-36,-4}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(convTabs.y, convection.Gc) annotation (Line(
      points={{49,46},{68,46}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                      graphics));
end EmbeddedPipe;

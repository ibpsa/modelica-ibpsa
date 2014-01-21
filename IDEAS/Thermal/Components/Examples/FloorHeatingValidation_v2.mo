within IDEAS.Thermal.Components.Examples;
model FloorHeatingValidation_v2
  "Testing the floorheating according to Koschenz, par. 4.5.1"

  extends Modelica.Icons.Example;

  parameter Thermal.Data.Interfaces.Medium medium=Data.Media.Water();

  Thermal.Components.BaseClasses.AbsolutePressure absolutePressure(medium=
        medium, p=200000)
    annotation (Placement(transformation(extent={{34,-54},{54,-34}})));
  Thermal.Components.BaseClasses.Pump volumeFlow1(
    medium=medium,
    m=4,
    useInput=true,
    TInitial=303.15,
    m_flowNom=12*24/3600)
    annotation (Placement(transformation(extent={{-36,-16},{-16,4}})));
  Emission.Tabs tabs(
    medium=medium,
    A_Floor=24,
    redeclare parameter
      IDEAS.Thermal.Components.Emission.BaseClasses.FH_ValidationEmpa_floorheating
                                                                                                FHChars,
    m_flowMin=12*24/3600) "tabs model"
    annotation (Placement(transformation(extent={{68,2},{88,22}})));
  inner IDEAS.SimInfoManager sim(redeclare IDEAS.Climate.Meteo.Locations.Uccle
      city, redeclare IDEAS.Climate.Meteo.Files.min60 detail)
    annotation (Placement(transformation(extent={{-84,68},{-64,88}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature prescribedTemperature(
      T=293.15) annotation (Placement(transformation(extent={{8,64},{28,84}})));
  IDEAS.Thermal.Components.BaseClasses.Pipe_HeatPort heatedPipe(
    medium=medium,
    m=5,
    TInitial=303.15)
    annotation (Placement(transformation(extent={{0,-16},{20,6}})));
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
equation
  TSet.T = smooth(1, if time < 5*3600 then 273.15 + 30 else 273.15 + 20);
  //TSet.T = 273.15+15;
  convection.Gc = 11;

  connect(tabs.flowPort_b, volumeFlow1.flowPort_a) annotation (Line(
      points={{68,8},{56,8},{56,-60},{-76,-60},{-76,-6},{-36,-6}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(absolutePressure.flowPort, tabs.flowPort_a) annotation (Line(
      points={{34,-44},{34,-30},{48,-30},{48,16},{68,16}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(volumeFlow1.flowPort_b, heatedPipe.flowPort_a) annotation (Line(
      points={{-16,-6},{-8,-6},{-8,-5},{0,-5}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(heatedPipe.flowPort_b, tabs.flowPort_a) annotation (Line(
      points={{20,-5},{26,-5},{26,-2},{32,-2},{32,16},{68,16}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(tabs.port_a, convection.solid) annotation (Line(
      points={{78,22},{78,36}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(convection.fluid, prescribedTemperature.port) annotation (Line(
      points={{78,56},{50,56},{50,74},{28,74}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TSet.port, heatedPipe.heatPort) annotation (Line(
      points={{-8,-40},{2,-40},{2,-38},{10,-38},{10,-16}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(tabs.port_b, convection.solid) annotation (Line(
      points={{78,2.2},{78,-8},{98,-8},{98,30},{78,30},{78,36}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(pulse.y, volumeFlow1.m_flowSet) annotation (Line(
      points={{-37,40},{-26,40},{-26,4}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(graphics));
end FloorHeatingValidation_v2;

within IDEAS.Thermal.Components.Examples;
model TempMixingTester "Test the temperature mixing valve"

  parameter Thermal.Data.Interfaces.Medium medium=Data.Media.Water();

  Thermal.Components.Storage.StorageTank storageTank(
    TInitial={273.15 + 60 for i in 1:storageTank.nbrNodes},
    volumeTank=0.3,
    heightTank=1.6,
    U=0.4,
    medium=medium)
    annotation (Placement(transformation(extent={{2,-64},{-70,10}})));

  Thermal.Components.BaseClasses.Ambient ambient(
    medium=medium,
    constantAmbientPressure=500000,
    constantAmbientTemperature=283.15)
    annotation (Placement(transformation(extent={{54,-92},{74,-72}})));
  Thermal.Components.BaseClasses.Ambient ambient1(
    medium=medium,
    constantAmbientPressure=400000,
    constantAmbientTemperature=283.15)
    annotation (Placement(transformation(extent={{74,16},{94,36}})));
  Thermal.Components.BaseClasses.IdealMixer temperatureMixing(medium=medium,
      mFlowMin=0.01)
    annotation (Placement(transformation(extent={{2,16},{22,36}})));
  Modelica.Blocks.Sources.Pulse pulse(
    period=86400,
    startTime=7*3600,
    width=50) annotation (Placement(transformation(extent={{16,66},{36,86}})));
  Thermal.Components.BaseClasses.Pump pump1(
    medium=medium,
    m_flowNom=0.1,
    m=0,
    TInitial=283.15,
    useInput=true)
    annotation (Placement(transformation(extent={{38,16},{58,36}})));
equation
  temperatureMixing.TMixedSet=273.15+35;
  connect(storageTank.flowPort_a, temperatureMixing.flowPortHot) annotation (
      Line(
      points={{-34,10},{-16,10},{-16,26},{2,26}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(ambient.flowPort, storageTank.flowPort_b) annotation (Line(
      points={{54,-82},{-34,-82},{-34,-64}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(ambient.flowPort, temperatureMixing.flowPortCold) annotation (Line(
      points={{54,-82},{38,-82},{38,-80},{12,-80},{12,16}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(temperatureMixing.flowPortMixed, pump1.flowPort_a) annotation (Line(
      points={{22,26},{38,26}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(pump1.flowPort_b, ambient1.flowPort) annotation (Line(
      points={{58,26},{74,26}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(pulse.y, pump1.m_flowSet) annotation (Line(
      points={{37,76},{48,76},{48,36}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(graphics));
end TempMixingTester;

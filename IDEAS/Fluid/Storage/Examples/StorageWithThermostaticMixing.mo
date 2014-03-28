within IDEAS.Fluid.Storage.Examples;
model StorageWithThermostaticMixing
  "Test the temperature mixing valve connected to a storage tank"
  import IDEAS;

  extends Modelica.Icons.Example;

  parameter Thermal.Data.Interfaces.Medium medium=Thermal.Data.Media.Water();

  Fluid.Storage.StorageTank storageTank(
    TInitial={273.15 + 60 for i in 1:storageTank.nbrNodes},
    volumeTank=0.3,
    heightTank=1.6,
    UIns=0.4,
    medium=medium)
    annotation (Placement(transformation(extent={{2,-64},{-70,10}})));

  IDEAS.BaseClasses.Ambient1 ambient(
    medium=medium,
    constantAmbientPressure=500000,
    constantAmbientTemperature=283.15)
    annotation (Placement(transformation(extent={{76,-92},{96,-72}})));
  IDEAS.BaseClasses.Ambient1 ambient1(
    medium=medium,
    constantAmbientPressure=400000,
    constantAmbientTemperature=283.15)
    annotation (Placement(transformation(extent={{74,16},{94,36}})));
  Fluid.Valves.Thermostatic3WayValve temperatureMixing(medium=medium, mFlowMin=
        0.01) annotation (Placement(transformation(extent={{2,16},{22,36}})));
  Modelica.Blocks.Sources.Pulse pulse(
    startTime=7*3600,
    width=50,
    amplitude=0.5,
    period=5000)
    annotation (Placement(transformation(extent={{16,66},{36,86}})));
  Fluid.Movers.Pump pump1(
    medium=medium,
    m_flowNom=0.1,
    m=0,
    TInitial=283.15,
    useInput=true)
    annotation (Placement(transformation(extent={{38,16},{58,36}})));
equation
  temperatureMixing.TMixedSet = 273.15 + 35;
  connect(storageTank.flowPort_a, temperatureMixing.flowPortHot) annotation (
      Line(
      points={{-70,4.30769},{-70,26},{2,26}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(ambient.flowPort, storageTank.flowPort_b) annotation (Line(
      points={{76,-82},{-70,-82},{-70,-58.3077}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(ambient.flowPort, temperatureMixing.flowPortCold) annotation (Line(
      points={{76,-82},{12,-82},{12,16}},
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
  annotation (
    Diagram(graphics),
    Documentation(info="<html>
<p>The mixing control changes as the storage tank gets colder, until the desired outlet temperature can no longer be reached. </p>
<p><u>Remark</u></p>
<p>- there are no heat losses.  Due to the cold water inlet in the bottom of the tank, the upper layers will cool down when the pump is not running and the bottom layers will heat up a little bit. </p>
</html>"),
    experiment(StopTime=86400),
    __Dymola_experimentSetupOutput);
end StorageWithThermostaticMixing;

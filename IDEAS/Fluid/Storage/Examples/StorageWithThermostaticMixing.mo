within IDEAS.Fluid.Storage.Examples;
model StorageWithThermostaticMixing
  "Test the temperature mixing valve connected to a storage tank"
  import IDEAS;

  extends Modelica.Icons.Example;
  package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater annotation (
      __Dymola_choicesAllMatching=true);
  constant SI.MassFlowRate m_flow_nominal=0.1 "Nominal mass flow rate";

  Fluid.Storage.StorageTank storageTank(
    T_start={273.15 + 60 for i in 1:storageTank.nbrNodes},
    volumeTank=0.3,
    heightTank=1.6,
    UIns=0.4,
    redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-20,-62},{-70,10}})));

  Fluid.Valves.Thermostatic3WayValve temperatureMixing(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal)
              annotation (Placement(transformation(extent={{2,16},{22,36}})));
  Modelica.Blocks.Sources.Pulse pulse(
    startTime=7*3600,
    width=50,
    amplitude=0.5,
    period=5000)
    annotation (Placement(transformation(extent={{16,66},{36,86}})));
  Fluid.Movers.Pump pump1(
    m=0,
    useInput=true,
    m_flow_nominal=m_flow_nominal,
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    T_start=283.15)
    annotation (Placement(transformation(extent={{38,16},{58,36}})));
  IDEAS.Fluid.Sources.Boundary_pT bou(
    redeclare package Medium = Medium,
    nPorts=1,
    p=400000,
    T=283.15) annotation (Placement(transformation(extent={{92,16},{72,36}})));

  IDEAS.Fluid.Sources.Boundary_pT bou1(
    redeclare package Medium = Medium,
    nPorts=1,
    p=500000,
    T=283.15) annotation (Placement(transformation(extent={{92,-90},{72,-70}})));

  Modelica.Blocks.Sources.Constant const(k=273.15 + 35)
    annotation (Placement(transformation(extent={{-54,68},{-34,88}})));
equation
  connect(storageTank.port_a, temperatureMixing.port_a1) annotation (
      Line(
      points={{-70,4.46154},{-70,26},{2,26}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(temperatureMixing.port_b, pump1.port_a) annotation (Line(
      points={{22,26},{38,26}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(pulse.y, pump1.m_flowSet) annotation (Line(
      points={{37,76},{48,76},{48,36.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(bou.ports[1], pump1.port_b) annotation (Line(
      points={{72,26},{58,26}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(bou1.ports[1], temperatureMixing.port_a2) annotation (Line(
      points={{72,-80},{12,-80},{12,16}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(storageTank.port_b, temperatureMixing.port_a2) annotation (Line(
      points={{-70,-56.4615},{-70,-80},{12,-80},{12,16}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(const.y, temperatureMixing.TMixedSet) annotation (Line(
      points={{-33,78},{12,78},{12,36}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}),
            graphics),
    Documentation(info="<html>
<p>The mixing control changes as the storage tank gets colder, until the desired outlet temperature can no longer be reached. </p>
<p><u>Remark</u></p>
<p>- there are no heat losses.  Due to the cold water inlet in the bottom of the tank, the upper layers will cool down when the pump is not running and the bottom layers will heat up a little bit. </p>
</html>", revisions="<html>
<ul>
<li>March 2014 by Filip Jorissen:<br/> 
Annex60 compatibility
</li>
</ul>
</html>"),
    experiment(StopTime=86400),
    __Dymola_experimentSetupOutput);
end StorageWithThermostaticMixing;

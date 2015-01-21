within IDEAS.Fluid.Storage.Examples;
model StorageTank_OneIntHx
  import IDEAS;
  import Buildings;

  extends Modelica.Icons.Example;

  package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater
    annotation (__Dymola_choicesAllMatching=true);

  parameter Integer nbrNodes=10 "Number of nodes in the storage tank";

  Fluid.Storage.StorageTank_OneIntHX storageTank(
    nbrNodes=nbrNodes,
    volumeTank=0.3,
    heightTank=1.6,
    UIns=0.4,
    redeclare package MediumHX = Medium,
    redeclare package Medium = Medium,
    m_flow_nominal_HX=1,
    T_start={273.15 + 20 for i in 1:nbrNodes})
    annotation (Placement(transformation(extent={{-30,-64},{42,10}})));

  IDEAS.Fluid.Production.HP_WaterWater_OnOff hp(
    redeclare IDEAS.Fluid.Production.BaseClasses.VitoCal300GBWS301dotA08
      heatPumpData,
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium)
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-72,8})));
  Fluid.Movers.Pump pump(
    m=1,
    redeclare package Medium = Medium,
    useInput=false,
    m_flow_nominal=hp.heatPumpData.m2_flow_nominal*hp.sca)
    annotation (Placement(transformation(extent={{-38,-62},{-58,-42}})));
  inner IDEAS.SimInfoManager sim
    annotation (Placement(transformation(extent={{-94,-94},{-74,-74}})));
  IDEAS.Fluid.Sources.Boundary_pT bou(
    redeclare package Medium = Medium,
    p=300000,
    nPorts=2) annotation (Placement(transformation(extent={{86,-96},{66,-76}})));

  parameter SI.MassFlowRate m_flow_nominal=3 "Nominal mass flow rate";
  IDEAS.Fluid.Sensors.TemperatureTwoPort senStoHx_in(redeclare package Medium
      = Medium, m_flow_nominal=hp.heatPumpData.m2_flow_nominal*hp.sca)
    annotation (Placement(transformation(extent={{-46,4},{-34,16}})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort senStoHx_out(redeclare package Medium
      = Medium, m_flow_nominal=hp.heatPumpData.m2_flow_nominal*hp.sca)
                                               annotation (Placement(
        transformation(
        extent={{-6,-6},{6,6}},
        rotation=90,
        origin={-58,-22})));
  IDEAS.Fluid.FixedResistances.Pipe_HeatPort pipe_HeatPort(redeclare package
      Medium = Medium, m_flow_nominal=m_flow_nominal) annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={92,-30})));
  IDEAS.Fluid.Movers.Pump pump1(redeclare package Medium = Medium,
      m_flow_nominal=m_flow_nominal)
    annotation (Placement(transformation(extent={{88,-6},{68,14}})));
  IDEAS.Fluid.Sources.Boundary_pT bou1(
    redeclare package Medium = Medium,
    nPorts=2,
    p=300000,
    T=285.15) annotation (Placement(transformation(extent={{-82,-28},{-102,-8}})));
  IDEAS.Fluid.Movers.Pump pump2(redeclare package Medium = Medium,
      m_flow_nominal=hp.heatPumpData.m1_flow_nominal*hp.sca)
    annotation (Placement(transformation(extent={{-114,14},{-94,34}})));
  Modelica.Blocks.Sources.BooleanConstant booleanConstant
    annotation (Placement(transformation(extent={{-112,50},{-92,70}})));
  Buildings.HeatTransfer.Sources.FixedTemperature prescribedTemperature(T=
        293.15) annotation (Placement(transformation(extent={{68,30},{88,50}})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort senSto_in(redeclare package Medium =
        Medium, m_flow_nominal=m_flow_nominal) annotation (Placement(
        transformation(
        extent={{6,-6},{-6,6}},
        rotation=0,
        origin={54,4})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort senSto_out(redeclare package Medium =
        Medium, m_flow_nominal=m_flow_nominal) annotation (Placement(
        transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={64,-58})));
equation

  connect(bou.ports[1], pump.port_a) annotation (Line(
      points={{66,-84},{-38,-84},{-38,-52}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pump.port_a, storageTank.portHXLower) annotation (Line(
      points={{-38,-52},{-34,-52},{-34,-52.6154},{-30,-52.6154}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(storageTank.port_b, bou.ports[2]) annotation (Line(
      points={{42,-58.3077},{42,-88},{66,-88}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senStoHx_in.port_b, storageTank.portHXUpper) annotation (Line(
      points={{-34,10},{-30,10},{-30,-41.2308}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senStoHx_out.port_a, pump.port_b) annotation (Line(
      points={{-58,-28},{-58,-52}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pipe_HeatPort.port_b, pump1.port_a) annotation (Line(
      points={{92,-20},{92,4},{88,4}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(bou1.ports[1], pump2.port_a) annotation (Line(
      points={{-102,-16},{-122,-16},{-122,24},{-114,24}},
      color={0,127,255},
      smooth=Smooth.None));

  connect(booleanConstant.y, hp.on) annotation (Line(
      points={{-91,60},{-82.8,60},{-82.8,10}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(prescribedTemperature.port, pipe_HeatPort.heatPort) annotation (Line(
      points={{88,40},{106,40},{106,-30},{102,-30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(pump1.port_b, senSto_in.port_a) annotation (Line(
      points={{68,4},{60,4}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senSto_in.port_b, storageTank.port_a) annotation (Line(
      points={{48,4},{46,4},{46,4.30769},{42,4.30769}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pipe_HeatPort.port_a, senSto_out.port_b) annotation (Line(
      points={{92,-40},{92,-58.3077},{70,-58}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senSto_out.port_a, storageTank.port_b) annotation (Line(
      points={{58,-58},{50,-58},{50,-58.3077},{42,-58.3077}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(hp.port_b2, senStoHx_in.port_a) annotation (Line(
      points={{-66,18},{-56,18},{-56,10},{-46,10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(hp.port_a2, senStoHx_out.port_b) annotation (Line(
      points={{-66,-2},{-62,-2},{-62,-16},{-58,-16}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(hp.port_b1, bou1.ports[2]) annotation (Line(
      points={{-78,-2},{-92,-2},{-92,-4},{-102,-4},{-102,-20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(hp.port_a1, pump2.port_b) annotation (Line(
      points={{-78,18},{-86,18},{-86,24},{-94,24}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,-100},{
            120,100}}), graphics),
    experiment(StopTime=86400),
    __Dymola_experimentSetupOutput,
    Documentation(revisions="<html>
<ul>
<li>March 2014 by Filip Jorissen:<br/> 
Annex60 compatibility
</li>
</ul>
</html>"),
    Icon(coordinateSystem(extent={{-140,-100},{120,100}})));
end StorageTank_OneIntHx;

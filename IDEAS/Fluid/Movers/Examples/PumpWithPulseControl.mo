within IDEAS.Fluid.Movers.Examples;
model PumpWithPulseControl "Example of how a pump can be used"
  import IDEAS;
  extends Modelica.Icons.Example;

  IDEAS.Fluid.Movers.Pump pump(redeclare package Medium = Medium, m_flow_nominal=
       1,
    useInput=true,
    riseTime=60,
    filteredMassFlowRate=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
          annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  IDEAS.Fluid.Sources.Boundary_pT bou(nPorts=1, redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{-58,-10},{-38,10}})));
  IDEAS.Fluid.Sources.Boundary_pT bou1(nPorts=1, redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{68,-10},{48,10}})));
  package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater
    annotation (__Dymola_choicesAllMatching=true);
  inner Modelica.Fluid.System system(
    p_ambient=300000,
    T_ambient=313.15)
    annotation (Placement(transformation(extent={{-90,-80},{-70,-60}})));
  Modelica.Blocks.Sources.Pulse pulse(period=3600)
    annotation (Placement(transformation(extent={{-42,40},{-22,60}})));
  IDEAS.Fluid.Sensors.MassFlowRate senMasFlo(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
equation
  connect(bou.ports[1], pump.port_a) annotation (Line(
      points={{-38,0},{-10,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pulse.y, pump.m_flowSet) annotation (Line(
      points={{-21,50},{0,50},{0,10.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pump.port_b, senMasFlo.port_a) annotation (Line(
      points={{10,0},{20,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senMasFlo.port_b, bou1.ports[1]) annotation (Line(
      points={{40,0},{48,0}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics),
    experiment(StopTime=10000),
    __Dymola_experimentSetupOutput);
end PumpWithPulseControl;

within IDEAS.Fluid.Movers.Examples;
model PumpExample "Example of how a pump can be used"
  import IDEAS;
  extends Modelica.Icons.Example;

  IDEAS.Fluid.Movers.Pump pump(redeclare package Medium = Medium, m_flow_nominal=
       1,
    useInput=true,
    riseTime=500,
    use_onOffSignal=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
          annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  IDEAS.Fluid.Sources.Boundary_pT bou(nPorts=1, redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{-58,-10},{-38,10}})));
  IDEAS.Fluid.Sources.Boundary_pT bou1(nPorts=1, redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{82,-10},{62,10}})));
  package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater
    annotation (__Dymola_choicesAllMatching=true);
  inner Modelica.Fluid.System system(
    p_ambient=300000,
    T_ambient=313.15)
    annotation (Placement(transformation(extent={{-90,-80},{-70,-60}})));
  Modelica.Blocks.Sources.Sine sine(freqHz=0.001)
    annotation (Placement(transformation(extent={{-42,40},{-22,60}})));
  IDEAS.Fluid.Sensors.MassFlowRate senMasFlo(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{26,-10},{46,10}})));
  Modelica.Blocks.Sources.BooleanPulse booleanPulse(period=5500)
    annotation (Placement(transformation(extent={{-38,12},{-22,28}})));
equation
  connect(bou.ports[1], pump.port_a) annotation (Line(
      points={{-38,0},{-10,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sine.y, pump.m_flowSet) annotation (Line(
      points={{-21,50},{0,50},{0,10.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pump.port_b, senMasFlo.port_a) annotation (Line(
      points={{10,0},{26,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senMasFlo.port_b, bou1.ports[1]) annotation (Line(
      points={{46,0},{62,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(booleanPulse.y, pump.on) annotation (Line(
      points={{-21.2,20},{-2,20},{-2,10.8}},
      color={255,0,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics),
    experiment(StopTime=10000),
    __Dymola_experimentSetupOutput);
end PumpExample;

within IDEAS.Fluid.Movers.Examples;
model PumpWithPipeBuilding "Example of how a pump can be used"
  import IDEAS;
  import Buildings;
  extends Modelica.Icons.Example;

  IDEAS.Fluid.Sources.Boundary_pT bou(          redeclare package Medium =
        Medium, nPorts=2)
    annotation (Placement(transformation(extent={{-58,-10},{-38,10}})));
//   replaceable package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater
//     annotation (__Dymola_choicesAllMatching=true);
   package Medium = IDEAS.Media.Water
    annotation (__Dymola_choicesAllMatching=true);

  inner Modelica.Fluid.System system(
    p_ambient=300000,
    T_ambient=313.15)
    annotation (Placement(transformation(extent={{-90,-80},{-70,-60}})));
  Modelica.Blocks.Sources.Sine sine(freqHz=0.001)
    annotation (Placement(transformation(extent={{-38,28},{-18,48}})));
  Buildings.Fluid.Movers.FlowMachine_m_flow floMacSta(
      redeclare package Medium = Medium,
      m_flow_nominal=1,
      filteredSpeed=false,
    dynamicBalance=false,
    addPowerToMedium=false,
    motorCooledByFluid=false) "Static model of a flow machine"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Fluid.FixedResistances.FixedResistanceDpM dpSta(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    dp_nominal=100,
    linearized=true) "Pressure drop"
    annotation (Placement(transformation(extent={{32,-10},{52,10}})));
equation
  connect(bou.ports[1], floMacSta.port_a) annotation (Line(
      points={{-38,2},{-24,2},{-24,0},{-10,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(floMacSta.port_b, dpSta.port_a) annotation (Line(
      points={{10,0},{32,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(dpSta.port_b, bou.ports[2]) annotation (Line(
      points={{52,0},{60,0},{60,-48},{-32,-48},{-32,-2},{-38,-2}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sine.y, floMacSta.m_flow_in) annotation (Line(
      points={{-17,38},{-0.2,38},{-0.2,12}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics),
    experiment(StopTime=10000),
    __Dymola_experimentSetupOutput);
end PumpWithPipeBuilding;

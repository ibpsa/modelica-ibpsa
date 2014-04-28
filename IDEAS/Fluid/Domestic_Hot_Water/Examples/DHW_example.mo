within IDEAS.Fluid.Domestic_Hot_Water.Examples;
model DHW_example

  DHW_RealInput dHW_RealInput(             redeclare package Medium = Medium,
    tau=1,
    TDHWSet=333.15)
    annotation (Placement(transformation(extent={{-2,-4},{22,10}})));
  Sources.Boundary_pT bou(
    redeclare package Medium = Medium,
    T=333,
    nPorts=2,
    use_T_in=true)
    annotation (Placement(transformation(extent={{-40,-12},{-20,8}})));
  replaceable package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater;
  Modelica.Blocks.Sources.Sine sine(
    amplitude=0.5,
    freqHz=0.1,
    offset=1) annotation (Placement(transformation(extent={{-44,42},{-24,62}})));
  Modelica.Blocks.Sources.Step step(
    height=-20,
    startTime=100,
    offset=333.15)
    annotation (Placement(transformation(extent={{-94,-8},{-74,12}})));
equation
  connect(sine.y, dHW_RealInput.mDHW60C) annotation (Line(
      points={{-23,52},{-14,52},{-14,20},{-2,20},{-2,8.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(dHW_RealInput.port_cold, bou.ports[1]) annotation (Line(
      points={{22,2.22045e-16},{22,-22},{-20,-22},{-20,8.88178e-16}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(dHW_RealInput.port_hot, bou.ports[2]) annotation (Line(
      points={{-2,0},{-12,0},{-12,-4},{-20,-4}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(step.y, bou.T_in) annotation (Line(
      points={{-73,2},{-42,2}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics));
end DHW_example;

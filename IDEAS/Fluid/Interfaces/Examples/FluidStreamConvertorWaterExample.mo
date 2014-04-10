within IDEAS.Fluid.Interfaces.Examples;
model FluidStreamConvertorWaterExample
  "Example of coupling between IDEAS and modelica fluid libraries"
  import Buildings;

  extends Modelica.Icons.Example;
  Buildings.Fluid.Sources.Boundary_pT bou1(
    redeclare package Medium =
        Buildings.Media.ConstantPropertyLiquidWater,
    use_p_in=false,
    use_T_in=false,
    use_X_in=false,
    use_C_in=false,
    nPorts=1,
    p=100000,
    T=283.15) annotation (Placement(transformation(extent={{80,2},{60,22}})));
  IDEAS.Fluid.Movers.Pump pump(
    m=1,
    m_flowNom=1,
    useInput=true,
    medium=IDEAS.Thermal.Data.Media.WaterBuildingsLib())
    annotation (Placement(transformation(extent={{-56,2},{-36,22}})));
  IDEAS.Thermal.Components.BaseClasses.Ambient1 ambient(
    medium=IDEAS.Thermal.Data.Media.WaterBuildingsLib(),
    constantAmbientPressure=100000,
    constantAmbientTemperature=372.15)
    annotation (Placement(transformation(extent={{-76,2},{-96,22}})));
  Modelica.Fluid.Sensors.TemperatureTwoPort temperature(redeclare package
      Medium = Buildings.Media.ConstantPropertyLiquidWater, allowFlowReversal=true)
    annotation (Placement(transformation(extent={{38,2},{58,22}})));
  Modelica.Blocks.Sources.Ramp ramp(
    height=2,
    duration=0.5,
    offset=-1,
    startTime=0.1)
    annotation (Placement(transformation(extent={{-80,48},{-60,68}})));
  Fluid.Interfaces.FluidStreamConversionWater convertStream(
    nPorts=1,
    redeclare package MediumMSL = Buildings.Media.ConstantPropertyLiquidWater,
    mediumIDEAS=IDEAS.Thermal.Data.Media.WaterBuildingsLib())
    annotation (Placement(transformation(extent={{-8,2},{12,22}})));
equation
  connect(bou1.ports[1], temperature.port_b) annotation (Line(
      points={{60,12},{58,12}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pump.flowPort_a, ambient.flowPort) annotation (Line(
      points={{-56,12},{-76,12}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(ramp.y, pump.m_flowSet) annotation (Line(
      points={{-59,58},{-52,58},{-52,22},{-46,22}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pump.flowPort_b, convertStream.portsIDEAS[1]) annotation (Line(
      points={{-36,12},{-24,12},{-24,12.2},{-8,12.2}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(temperature.port_a, convertStream.ports[1]) annotation (Line(
      points={{38,12},{12,12}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (                  Diagram(coordinateSystem(preserveAspectRatio=false,
                   extent={{-100,-100},{100,100}}), graphics), Documentation(info="<html>
                   <p>This example can be used to test the functionality of  <a href=\"modelica://IDEAS.Thermal.Components.BaseClasses.FluidStreamConversion\">IDEAS.Thermal.Components.BaseClasses.FluidStreamConversion</a>.</p>
</html>"),
    experiment,
    __Dymola_experimentSetupOutput);
end FluidStreamConvertorWaterExample;

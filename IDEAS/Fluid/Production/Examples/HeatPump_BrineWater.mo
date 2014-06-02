within IDEAS.Fluid.Production.Examples;
model HeatPump_BrineWater
  "General example and tester for a modulating water-to-water heat pump"
  extends Modelica.Icons.Example;
  package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater
    annotation (__Dymola_choicesAllMatching=true);
  constant SI.MassFlowRate m_flow_nominal=0.3 "Nominal mass flow rate";
  Fluid.Movers.Pump pump(
    m=1,
    useInput=false,
    redeclare package Medium = Medium,
    m_flow_nominal=2550/3600)
    annotation (Placement(transformation(extent={{-6,14},{-26,34}})));
  inner IDEAS.SimInfoManager sim
    annotation (Placement(transformation(extent={{-92,74},{-72,94}})));
  Modelica.Blocks.Sources.Sine sine(
    freqHz=1/5000,
    amplitude=4,
    offset=273.15 + 30,
    startTime=2000)
    annotation (Placement(transformation(extent={{92,12},{72,32}})));
  Sources.Boundary_pT bou(          redeclare package Medium = Medium,
    nPorts=2,
    use_T_in=true,
    p=200000)
    annotation (Placement(transformation(extent={{58,36},{38,16}})));
  Fluid.Movers.Pump pump1(
    m=1,
    useInput=false,
    redeclare package Medium = Medium,
    m_flow_nominal=4200/3600)
    annotation (Placement(transformation(extent={{-6,-22},{-26,-2}})));
  Sources.Boundary_pT bou1(         redeclare package Medium = Medium,
    nPorts=2,
    use_T_in=true,
    p=200000)
    annotation (Placement(transformation(extent={{58,-10},{38,-30}})));
  Modelica.Blocks.Sources.Sine sine1(
    amplitude=4,
    offset=273.15 + 10,
    startTime=4000,
    freqHz=1/3000)
    annotation (Placement(transformation(extent={{92,-34},{72,-14}})));
  replaceable HeatPumpOnOff heatPump(
    redeclare package MediumBrine = Medium,
    redeclare package MediumFluid = Medium,
    use_onOffSignal=false,
    redeclare IDEAS.Fluid.Production.BaseClasses.VitoCal300GBWS301dotA29
      heatPumpData)
    constrainedby IDEAS.Fluid.Production.BaseClasses.PartialHeatPump
    annotation (Placement(transformation(extent={{-58,18},{-38,38}})));
equation
  connect(pump.port_a, bou.ports[1]) annotation (Line(
      points={{-6,24},{38,24}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sine.y, bou.T_in) annotation (Line(
      points={{71,22},{60,22}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sine1.y, bou1.T_in) annotation (Line(
      points={{71,-24},{60,-24}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(bou1.ports[1], pump1.port_a) annotation (Line(
      points={{38,-22},{16,-22},{16,-12},{-6,-12}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(heatPump.fluidIn, pump.port_b) annotation (Line(
      points={{-38,24},{-26,24}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(heatPump.fluidOut, bou.ports[2]) annotation (Line(
      points={{-38,32},{0,32},{0,28},{38,28}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(heatPump.brineOut, bou1.ports[2]) annotation (Line(
      points={{-58,24},{-58,0},{38,0},{38,-18}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(heatPump.brineIn, pump1.port_b) annotation (Line(
      points={{-58,32},{-74,32},{-74,-12},{-26,-12}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}),     graphics),
    experiment(StopTime=15000),
    __Dymola_experimentSetupOutput,
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}})),
    Commands(file="Scripts/Tester_Boiler.mos" "TestModel"),
    Documentation(info="<html>
<p>This example shows the modulation behaviour of an inverter controlled air-to-water heat pump when the inlet water temperature is changed. </p>
<p>The modulation level can be seen from heater.heatSource.modulation.</p>
</html>", revisions="<html>
<ul>
<li>March 2014 by Filip Jorissen:<br/> 
Initial version
</li>
</ul>
</html>"));
end HeatPump_BrineWater;

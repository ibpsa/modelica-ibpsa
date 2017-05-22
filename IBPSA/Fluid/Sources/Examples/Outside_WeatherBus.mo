within IBPSA.Fluid.Sources.Examples;
model Outside_WeatherBus
  "Test model for source (sink) with weather bus"
  import IBPSA;
  extends Modelica.Icons.Example;
  package Medium = IBPSA.Media.Air "Medium model for air";

  IBPSA.Fluid.Sources.MassFlowSourceFromOutside_T sin_with_T(
    redeclare package Medium = Medium,
    m_flow=-1,
    nPorts=1,
    use_T_in=true,
    use_X_in=true)
    "Mass flow source model receiving T and X from weather data through weather bus"
    annotation (Placement(transformation(extent={{96,-50},{76,-30}})));

  Sensors.TemperatureTwoPort             senTem(
    redeclare package Medium = Medium,
    m_flow_nominal=1) "Temperature sensor"
    annotation (Placement(transformation(extent={{44,-50},{64,-30}})));
  IBPSA.Fluid.Sources.Outside bou(
   redeclare package Medium = Medium, nPorts=1)
             "Model with outside conditions"
    annotation (Placement(transformation(extent={{-64,-50},{-44,-30}})));
  IBPSA.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
        "modelica://IBPSA/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos")
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  IBPSA.Fluid.Sources.MassFlowSourceFromOutside_h sin_with_h(
    redeclare package Medium = Medium,
    m_flow=-1,
    nPorts=1,
    use_X_in=true,
    use_h_in=true)
    "Mass flow source model receiving h and X from weather data through weather bus"
    annotation (Placement(transformation(extent={{96,30},{76,50}})));
  IBPSA.Fluid.Sensors.RelativeHumidityTwoPort senRelHum(
    redeclare package Medium = Medium,
    m_flow_nominal=1) "Sensor for relative humidity"
    annotation (Placement(transformation(extent={{-30,-50},{-10,-30}})));
  IBPSA.Fluid.Sensors.MassFractionTwoPort senMasFra(
    redeclare package Medium = Medium,
    m_flow_nominal=1) "Sensor for mass fraction of water"
    annotation (Placement(transformation(extent={{10,-50},{30,-30}})));
  IBPSA.Fluid.Sources.Outside bou1(
   redeclare package Medium = Medium, nPorts=1)
             "Model with outside conditions"
    annotation (Placement(transformation(extent={{-64,30},{-44,50}})));
  IBPSA.Fluid.Sensors.RelativeHumidityTwoPort senRelHum1(
    redeclare package Medium = Medium,
    m_flow_nominal=1) "Sensor for relative humidity"
    annotation (Placement(transformation(extent={{-30,30},{-10,50}})));
  IBPSA.Fluid.Sensors.MassFractionTwoPort senMasFra1(
    redeclare package Medium = Medium,
    m_flow_nominal=1) "Sensor for mass fraction of water"
    annotation (Placement(transformation(extent={{10,30},{30,50}})));
  Sensors.TemperatureTwoPort             senTem1(
    redeclare package Medium = Medium,
    m_flow_nominal=1) "Temperature sensor"
    annotation (Placement(transformation(extent={{44,30},{64,50}})));
equation
  connect(senTem.port_b, sin_with_T.ports[1])
    annotation (Line(points={{64,-40},{68,-40},{76,-40}}, color={0,127,255}));
  connect(weaDat.weaBus, sin_with_T.weaBus) annotation (Line(
      points={{-80,0},{-72,0},{-72,-60},{96,-60},{96,-39.8}},
      color={255,204,51},
      thickness=0.5));
  connect(bou.ports[1], senRelHum.port_a) annotation (Line(points={{-44,-40},{-37,
          -40},{-30,-40}}, color={0,127,255}));
  connect(senRelHum.port_b, senMasFra.port_a)
    annotation (Line(points={{-10,-40},{0,-40},{10,-40}}, color={0,127,255}));
  connect(senMasFra.port_b, senTem.port_a)
    annotation (Line(points={{30,-40},{37,-40},{44,-40}}, color={0,127,255}));
  connect(bou1.ports[1], senRelHum1.port_a)
    annotation (Line(points={{-44,40},{-37,40},{-30,40}}, color={0,127,255}));
  connect(senRelHum1.port_b, senMasFra1.port_a)
    annotation (Line(points={{-10,40},{0,40},{10,40}}, color={0,127,255}));
  connect(senMasFra1.port_b, senTem1.port_a)
    annotation (Line(points={{30,40},{44,40}}, color={0,127,255}));
  connect(senTem1.port_b, sin_with_h.ports[1])
    annotation (Line(points={{64,40},{70,40},{76,40}}, color={0,127,255}));
  connect(weaDat.weaBus, bou1.weaBus) annotation (Line(
      points={{-80,0},{-72,0},{-72,40.2},{-64,40.2}},
      color={255,204,51},
      thickness=0.5));
  connect(weaDat.weaBus, sin_with_h.weaBus) annotation (Line(
      points={{-80,0},{-72,0},{-72,60},{96,60},{96,40.2}},
      color={255,204,51},
      thickness=0.5));
  connect(weaDat.weaBus, bou.weaBus) annotation (Line(
      points={{-80,0},{-72,0},{-72,-39.8},{-64,-39.8}},
      color={255,204,51},
      thickness=0.5));
  annotation (
experiment(Tolerance=1e-6, StopTime=3.1536e+07),
__Dymola_Commands(file="modelica://IBPSA/Resources/Scripts/Dymola/Fluid/Sources/Examples/Outside_WeatherBus.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This model demonstrates how to connect fluid flow component to a
boundary condition that has environmental conditions as
obtained from a weather file.
The model draws a constant mass flow rate of outside air through
its components.
</p>
</html>", revisions="<html>
<ul>
<li>
May 21, 2017 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Outside_WeatherBus;

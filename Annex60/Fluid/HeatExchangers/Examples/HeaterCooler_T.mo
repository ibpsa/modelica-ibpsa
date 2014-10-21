within Annex60.Fluid.HeatExchangers.Examples;
model HeaterCooler_T
  "Model that demonstrates the ideal heater/cooler model for a prescribed outlet temperature"
  extends Modelica.Icons.Example;
  package Medium = Annex60.Media.Water.Simple;
  inner Modelica.Fluid.System system(m_flow_start=0, energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal=0.1
    "Nominal mass flow rate";
  Annex60.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    use_T_in=false,
    p(displayUnit="Pa"),
    T=293.15,
    nPorts=4) "Sink"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=180,origin={130,50})));
  Annex60.Fluid.HeatExchangers.HeaterCooler_T heaterStrongPower(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=6000,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    Q_flow_maxHeat=1.0e10) "Steady-state model of the heater"
    annotation (Placement(transformation(extent={{0,90},{20,110}})));
  Annex60.Fluid.Sensors.TemperatureTwoPort senTem1(redeclare package Medium =
    Medium, m_flow_nominal=m_flow_nominal) "Temperature sensor"
    annotation (Placement(transformation(extent={{40,90},{60,110}})));
  Modelica.Blocks.Sources.TimeTable TSetHeat(table=[0,273.15 + 20.0; 120,273.15
    + 20.0; 120,273.15 + 60.0; 500,273.15 + 60.0; 500,273.15 + 30.0; 1200,273.15 + 30.0])
    "Setpoint heating"
    annotation (Placement(transformation(extent={{-60,140},{-40,160}})));
  Annex60.Fluid.Sources.MassFlowSource_T sou(
    redeclare package Medium = Medium,
    use_T_in=false,
    nPorts=4,
    m_flow=2*m_flow_nominal,
    T=293.15) "Source"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}},rotation=0)));
  Annex60.Fluid.Sensors.TemperatureTwoPort senTem2(redeclare package Medium =
    Medium, m_flow_nominal=m_flow_nominal) "Temperature sensor"
    annotation (Placement(transformation(extent={{50,24},{70,44}})));
  Annex60.Fluid.HeatExchangers.HeaterCooler_T coolerWeakPower(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=6000,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    Q_flow_maxCool=-1000) "Steady-state model of the heater"
    annotation (Placement(transformation(extent={{0,24},{20,44}})));
  Modelica.Blocks.Sources.TimeTable TSetCool(table=[0,273.15 + 20.0; 120,273.15
    + 20.0; 120,273.15 + 15.0; 500,273.15 + 15.0; 500,273.15 + 10.0; 1200,273.15 + 10.0])
    "Setpoint cooling"
    annotation (Placement(transformation(extent={{-86,2},{-66,22}})));
  Annex60.Fluid.HeatExchangers.HeaterCooler_T idealHeaterAndCooler(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=6000,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
    "Steady-state model of the heater"
    annotation (Placement(transformation(extent={{2,-34},{22,-14}})));
  Modelica.Blocks.Sources.TimeTable TSetCoolHeat(table=[0,273.15 + 20.0; 120,273.15
    + 20.0; 120,273.15 + 15.0; 500,273.15 + 15.0; 500,273.15 + 30.0; 1200,273.15
    + 30.0]) "Setpoint cooling"
    annotation (Placement(transformation(extent={{-84,-38},{-64,-18}})));
  Annex60.Fluid.HeatExchangers.HeaterCooler_T idealHeaterAndCoolerWrongFlowDirection(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=6000,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
    "Steady-state model of the heater"
    annotation (Placement(transformation(extent={{22,-80},{2,-60}})));
  Annex60.Fluid.Sensors.TemperatureTwoPort senTem3(redeclare package Medium =
    Medium, m_flow_nominal=m_flow_nominal) "Temperature sensor"
    annotation (Placement(transformation(extent={{50,-34},{70,-14}})));
  Annex60.Fluid.Sensors.TemperatureTwoPort senTem4(redeclare package Medium =
    Medium, m_flow_nominal=m_flow_nominal) "Temperature sensor"
    annotation (Placement(transformation(extent={{52,-80},{72,-60}})));
equation
  connect(heaterStrongPower.port_b, senTem1.port_a) annotation (Line(
      points={{20,100},{40,100}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(heaterStrongPower.port_a, sou.ports[1]) annotation (Line(
      points={{0,100},{-40,100},{-40,53},{-60,53}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senTem1.port_b, sin.ports[1]) annotation (Line(
      points={{60,100},{100,100},{100,47},{120,47}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TSetHeat.y, heaterStrongPower.TSet) annotation (Line(
      points={{-39,150},{-12,150},{-12,106},{-2,106}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sou.ports[2], coolerWeakPower.port_a) annotation (Line(
      points={{-60,51},{-40,51},{-40,34},{0,34}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(coolerWeakPower.port_b, senTem2.port_a) annotation (Line(
      points={{20,34},{50,34}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senTem2.port_b, sin.ports[2]) annotation (Line(
      points={{70,34},{100,34},{100,49},{120,49}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TSetCool.y, coolerWeakPower.TSet) annotation (Line(
      points={{-65,12},{-12,12},{-12,40},{-2,40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sou.ports[3], idealHeaterAndCooler.port_a) annotation (Line(
      points={{-60,49},{-40,49},{-40,-24},{2,-24}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(idealHeaterAndCooler.port_b, senTem3.port_a) annotation (Line(
      points={{22,-24},{50,-24}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senTem3.port_b, sin.ports[3]) annotation (Line(
      points={{70,-24},{100,-24},{100,48},{120,48},{120,51}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TSetCoolHeat.y, idealHeaterAndCoolerWrongFlowDirection.TSet) annotation (
     Line(
      points={{-63,-28},{-54,-28},{-54,-50},{28,-50},{28,-64},{24,-64}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sou.ports[4], idealHeaterAndCoolerWrongFlowDirection.port_b)
    annotation (Line(
      points={{-60,47},{-40,47},{-40,-70},{2,-70}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(idealHeaterAndCoolerWrongFlowDirection.port_a, senTem4.port_a)
    annotation (Line(
      points={{22,-70},{52,-70}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senTem4.port_b, sin.ports[4]) annotation (Line(
      points={{72,-70},{100,-70},{100,-26},{100,-26},{100,48},{120,48},{120,53}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TSetCoolHeat.y, idealHeaterAndCooler.TSet) annotation (Line(
      points={{-63,-28},{-22,-28},{-22,-18},{0,-18}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{200,200}}), graphics),
    __Dymola_Commands(file= "modelica://Annex60/Resources/Scripts/Dymola/Fluid/HeatExchangers/Examples/HeaterCooler_T.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Model that demonstrates the use of an ideal heater and an ideal cooler.

The heater model has an almost unlimited positive power (<code>Q_flow_nominal = 1.0e10</code>),
so its outlet temperature always reaches the different levels of set temperatures during the simulation experiment. 
<p>
The cooler model has a limited negative power (<code>Q_flow_nominal = 1000</code>),
so its outlet temperature reaches only a limited value corresponding to its maximum negative power during the simulation experiment.
</p>
</html>", revisions="<html>
<ul>
<li>
March 19, 2014, by Christoph Nytsch-Geusen:<br/>
First implementation.
</li>
</ul>
</html>"),
    experiment(
      StopTime=1200,
      Tolerance=1e-05));
end HeaterCooler_T;

within IBPSA.Experimental.Pipe.Examples.Initialization;
model SinglePipeDelayInit
  "Demonstrate correct initialization of delay component when startTime is not 0"

  extends Modelica.Icons.Example;

  package Medium = IBPSA.Media.Water;
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal = 0.9
    "Nominal mass flow rate";

  parameter Modelica.SIunits.Pressure dp_test = 200
    "Differential pressure for the test used in ramps";

  Modelica.Blocks.Sources.Constant PAtm(k=101325) "Atmospheric pressure"
      annotation (Placement(transformation(extent={{126,66},{146,86}})));
  Fluid.Sources.Boundary_pT source(
    redeclare package Medium = Medium,
    use_p_in=true,
    use_T_in=true,
    nPorts=1,
    T=293.15) "Source with high pressure during experiment"
    annotation (Placement(transformation(extent={{-88,18},{-68,38}})));
  Fluid.Sources.Boundary_pT         sink(          redeclare package Medium =
        Medium,
    nPorts=1,
    use_p_in=true,
    T=283.15) "Sink at with constant pressure"
                          annotation (Placement(transformation(extent={{140,18},
            {120,38}})));
  Fluid.Sensors.MassFlowRate         masFloSer(redeclare package Medium =
        Medium) "Mass flow rate sensor for the two pipes in series"
    annotation (Placement(transformation(extent={{88,20},{108,40}})));
  Modelica.Blocks.Math.Add add "Combine input signal of two ramps"
    annotation (Placement(transformation(extent={{-118,50},{-98,70}})));
  Fluid.Sensors.TemperatureTwoPort TempSink(redeclare package Medium = Medium,
      m_flow_nominal=m_flow_nominal) "Temperature at the pipe's sink side"
    annotation (Placement(transformation(extent={{56,20},{76,40}})));
  Fluid.Sensors.TemperatureTwoPort TempSource(redeclare package Medium = Medium,
      m_flow_nominal=m_flow_nominal) "Temperature at the pipe's source side"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Modelica.Blocks.Math.Gain gain(k=dp_test)
    annotation (Placement(transformation(extent={{-160,44},{-140,64}})));
  Modelica.Blocks.Sources.CombiTimeTable pressureSignal(smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments, table=[0,
        1; 3000,1; 5000,0; 10000,0; 12000,-1; 17000,1; 19000,0; 30000,0; 32000,1;
        50000,1; 52000,0; 80000,0; 82000,-1; 100000,-1; 102000,0; 150000,0; 152000,
        1; 160000,1; 162000,0; 163500,0; 165500,1; 200000,1])
    "Signal for flow direction"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-170,90})));
  Modelica.Blocks.Sources.Sine     constTemp(
    amplitude=5,
    offset=273.15 + 55,
    freqHz=0.0005) "Constant supply temperature signal"
    annotation (Placement(transformation(extent={{-120,0},{-100,20}})));
  Fluid.FixedResistances.PlugFlow  pipeAd(
    redeclare package Medium = Medium,
    m_flow_small=1e-4,
    m_flow_nominal=m_flow_nominal,
    diameter=0.1,
    thicknessIns=0.03,
    nPorts=1,
    length=500) "Dynamic pipe adiabatic"
    annotation (Placement(transformation(extent={{0,20},{20,40}})));
  Modelica.Thermal.HeatTransfer.Celsius.FixedTemperature fixedTemperature(T=10)
    annotation (Placement(transformation(extent={{-20,60},{0,80}})));
equation
  connect(PAtm.y,sink. p_in)
                            annotation (Line(points={{147,76},{154,76},{154,36},
          {142,36}},
                   color={0,0,127}));
  connect(sink.ports[1],masFloSer. port_b) annotation (Line(
      points={{120,28},{108,30}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(add.y, source.p_in) annotation (Line(
      points={{-97,60},{-94,60},{-94,36},{-90,36}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(masFloSer.port_a, TempSink.port_b) annotation (Line(
      points={{88,30},{76,30}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(source.ports[1], TempSource.port_a) annotation (Line(
      points={{-68,28},{-60,30}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(PAtm.y, add.u1) annotation (Line(points={{147,76},{154,76},{154,100},{
          -128,100},{-128,66},{-120,66}}, color={0,0,127}));
  connect(gain.y, add.u2)
    annotation (Line(points={{-139,54},{-120,54}}, color={0,0,127}));
  connect(pressureSignal.y[1], gain.u)
    annotation (Line(points={{-170,79},{-170,54},{-162,54}}, color={0,0,127}));
  connect(source.T_in, constTemp.y) annotation (Line(points={{-90,32},{-94,32},
          {-94,10},{-99,10}}, color={0,0,127}));
  connect(TempSource.port_b, pipeAd.port_a)
    annotation (Line(points={{-40,30},{0,30}}, color={0,127,255}));
  connect(fixedTemperature.port, pipeAd.heatPort)
    annotation (Line(points={{0,70},{10,70},{10,40}}, color={191,0,0}));
  connect(pipeAd.ports_b[1], TempSink.port_a)
    annotation (Line(points={{20,30},{56,30}},         color={0,127,255}));
  annotation (Documentation(info="<html>
<p>This example shows the correct initialization of the <code>TimeDelay</code> component for a simulation start time other than 0. For correct representation of the delay, Lsodar or Euler should be used as solver.</p>
<p><b><a name=\"typical-use-and-important-parameters\">T</a>ypical use and important parameters</b></p>
<p>Start time of the example should be set to some value other than 0.</p>
</html>", revisions="<html>
<ul>
<li>May 23, 2016 by Marcus Fuchs: <br>
First implementation</li>
</ul>
</html>"),
    Diagram(coordinateSystem(extent={{-180,-120},{180,120}},
          preserveAspectRatio=false)),
    Icon(coordinateSystem(extent={{-180,-120},{180,120}})),
    experiment(
      StartTime=3000,
      StopTime=20000,
      __Dymola_NumberOfIntervals=1000,
      Tolerance=1e-006,
      __Dymola_Algorithm="LsodarS"),
    __Dymola_experimentSetupOutput,
    __Dymola_Commands(file=
          "Resources/Scripts/Dymola/Experimental/Pipe/Examples/Initialization/SinglePipeDelayInit.mos"
        "Simulate and Plot"),
    __Dymola_experimentFlags(
      Advanced(GenerateVariableDependencies=false, OutputModelicaCode=false),
      Evaluate=false,
      OutputCPUtime=false,
      OutputFlatModelica=false));
end SinglePipeDelayInit;

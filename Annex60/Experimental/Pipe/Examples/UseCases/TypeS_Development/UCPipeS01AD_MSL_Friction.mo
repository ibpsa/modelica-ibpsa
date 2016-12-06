within Annex60.Experimental.Pipe.Examples.UseCases.TypeS_Development;
model UCPipeS01AD_MSL_Friction
  "Verifying the pressure - mass flow relation for two short pipes in series compared to one long pipe"

  extends Modelica.Icons.Example;

  package Medium = Annex60.Media.Water;

  parameter Modelica.SIunits.Pressure dp_test = 200
    "Differential pressure for the test used in ramps";

  Modelica.Blocks.Sources.Constant PAtm(k=101325) "Atmospheric pressure"
      annotation (Placement(transformation(extent={{126,66},{146,86}})));
  Fluid.Sources.Boundary_pT source(
    redeclare package Medium = Medium,
    use_p_in=true,
    use_T_in=true,
    nPorts=2,
    T=293.15) "Source with high pressure during experiment"
    annotation (Placement(transformation(extent={{-88,18},{-68,38}})));
  Fluid.Sources.Boundary_pT         sink(          redeclare package Medium =
        Medium,
    nPorts=2,
    use_p_in=true,
    T=283.15) "Sink at with constant pressure"
                          annotation (Placement(transformation(extent={{140,18},
            {120,38}})));
  Fluid.Sensors.MassFlowRate         masFloSin(redeclare package Medium =
        Medium) "Mass flow rate sensor for single pipe"
    annotation (Placement(transformation(extent={{88,20},{108,40}})));
  Modelica.Blocks.Sources.Constant constTemp(k=273.15 + 60)
    "Constant supply temperature signal"
    annotation (Placement(transformation(extent={{-118,0},{-98,20}})));
  Modelica.Blocks.Math.Add add "Combine input signal of two ramps"
    annotation (Placement(transformation(extent={{-118,50},{-98,70}})));
  Fluid.Sensors.TemperatureTwoPort TempSinkSin(redeclare package Medium =
        Medium, m_flow_nominal=0.5)
    "Temperature at the pipe's sink side for single pipe"
    annotation (Placement(transformation(extent={{56,20},{76,40}})));
  Fluid.Sensors.TemperatureTwoPort TempSourceSin(redeclare package Medium =
        Medium, m_flow_nominal=0.5)
    "Temperature at the pipe's source side for single pipe"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Modelica.Fluid.Pipes.DynamicPipe pipeMSL100(
    nNodes=10,
    redeclare package Medium = Medium,
    length=100,
    diameter=0.1,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    flowModel(m_flow_small=1e-4),
    T_start=293.15) "Dynamic pipe from MSL for reference test"
    annotation (Placement(transformation(extent={{0,20},{20,40}})));
  inner Modelica.Fluid.System system "System for MSL pipe model"
    annotation (Placement(transformation(extent={{0,60},{20,80}})));
  Modelica.Blocks.Sources.Ramp reverseDP(
    duration=1800,
    offset=0,
    startTime=10000,
    height=-dp_test) "Reverse the flow after a period of zero-mass-flow"
    annotation (Placement(transformation(extent={{-160,34},{-140,54}})));
  Modelica.Blocks.Sources.Ramp decreaseP(
    duration=1800,
    startTime=5000,
    height=-dp_test,
    offset=101325 + dp_test) "Decreasing pressure difference to zero-mass-flow"
    annotation (Placement(transformation(extent={{-160,74},{-140,94}})));
  Fluid.Sensors.MassFlowRate masFloSer(redeclare package Medium = Medium)
    "Mass flow rate sensor for the two pipes in series"
    annotation (Placement(transformation(extent={{88,-40},{108,-20}})));
  Fluid.Sensors.TemperatureTwoPort TempSinkSer(redeclare package Medium =
        Medium, m_flow_nominal=0.5)
    "Temperature at the pipe's sink side for pipes in series"
    annotation (Placement(transformation(extent={{56,-40},{76,-20}})));
  Fluid.Sensors.TemperatureTwoPort TempSourceSer(redeclare package Medium =
        Medium, m_flow_nominal=0.5)
    "Temperature at the pipe's source side for pipes in series"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  Modelica.Fluid.Pipes.DynamicPipe pipeMSL50_1(
    redeclare package Medium = Medium,
    diameter=0.1,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    flowModel(m_flow_small=1e-4),
    length=50,
    T_start=293.15,
    nNodes=5) "Dynamic pipe from MSL for reference test"
    annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));
  Modelica.Fluid.Pipes.DynamicPipe pipeMSL50_2(
    redeclare package Medium = Medium,
    diameter=0.1,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    flowModel(m_flow_small=1e-4),
    length=50,
    T_start=293.15,
    nNodes=5) "Dynamic pipe from MSL for reference test"
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));
equation
  connect(PAtm.y,sink. p_in)
                            annotation (Line(points={{147,76},{154,76},{154,36},
          {142,36}},
                   color={0,0,127}));
  connect(sink.ports[1],masFloSin. port_b) annotation (Line(
      points={{120,30},{108,30}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(constTemp.y, source.T_in) annotation (Line(
      points={{-97,10},{-90,10},{-90,32}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(add.y, source.p_in) annotation (Line(
      points={{-97,60},{-94,60},{-94,36},{-90,36}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(masFloSin.port_a, TempSinkSin.port_b) annotation (Line(
      points={{88,30},{76,30}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(source.ports[1], TempSourceSin.port_a) annotation (Line(
      points={{-68,30},{-60,30}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TempSourceSin.port_b, pipeMSL100.port_a)
    annotation (Line(points={{-40,30},{0,30}}, color={0,127,255}));
  connect(pipeMSL100.port_b, TempSinkSin.port_a)
    annotation (Line(points={{20,30},{56,30}}, color={0,127,255}));
  connect(decreaseP.y, add.u1) annotation (Line(points={{-139,84},{-128,84},{
          -128,66},{-120,66}}, color={0,0,127}));
  connect(reverseDP.y, add.u2) annotation (Line(points={{-139,44},{-128,44},{
          -128,54},{-120,54}}, color={0,0,127}));
  connect(masFloSer.port_a, TempSinkSer.port_b) annotation (Line(
      points={{88,-30},{76,-30}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TempSourceSer.port_b, pipeMSL50_1.port_a)
    annotation (Line(points={{-40,-30},{-20,-30}}, color={0,127,255}));
  connect(TempSourceSer.port_a, source.ports[2])
    annotation (Line(points={{-60,-30},{-68,26}}, color={0,127,255}));
  connect(masFloSer.port_b, sink.ports[2])
    annotation (Line(points={{108,-30},{120,26}}, color={0,127,255}));
  connect(pipeMSL50_1.port_b, pipeMSL50_2.port_a)
    annotation (Line(points={{0,-30},{20,-30}}, color={0,127,255}));
  connect(pipeMSL50_2.port_b, TempSinkSer.port_a)
    annotation (Line(points={{40,-30},{56,-30}}, color={0,127,255}));
  annotation (Documentation(info="<html>
<p>This use case aims at demonstrating the pressure loss behavior of the pipe
model. In theory, two pipe models of length 50 m in series should behave the
same as one pipe model with length of 100 m. To demonstrate this behavior, the
two 50 m pipe models are placed in parallel to one 100 m pipe between a <code>source</code>
and a <code>sink</code> model. The pressure difference between <code>source</code> and <code>sink</code> is
varied following a sine function. As temperature is not relevant for this use
case, it is kept constant.</p>
<h4 id=\"typical-use-and-important-parameters\">Typical use and important parameters</h4>
<p>The maximum pressure difference between <code>source</code> and <code>sink</code> can be adjusted via
the <code>dp_test</code> variable.</p>
<h4 id=\"implementation\">Implementation</h4>
<p>In order for the MSL pipe model to check <code>True</code> in pedantic mode and simulate
without warnings, the following modifications have been added:</p>
<ul>
<li><code>energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial</code> to fix the initial
temperature values</li>
<li><code>flowModel(m_flow_small = 1e-4)</code> and <code>T_start=293.15</code> to avoid Dymola errors
regarding circular references for the start temperature and <code>m_flow_small</code> via
the <code>system</code> component</li>
</ul>
</html>", revisions="<html>
<ul>
<li>May 18, 2016 by Marcus Fuchs: <br>
First implementation</li>
</ul>
</html>"),
    Diagram(coordinateSystem(extent={{-180,-120},{180,120}},
          preserveAspectRatio=false)),
    Icon(coordinateSystem(extent={{-180,-120},{180,120}})),
    experiment(StopTime=2000, Interval=1),
    __Dymola_experimentSetupOutput,
    __Dymola_Commands(file=
          "Resources/Scripts/Dymola/Experimental/Pipe/Examples/UseCases/TypeS_Development/UCPipeS01AD_MSL_Friction.mos"
        "Simulate and Plot"));
end UCPipeS01AD_MSL_Friction;

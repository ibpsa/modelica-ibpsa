within Annex60.Experimental.Pipe.Examples.UseCases.TypeA_NoFlowReversal;
model UCPipeA04HL_ZeroFlow
  "Demonstrating non-adiabatic pipe model with varying flow velocities and zero mass flow"

  extends Modelica.Icons.Example;

  package Medium = Annex60.Media.Water;
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
  Modelica.Blocks.Sources.Constant constTemp(k=273.15 + 60)
    "Constant supply temperature signal"
    annotation (Placement(transformation(extent={{-118,0},{-98,20}})));
  Modelica.Blocks.Math.Add add "Combine input signal of two ramps"
    annotation (Placement(transformation(extent={{-118,50},{-98,70}})));
  Fluid.Sensors.TemperatureTwoPort TempSink(redeclare package Medium = Medium,
      m_flow_nominal=m_flow_nominal) "Temperature at the pipe's sink side"
    annotation (Placement(transformation(extent={{56,20},{76,40}})));
  Fluid.Sensors.TemperatureTwoPort TempSource(redeclare package Medium = Medium,
      m_flow_nominal=m_flow_nominal) "Temperature at the pipe's source side"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Modelica.Blocks.Sources.CombiTimeTable pressureSignal(smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
      table=[0,1; 5000,0; 10000,1; 15000,0.25; 20000,0; 25000,1; 30000,0; 35000,
        0.25; 40000,0.25]) "Signal with intervals of zero pressure difference"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-170,90})));
  Modelica.Blocks.Math.Gain gain(k=dp_test)
    annotation (Placement(transformation(extent={{-160,44},{-140,64}})));
  PipeHeatLossMod pipeAd(
    redeclare package Medium = Medium,
    length=100,
    m_flow_small=1e-4,
    m_flow_nominal=m_flow_nominal,
    diameter=0.1,
    thicknessIns=0.02) "Dynamic pipe adiabatic"
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
  connect(constTemp.y, source.T_in) annotation (Line(
      points={{-97,10},{-90,10},{-90,32}},
      color={0,0,127},
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
  connect(pressureSignal.y[1],gain. u)
    annotation (Line(points={{-170,79},{-170,54},{-162,54}},
                                                   color={0,0,127}));
  connect(gain.y, add.u2)
    annotation (Line(points={{-139,54},{-120,54}}, color={0,0,127}));
  connect(TempSource.port_b, pipeAd.port_a)
    annotation (Line(points={{-40,30},{0,30}}, color={0,127,255}));
  connect(pipeAd.port_b, TempSink.port_a)
    annotation (Line(points={{20,30},{56,30}}, color={0,127,255}));
  connect(fixedTemperature.port, pipeAd.heatPort)
    annotation (Line(points={{0,70},{10,70},{10,40}}, color={191,0,0}));
  annotation (Documentation(info="<html>
<p>This use case aims at showing the model behavior with longer intervals of zero
mass flow. Therefore, the pressure difference between <code>source</code> and <code>sink</code> varies
pseudo-randomly between intervals of different values for different lengths,
some of them with a pressure difference of 0 resulting in zero mass flow. The
supply temperature at <code>source</code> is kept constant.</p>
<p>In the case with heat losses taken into account, there should be realistic heat
losses also during intervals of zero mass flow.</p>
<h4 id=\"typical-use-and-important-parameters\">Typical use and important parameters</h4>
<p>The maximum pressure difference between <code>source</code> and <code>sink</code> can be adjusted via
the <code>dp_test</code> variable.</p>
</html>", revisions="<html>
<ul>
<li>May 23, 2016 by Marcus Fuchs: <br>
First implementation</li>
</ul>
</html>"),
    Diagram(coordinateSystem(extent={{-180,-120},{180,120}},
          preserveAspectRatio=false)),
    Icon(coordinateSystem(extent={{-180,-120},{180,120}})),
    experiment(StopTime=40000, Interval=1),
    __Dymola_experimentSetupOutput,
    __Dymola_Commands(file=
          "Resources/Scripts/Dymola/Experimental/Pipe/Examples/UseCases/TypeA_NoFlowReversal/UCPipeA04HL_ZeroFlow.mos"
        "Simulate and Plot"));
end UCPipeA04HL_ZeroFlow;

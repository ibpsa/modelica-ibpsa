within Annex60.Experimental.Pipe.Examples.PipeAdiabatic;
model PipeAdiabatic_TStep
  "Test of adiabatic pipe model with temperature step, zero-mass-flow and flow reversal"
  import TLMPipe;
  import Annex60;
  extends Modelica.Icons.Example;

 package Medium = Annex60.Media.Water;
    Modelica.Blocks.Sources.Constant PAtm(k=101325)
      annotation (Placement(transformation(extent={{126,76},{146,96}})));
    Annex60.Experimental.Pipe.PipeAdiabatic pipe50_1(
    redeclare package Medium = Medium,
    L=50,
    m_flow_nominal=0.5) "Pipe 1 in series of two 50 m pipes"
    annotation (Placement(transformation(extent={{-28,28},{-8,48}})));
  Annex60.Fluid.Sources.Boundary_pT sou1(          redeclare package Medium =
        Medium,
    use_p_in=true,
    use_T_in=true,
    T=293.15,
    nPorts=2)             annotation (Placement(transformation(extent={{-88,28},
            {-68,48}})));
  Annex60.Fluid.Sources.Boundary_pT sin1(          redeclare package Medium =
        Medium,
    nPorts=2,
    use_p_in=true,
    T=283.15)             annotation (Placement(transformation(extent={{140,28},
            {120,48}})));
  Annex60.Fluid.Sensors.MassFlowRate masFloNM(redeclare package Medium = Medium)
    "Mass flow rate sensor"
    annotation (Placement(transformation(extent={{88,28},{108,48}})));

  Modelica.Blocks.Sources.Step step(
    height=10,
    startTime=20,
    offset=273.15 + 20)
    annotation (Placement(transformation(extent={{-118,10},{-98,30}})));
  Modelica.Blocks.Sources.Ramp ramp(
    duration=1800,
    startTime=5000,
    height=-2000,
    offset=101325 + 2000)
    annotation (Placement(transformation(extent={{-156,80},{-136,100}})));
  Modelica.Blocks.Sources.Ramp ramp1(
    duration=1800,
    offset=0,
    startTime=10000,
    height=-2000)
    annotation (Placement(transformation(extent={{-156,40},{-136,60}})));
  Modelica.Blocks.Math.Add add
    annotation (Placement(transformation(extent={{-118,60},{-98,80}})));
    Annex60.Experimental.Pipe.PipeAdiabatic pipe50_2(
    redeclare package Medium = Medium,
    L=50,
    m_flow_nominal=0.5) "Pipe 2 of two 50 m pipes in series"
    annotation (Placement(transformation(extent={{36,28},{56,48}})));
  Annex60.Fluid.Sensors.TemperatureTwoPort senTemOut(
                                                    redeclare package Medium =
        Medium, m_flow_nominal=0.5)
    annotation (Placement(transformation(extent={{62,28},{82,48}})));
  Annex60.Fluid.Sensors.TemperatureTwoPort senTemIn(redeclare package Medium =
        Medium, m_flow_nominal=0.5)
    annotation (Placement(transformation(extent={{-60,28},{-40,48}})));
    Annex60.Experimental.Pipe.PipeAdiabatic pipe100(
    redeclare package Medium = Medium,
    L=100,
    m_flow_nominal=0.5) "Pipe with 100 m length in parallel to 2 x 50 m pipes"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={20,-20})));
  Annex60.Fluid.Sensors.MassFlowRate masFloNM1(
                                              redeclare package Medium = Medium)
    "Mass flow rate sensor"
    annotation (Placement(transformation(extent={{88,-30},{108,-10}})));
  Annex60.Fluid.Sensors.TemperatureTwoPort senTemOut1(
                                                    redeclare package Medium =
        Medium, m_flow_nominal=0.5)
    annotation (Placement(transformation(extent={{56,-30},{76,-10}})));
  Annex60.Fluid.Sensors.TemperatureTwoPort senTemIn1(
                                                    redeclare package Medium =
        Medium, m_flow_nominal=0.5)
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
equation
  connect(PAtm.y, sin1.p_in)
                            annotation (Line(points={{147,86},{154,86},{154,46},
          {142,46}},
                   color={0,0,127}));
  connect(sin1.ports[1], masFloNM.port_b) annotation (Line(
      points={{120,40},{114,40},{114,38},{108,38}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(step.y, sou1.T_in) annotation (Line(
      points={{-97,20},{-90,20},{-90,42}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ramp.y, add.u1) annotation (Line(
      points={{-135,90},{-130,90},{-130,76},{-120,76}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ramp1.y, add.u2) annotation (Line(
      points={{-135,50},{-128,50},{-128,64},{-120,64}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(add.y, sou1.p_in) annotation (Line(
      points={{-97,70},{-94,70},{-94,46},{-90,46}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pipe50_2.port_b, senTemOut.port_a) annotation (Line(
      points={{56,38},{62,38}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(masFloNM.port_a, senTemOut.port_b) annotation (Line(
      points={{88,38},{82,38}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sou1.ports[1], senTemIn.port_a) annotation (Line(
      points={{-68,40},{-64,40},{-64,38},{-60,38}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pipe50_1.port_a, senTemIn.port_b) annotation (Line(
      points={{-28,38},{-40,38}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pipe50_1.port_b, pipe50_2.port_a) annotation (Line(
      points={{-8,38},{36,38}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(masFloNM1.port_a, senTemOut1.port_b) annotation (Line(
      points={{88,-20},{76,-20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sou1.ports[2], senTemIn1.port_a) annotation (Line(
      points={{-68,36},{-66,36},{-66,-20},{-60,-20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(masFloNM1.port_b, sin1.ports[2]) annotation (Line(
      points={{108,-20},{114,-20},{114,36},{120,36}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pipe100.port_a, senTemIn1.port_b) annotation (Line(
      points={{10,-20},{-40,-20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pipe100.port_b, senTemOut1.port_a) annotation (Line(
      points={{30,-20},{56,-20}},
      color={0,127,255},
      smooth=Smooth.None));
    annotation (experiment(StopTime=20000, __Dymola_NumberOfIntervals=5000),
__Dymola_Commands(file="modelica://Annex60/Resources/Scripts/Dymola/Fluid/FixedResistances/Examples/FixedResistancesParallel.mos"
        "Simulate and plot"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-160,-100},{
            160,100}}), graphics),
    __Dymola_experimentSetupOutput,
    Icon(coordinateSystem(extent={{-160,-100},{160,100}})));
end PipeAdiabatic_TStep;

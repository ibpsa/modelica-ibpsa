within Annex60.Experimental.Pipe.Examples.Comparisons;
model SpatialDistributionOperator
  "Comparison of KUL A60 pipes with heat loss without reverse flow"
  import Annex60;
  extends Modelica.Icons.Example;

  package Medium = Annex60.Media.Water;

  parameter Modelica.SIunits.Diameter diameter=0.1 "Pipe diameter";
  parameter Modelica.SIunits.Length length=100 "Pipe length";
  parameter Modelica.SIunits.Pressure dp_test = 200
    "Differential pressure for the test used in ramps";

  Modelica.Blocks.Sources.Constant PAtm(k=101325) "Atmospheric pressure"
      annotation (Placement(transformation(extent={{126,42},{146,62}})));

  Annex60.Fluid.Sources.Boundary_pT sou1(          redeclare package Medium =
        Medium,
    use_p_in=true,
    use_T_in=true,
    nPorts=1,
    T=293.15)
    "Source with high pressure at beginning and lower pressure at end of experiment"
                          annotation (Placement(transformation(extent={{-86,-8},
            {-66,12}})));
  Annex60.Fluid.Sources.Boundary_pT sin1(          redeclare package Medium =
        Medium,
    nPorts=1,
    use_p_in=true,
    T=283.15)
    "Sink at with constant pressure, turns into source at the end of experiment"
                          annotation (Placement(transformation(extent={{140,-6},
            {120,14}})));

  Modelica.Blocks.Sources.Step stepT(
    height=10,
    offset=273.15 + 20,
    startTime=10000)
    "Step temperature increase to test propagation of temperature wave"
    annotation (Placement(transformation(extent={{-134,-28},{-114,-8}})));
  Modelica.Blocks.Sources.CombiTimeTable combiTimeTable(smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments, table=[0,
        1; 3000,1; 5000,0; 10000,0; 12000,-1; 17000,1; 19000,0; 30000,0; 32000,1;
        50000,1; 52000,0; 80000,0; 82000,-1; 100000,-1; 102000,0; 150000,0; 152000,
        1; 160000,1; 162000,0; 163500,0; 165500,1; 200000,1])
    annotation (Placement(transformation(extent={{-190,26},{-170,46}})));
  Modelica.Blocks.Math.Gain gain(k=dp_test)
    annotation (Placement(transformation(extent={{-150,26},{-130,46}})));
  Modelica.Blocks.Math.Add add
    annotation (Placement(transformation(extent={{-118,32},{-98,52}})));
  Modelica.Blocks.Sources.Constant PAtm1(
                                        k=101325) "Atmospheric pressure"
      annotation (Placement(transformation(extent={{-158,54},{-138,74}})));
  Modelica.Blocks.Sources.Constant const3(k=273.15 + 5);

  Annex60.Fluid.Sensors.TemperatureTwoPort senTemA60In1(
                                                       redeclare package Medium =
        Medium, m_flow_nominal=0.5)
    "Temperature of the inflow to the A60 temperature delay"
    annotation (Placement(transformation(extent={{-56,-56},{-36,-36}})));
  Annex60.Fluid.Sensors.TemperatureTwoPort senTemA60Out1(
                                                        redeclare package
      Medium = Medium, m_flow_nominal=0.5)
    "Temperature sensor for the outflow of the A60 temperature delay"
    annotation (Placement(transformation(extent={{50,-56},{70,-36}})));
  Annex60.Fluid.Sensors.MassFlowRate masFloA1( redeclare package Medium =
        Medium) "Mass flow rate sensor for the A60 temperature delay"
    annotation (Placement(transformation(extent={{78,-60},{98,-40}})));
  Annex60.Experimental.Pipe.BaseClasses.SpatialDistributionOneDirection
    spatialDist_test_Reverse(length=length)
    annotation (Placement(transformation(extent={{-78,-94},{-38,-74}})));
  Modelica.Blocks.Sources.RealExpression v_reverse(y=-PipeDelayMod.tau_used.v)
    "Atmospheric pressure"
    annotation (Placement(transformation(extent={{-200,-94},{-120,-74}})));
  Annex60.Experimental.Pipe.BaseClasses.SpatialDistributionOneDirection
    spatialDist_test(length=length)
    annotation (Placement(transformation(extent={{-80,-114},{-40,-94}})));
  Modelica.Blocks.Sources.RealExpression v(y=PipeDelayMod.tau_used.v)
    "Atmospheric pressure"
    annotation (Placement(transformation(extent={{-200,-114},{-120,-94}})));
  Annex60.Experimental.Pipe.BaseClasses.SpatialDistributionTwoDirections
    spatialDist_testBothDirections(length=length)
    annotation (Placement(transformation(extent={{-82,-144},{-22,-124}})));
  Annex60.Experimental.Pipe.BaseClasses.SpatialDistributionTwoDirectionsAndTrack
    spatialDist_testBothDirections_andTrack(length=length)
    annotation (Placement(transformation(extent={{-80,-174},{-20,-154}})));
  Annex60.Fluid.Sources.Boundary_pT sou2(          redeclare package Medium =
        Medium,
    use_p_in=true,
    use_T_in=true,
    nPorts=1,
    T=293.15)
    "Source with high pressure at beginning and lower pressure at end of experiment"
                          annotation (Placement(transformation(extent={{-98,110},
            {-78,130}})));
  Annex60.Fluid.Sources.Boundary_pT sin2(          redeclare package Medium =
        Medium,
    nPorts=1,
    use_p_in=true,
    T=283.15)
    "Sink at with constant pressure, turns into source at the end of experiment"
                          annotation (Placement(transformation(extent={{128,112},
            {108,132}})));
  Annex60.Experimental.Pipe.Archive.PipeHeatLoss PipeDelay(
    redeclare package Medium = Medium,
    m_flow_small=1e-4*0.5,
    diameter=diameter,
    length=length,
    m_flow_nominal=0.5,
    thicknessIns=0.02,
    lambdaI=0.01)
    annotation (Placement(transformation(extent={{2,62},{22,82}})));
  Annex60.Fluid.Sensors.TemperatureTwoPort senTemA60In2(
                                                       redeclare package Medium =
        Medium, m_flow_nominal=0.5)
    "Temperature of the inflow to the A60 temperature delay"
    annotation (Placement(transformation(extent={{-68,62},{-48,82}})));
  Annex60.Fluid.Sensors.TemperatureTwoPort senTemA60Out2(
                                                        redeclare package
      Medium = Medium, m_flow_nominal=0.5)
    "Temperature sensor for the outflow of the A60 temperature delay"
    annotation (Placement(transformation(extent={{38,62},{58,82}})));
  Annex60.Fluid.Sensors.MassFlowRate masFloA2( redeclare package Medium =
        Medium) "Mass flow rate sensor for the A60 temperature delay"
    annotation (Placement(transformation(extent={{68,62},{88,82}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=
        278.15) annotation (Placement(transformation(extent={{-8,-16},{12,4}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature1(T=
        278.15)
    annotation (Placement(transformation(extent={{-22,110},{-2,130}})));
  Annex60.Experimental.Pipe.PipeHeatLossMod PipeDelayMod(
    diameter=diameter,
    length=length,
    thicknessIns=0.02,
    redeclare package Medium = Medium,
    m_flow_nominal=0.5)
    annotation (Placement(transformation(extent={{14,-56},{34,-36}})));
equation
  connect(PAtm.y, sin1.p_in)
                            annotation (Line(points={{147,52},{154,52},{154,12},
          {142,12}},
                   color={0,0,127}));
  connect(stepT.y, sou1.T_in) annotation (Line(
      points={{-113,-18},{-88,-18},{-88,6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(combiTimeTable.y[1], gain.u)
    annotation (Line(points={{-169,36},{-152,36}}, color={0,0,127}));
  connect(gain.y, add.u2)
    annotation (Line(points={{-129,36},{-120,36}},        color={0,0,127}));
  connect(PAtm1.y, add.u1) annotation (Line(points={{-137,64},{-124,64},{-124,
          48},{-120,48}},
                     color={0,0,127}));
  connect(add.y, sou1.p_in) annotation (Line(points={{-97,42},{-88,42},{-88,22},
          {-98,22},{-98,10},{-88,10}}, color={0,0,127}));
  connect(sou1.ports[1], senTemA60In1.port_a) annotation (Line(
      points={{-66,2},{-66,-46},{-56,-46}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senTemA60Out1.port_b, masFloA1.port_a) annotation (Line(
      points={{70,-46},{74,-46},{74,-50},{78,-50}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(masFloA1.port_b, sin1.ports[1]) annotation (Line(
      points={{98,-50},{110,-50},{110,-52},{120,-52},{120,4}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(v_reverse.y, spatialDist_test_Reverse.v) annotation (Line(
      points={{-116,-84},{-78,-84}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(v.y, spatialDist_test.v) annotation (Line(
      points={{-116,-104},{-80,-104}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(v.y, spatialDist_testBothDirections.v) annotation (Line(
      points={{-116,-104},{-118,-104},{-118,-134},{-82,-134}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(v.y, spatialDist_testBothDirections_andTrack.v) annotation (Line(
      points={{-116,-104},{-116,-164},{-80,-164}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sou2.ports[1],senTemA60In2. port_a) annotation (Line(
      points={{-78,120},{-78,72},{-68,72}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senTemA60Out2.port_b,masFloA2. port_a) annotation (Line(
      points={{58,72},{68,72}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(masFloA2.port_b,sin2. ports[1]) annotation (Line(
      points={{88,72},{108,72},{108,122}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(stepT.y, sou2.T_in) annotation (Line(
      points={{-113,-18},{-92,-18},{-92,120},{-100,120},{-100,124}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(add.y, sou2.p_in) annotation (Line(
      points={{-97,42},{-97,108},{-118,108},{-118,132},{-100,132},{-100,128}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(PAtm.y, sin2.p_in) annotation (Line(
      points={{147,52},{150,52},{150,56},{152,56},{152,130},{130,130}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(senTemA60In1.port_b, PipeDelayMod.port_a) annotation (Line(points={{-36,-46},
          {-12,-46},{14,-46}},          color={0,127,255}));
  connect(PipeDelayMod.port_b, senTemA60Out1.port_a)
    annotation (Line(points={{34,-46},{42,-46},{50,-46}}, color={0,127,255}));
  connect(senTemA60In2.port_b, PipeDelay.port_a)
    annotation (Line(points={{-48,72},{2,72}},           color={0,127,255}));
  connect(PipeDelay.port_b, senTemA60Out2.port_a)
    annotation (Line(points={{22,72},{38,72}},            color={0,127,255}));
  connect(fixedTemperature.port, PipeDelayMod.heatPort)
    annotation (Line(points={{12,-6},{24,-6},{24,-36}},color={191,0,0}));
  connect(fixedTemperature1.port, PipeDelay.heatPort)
    annotation (Line(points={{-2,120},{12,120},{12,82}},  color={191,0,0}));
    annotation (Placement(transformation(extent={{14,-22},{34,-2}})),
                experiment(StopTime=200000, __Dymola_NumberOfIntervals=5000),Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-200,
            -180},{160,140}})));
end SpatialDistributionOperator;

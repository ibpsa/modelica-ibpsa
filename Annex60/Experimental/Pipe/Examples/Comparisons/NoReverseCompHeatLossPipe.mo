within Annex60.Experimental.Pipe.Examples.Comparisons;
model NoReverseCompHeatLossPipe
  "Comparison of KUL A60 pipes with heat loss without reverse flow"
  import Annex60;
  extends Modelica.Icons.Example;

  package Medium = Annex60.Media.Water;

  parameter Modelica.SIunits.Diameter diameter=0.1 "Pipe diameter";
  parameter Modelica.SIunits.Length length=100 "Pipe length";

  parameter Modelica.SIunits.Pressure dp_test = 200
    "Differential pressure for the test used in ramps";

  Modelica.Blocks.Sources.Constant PAtm(k=101325) "Atmospheric pressure"
      annotation (Placement(transformation(extent={{126,76},{146,96}})));

  Annex60.Fluid.Sources.Boundary_pT sou1(          redeclare package Medium =
        Medium,
    use_p_in=true,
    use_T_in=true,
    nPorts=4,
    T=293.15)
    "Source with high pressure at beginning and lower pressure at end of experiment"
                          annotation (Placement(transformation(extent={{-88,28},
            {-68,48}})));
  Annex60.Fluid.Sources.Boundary_pT sin1(          redeclare package Medium =
        Medium,
    nPorts=4,
    use_p_in=true,
    T=283.15)
    "Sink at with constant pressure, turns into source at the end of experiment"
                          annotation (Placement(transformation(extent={{140,28},
            {120,48}})));
  Annex60.Fluid.Sensors.MassFlowRate masFloA60(redeclare package Medium =
        Medium) "Mass flow rate sensor for the A60 temperature delay"
    annotation (Placement(transformation(extent={{88,30},{108,50}})));

  Modelica.Blocks.Sources.Step stepT(
    height=10,
    offset=273.15 + 20,
    startTime=10000)
    "Step temperature increase to test propagation of temperature wave"
    annotation (Placement(transformation(extent={{-120,20},{-100,40}})));
  Annex60.Experimental.Pipe.PipeHeatLossA60Ref A60PipeHeatLoss(
    redeclare package Medium = Medium,
    m_flow_small=1e-4*0.5,
    diameter=diameter,
    length=length,
    m_flow_nominal=0.5,
    thicknessIns=0.02,
    thermTransmissionCoeff=0.03) "Annex 60 pipe with heat losses"
    annotation (Placement(transformation(extent={{20,30},{40,50}})));
  Annex60.Fluid.Sensors.TemperatureTwoPort senTemA60Out(redeclare package
      Medium = Medium, m_flow_nominal=0.5)
    "Temperature sensor for the outflow of the A60 temperature delay"
    annotation (Placement(transformation(extent={{56,30},{76,50}})));
  Annex60.Fluid.Sensors.TemperatureTwoPort senTemA60In(redeclare package Medium
      = Medium, m_flow_nominal=0.5)
    "Temperature of the inflow to the A60 temperature delay"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
    Annex60.Experimental.Pipe.PipeHeatLossKUL
                          KULHeatLoss(
    redeclare package Medium = Medium,
    m_flow_nominal=0.5,
    diameter=diameter,
    length=length,
    thicknessIns=0.02,
    lambdaI=0.01) "KUL implementation of plug flow pipe with heat losses"
                                                               annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={30,-20})));
  Annex60.Fluid.Sensors.MassFlowRate masFloKUL(
                                              redeclare package Medium = Medium)
    "Mass flow rate sensor for the KUL lossless pipe"
    annotation (Placement(transformation(extent={{88,-30},{108,-10}})));
  Annex60.Fluid.Sensors.TemperatureTwoPort senTemKULOut(redeclare package
      Medium = Medium, m_flow_nominal=0.5)
    "Temperature sensor for the outflow from the KUL lossless pipe"
    annotation (Placement(transformation(extent={{56,-30},{76,-10}})));
  Annex60.Fluid.Sensors.TemperatureTwoPort senTemKULIn(redeclare package Medium
      = Medium, m_flow_nominal=0.5)
    "Temperature sensor of the inflow to the KUL lossless pipe"
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
  Modelica.Blocks.Sources.Constant const(k=273.15 + 5)
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));
    Annex60.Experimental.Pipe.PipeHeatLossKUL_modified KULHeatLoss_mod(
    redeclare package Medium = Medium,
    m_flow_nominal=0.5,
    diameter=diameter,
    length=length,
    thicknessIns=0.02,
    lambdaI=0.01) "KUL implementation of plug flow pipe with heat losses"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={30,-70})));
  Annex60.Fluid.Sensors.MassFlowRate masFloKUL1(
                                              redeclare package Medium = Medium)
    "Mass flow rate sensor for the KUL lossless pipe"
    annotation (Placement(transformation(extent={{88,-80},{108,-60}})));
  Annex60.Fluid.Sensors.TemperatureTwoPort senTemKULOut1(
                                                        redeclare package
      Medium = Medium, m_flow_nominal=0.5)
    "Temperature sensor for the outflow from the KUL lossless pipe"
    annotation (Placement(transformation(extent={{56,-80},{76,-60}})));
  Annex60.Fluid.Sensors.TemperatureTwoPort senTemKULIn1(
                                                       redeclare package Medium
      = Medium, m_flow_nominal=0.5)
    "Temperature sensor of the inflow to the KUL lossless pipe"
    annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));
  Modelica.Blocks.Sources.Constant const1(
                                         k=273.15 + 5)
    annotation (Placement(transformation(extent={{-20,-50},{0,-30}})));
    Annex60.Experimental.Pipe.PipeHeatLossKUL_Reverse KULHeatLoss_reverse(
    redeclare package Medium = Medium,
    m_flow_nominal=0.5,
    diameter=diameter,
    length=length,
    thicknessIns=0.02,
    lambdaI=0.01) "KUL implementation of plug flow pipe with heat losses"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={28,-128})));
  Annex60.Fluid.Sensors.MassFlowRate masFloKUL2(
                                              redeclare package Medium = Medium)
    "Mass flow rate sensor for the KUL lossless pipe"
    annotation (Placement(transformation(extent={{86,-138},{106,-118}})));
  Annex60.Fluid.Sensors.TemperatureTwoPort senTemKULOut2(
                                                        redeclare package
      Medium = Medium, m_flow_nominal=0.5)
    "Temperature sensor for the outflow from the KUL lossless pipe"
    annotation (Placement(transformation(extent={{54,-138},{74,-118}})));
  Annex60.Fluid.Sensors.TemperatureTwoPort senTemKULIn2(
                                                       redeclare package Medium
      = Medium, m_flow_nominal=0.5)
    "Temperature sensor of the inflow to the KUL lossless pipe"
    annotation (Placement(transformation(extent={{-62,-138},{-42,-118}})));
  Modelica.Blocks.Sources.Constant const2(
                                         k=273.15 + 5)
    annotation (Placement(transformation(extent={{-22,-108},{-2,-88}})));
  Modelica.Blocks.Sources.CombiTimeTable combiTimeTable(smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
      table=[0,1; 3000,1; 5000,0; 10000,0; 12000,1; 17000,1; 19000,0; 30000,0;
        32000,1; 50000,1; 52000,0; 80000,0; 82000,1; 100000,1; 102000,0; 150000,
        0; 152000,1; 160000,1; 162000,0; 163500,0; 165500,1; 200000,1])
    annotation (Placement(transformation(extent={{-160,60},{-140,80}})));
  Modelica.Blocks.Math.Gain gain(k=dp_test)
    annotation (Placement(transformation(extent={{-120,60},{-100,80}})));
  Modelica.Blocks.Math.Add add
    annotation (Placement(transformation(extent={{-88,66},{-68,86}})));
  Modelica.Blocks.Sources.Constant PAtm1(
                                        k=101325) "Atmospheric pressure"
      annotation (Placement(transformation(extent={{-128,88},{-108,108}})));
equation
  connect(PAtm.y, sin1.p_in)
                            annotation (Line(points={{147,86},{154,86},{154,46},
          {142,46}},
                   color={0,0,127}));
  connect(sin1.ports[1],masFloA60. port_b) annotation (Line(
      points={{120,41},{114,41},{114,40},{108,40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(stepT.y, sou1.T_in) annotation (Line(
      points={{-99,30},{-90,30},{-90,42}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(A60PipeHeatLoss.port_b, senTemA60Out.port_a) annotation (Line(
      points={{40,40},{56,40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(masFloA60.port_a,senTemA60Out. port_b) annotation (Line(
      points={{88,40},{76,40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sou1.ports[1],senTemA60In. port_a) annotation (Line(
      points={{-68,41},{-64,41},{-64,40},{-60,40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(masFloKUL.port_a,senTemKULOut. port_b) annotation (Line(
      points={{88,-20},{76,-20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sou1.ports[2],senTemKULIn. port_a) annotation (Line(
      points={{-68,39},{-66,39},{-66,-20},{-60,-20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(masFloKUL.port_b, sin1.ports[2]) annotation (Line(
      points={{108,-20},{114,-20},{114,39},{120,39}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(KULHeatLoss.port_b, senTemKULOut.port_a) annotation (Line(
      points={{40,-20},{56,-20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senTemA60In.port_b, A60PipeHeatLoss.port_a)
    annotation (Line(points={{-40,40},{20,40}}, color={0,127,255}));
  connect(senTemKULIn.port_b,KULHeatLoss. port_a)
    annotation (Line(points={{-40,-20},{20,-20}}, color={0,127,255}));
  connect(const.y,KULHeatLoss. TBoundary)
    annotation (Line(points={{1,10},{30,10},{30.2,-15}}, color={0,0,127}));
  connect(masFloKUL1.port_a, senTemKULOut1.port_b) annotation (Line(
      points={{88,-70},{76,-70}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(KULHeatLoss_mod.port_b, senTemKULOut1.port_a) annotation (Line(
      points={{40,-70},{56,-70}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senTemKULIn1.port_b, KULHeatLoss_mod.port_a)
    annotation (Line(points={{-40,-70},{20,-70}}, color={0,127,255}));
  connect(const1.y, KULHeatLoss_mod.TBoundary)
    annotation (Line(points={{1,-40},{30,-40},{30.2,-65}}, color={0,0,127}));
  connect(masFloKUL2.port_a, senTemKULOut2.port_b) annotation (Line(
      points={{86,-128},{74,-128}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(KULHeatLoss_reverse.port_b, senTemKULOut2.port_a) annotation (Line(
      points={{38,-128},{54,-128}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senTemKULIn2.port_b, KULHeatLoss_reverse.port_a)
    annotation (Line(points={{-42,-128},{18,-128}}, color={0,127,255}));
  connect(const2.y, KULHeatLoss_reverse.TBoundary)
    annotation (Line(points={{-1,-98},{28,-98},{28.2,-123}}, color={0,0,127}));
  connect(masFloKUL1.port_b, sin1.ports[3]) annotation (Line(
      points={{108,-70},{118,-70},{118,-72},{120,-72},{120,37}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(masFloKUL2.port_b, sin1.ports[4]) annotation (Line(
      points={{106,-128},{116,-128},{116,35},{120,35}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senTemKULIn2.port_a, sou1.ports[3]) annotation (Line(
      points={{-62,-128},{-68,-128},{-68,-124},{-68,-124},{-68,37}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senTemKULIn1.port_a, sou1.ports[4]) annotation (Line(
      points={{-60,-70},{-68,-70},{-68,35}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(combiTimeTable.y[1], gain.u)
    annotation (Line(points={{-139,70},{-122,70}}, color={0,0,127}));
  connect(gain.y, add.u2)
    annotation (Line(points={{-99,70},{-90,70},{-90,70}}, color={0,0,127}));
  connect(PAtm1.y, add.u1) annotation (Line(points={{-107,98},{-94,98},{-94,82},
          {-90,82}}, color={0,0,127}));
  connect(add.y, sou1.p_in) annotation (Line(points={{-67,76},{-54,76},{-54,56},
          {-98,56},{-98,46},{-90,46}}, color={0,0,127}));
    annotation (experiment(StopTime=200000, __Dymola_NumberOfIntervals=5000),
__Dymola_Commands(file="modelica://Annex60/Resources/Scripts/Dymola/Experimental/PipeAdiabatic/PipeAdiabatic_TStep.mos"
        "Simulate and plot"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-160,-180},{
            160,100}})),
    Documentation(info="<html>
<p>This example compares the KUL and A60 pipe with heat loss implementations.</p>
<p>This is only a first glimpse at the general behavior. Next step is to parameterize 
both models with comparable heat insulation properties. In general, the KUL pipe seems 
to react better to changes in mass flow rate, but also does not show cooling effects at 
the period of zero-mass flow.</p>
</html>", revisions="<html>
<ul>
<li>
October 1, 2015 by Marcus Fuchs:<br/>
First implementation.
</li>
</ul>
</html>"),
    __Dymola_experimentSetupOutput);
end NoReverseCompHeatLossPipe;

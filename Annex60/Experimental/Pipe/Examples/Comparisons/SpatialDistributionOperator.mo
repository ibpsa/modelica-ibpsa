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
      annotation (Placement(transformation(extent={{126,76},{146,96}})));

  Annex60.Fluid.Sources.Boundary_pT sou1(          redeclare package Medium =
        Medium,
    use_p_in=true,
    use_T_in=true,
    nPorts=1,
    T=293.15)
    "Source with high pressure at beginning and lower pressure at end of experiment"
                          annotation (Placement(transformation(extent={{-86,26},
            {-66,46}})));
  Annex60.Fluid.Sources.Boundary_pT sin1(          redeclare package Medium =
        Medium,
    nPorts=1,
    use_p_in=true,
    T=283.15)
    "Sink at with constant pressure, turns into source at the end of experiment"
                          annotation (Placement(transformation(extent={{140,28},
            {120,48}})));

  Modelica.Blocks.Sources.Step stepT(
    height=10,
    offset=273.15 + 20,
    startTime=10000)
    "Step temperature increase to test propagation of temperature wave"
    annotation (Placement(transformation(extent={{-120,20},{-100,40}})));
  Modelica.Blocks.Sources.CombiTimeTable combiTimeTable(smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments, table=[0,
        1; 3000,1; 5000,0; 10000,0; 12000,-1; 17000,1; 19000,0; 30000,0; 32000,1;
        50000,1; 52000,0; 80000,0; 82000,-1; 100000,-1; 102000,0; 150000,0; 152000,
        1; 160000,1; 162000,0; 163500,0; 165500,1; 200000,1])
    annotation (Placement(transformation(extent={{-190,60},{-170,80}})));
  Modelica.Blocks.Math.Gain gain(k=dp_test)
    annotation (Placement(transformation(extent={{-150,60},{-130,80}})));
  Modelica.Blocks.Math.Add add
    annotation (Placement(transformation(extent={{-118,66},{-98,86}})));
  Modelica.Blocks.Sources.Constant PAtm1(
                                        k=101325) "Atmospheric pressure"
      annotation (Placement(transformation(extent={{-158,88},{-138,108}})));
  Modelica.Blocks.Sources.Constant const3(k=5)
    annotation (Placement(transformation(extent={{0,60},{20,80}})));
  Annex60.Experimental.Pipe.PipeHeatLossA60Mod2 A60PipeHeatLossMod2(
    redeclare package Medium = Medium,
    m_flow_small=1e-4*0.5,
    diameter=diameter,
    length=length,
    m_flow_nominal=0.5,
    thicknessIns=0.02,
    lambdaI=0.01) "Annex 60 modified pipe with heat losses"
    annotation (Placement(transformation(extent={{14,-22},{34,-2}})));
  Annex60.Fluid.Sensors.TemperatureTwoPort senTemA60In1(
                                                       redeclare package Medium
      = Medium, m_flow_nominal=0.5)
    "Temperature of the inflow to the A60 temperature delay"
    annotation (Placement(transformation(extent={{-56,-22},{-36,-2}})));
  Annex60.Fluid.Sensors.TemperatureTwoPort senTemA60Out1(
                                                        redeclare package
      Medium = Medium, m_flow_nominal=0.5)
    "Temperature sensor for the outflow of the A60 temperature delay"
    annotation (Placement(transformation(extent={{50,-22},{70,-2}})));
  Annex60.Fluid.Sensors.MassFlowRate masFloA1( redeclare package Medium =
        Medium) "Mass flow rate sensor for the A60 temperature delay"
    annotation (Placement(transformation(extent={{78,-26},{98,-6}})));
  Annex60.Experimental.Pipe.spatialDistributionOneDirection
    spatialDist_test_Reverse(length=length)
    annotation (Placement(transformation(extent={{-80,-60},{-40,-40}})));
  Modelica.Blocks.Sources.RealExpression v_reverse(y=A60PipeHeatLossMod2.heatLossReverse.v)
    "Atmospheric pressure"
    annotation (Placement(transformation(extent={{-200,-60},{-120,-40}})));
  Annex60.Experimental.Pipe.spatialDistributionOneDirection spatialDist_test(
      length=length)
    annotation (Placement(transformation(extent={{-80,-80},{-40,-60}})));
  Modelica.Blocks.Sources.RealExpression v(y=A60PipeHeatLossMod2.heatLoss.v)
    "Atmospheric pressure"
    annotation (Placement(transformation(extent={{-200,-80},{-120,-60}})));
  Annex60.Experimental.Pipe.spatialDistributionTwoDirections
    spatialDist_testBothDirections(length=length)
    annotation (Placement(transformation(extent={{-82,-110},{-22,-90}})));
  Annex60.Experimental.Pipe.spatialDistributionTwoDirectionsAndTrack
    spatialDist_testBothDirections_andTrack(length=length)
    annotation (Placement(transformation(extent={{-80,-140},{-20,-120}})));
equation
  connect(PAtm.y, sin1.p_in)
                            annotation (Line(points={{147,86},{154,86},{154,46},
          {142,46}},
                   color={0,0,127}));
  connect(stepT.y, sou1.T_in) annotation (Line(
      points={{-99,30},{-88,30},{-88,40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(combiTimeTable.y[1], gain.u)
    annotation (Line(points={{-169,70},{-152,70}}, color={0,0,127}));
  connect(gain.y, add.u2)
    annotation (Line(points={{-129,70},{-120,70}},        color={0,0,127}));
  connect(PAtm1.y, add.u1) annotation (Line(points={{-137,98},{-124,98},{-124,
          82},{-120,82}},
                     color={0,0,127}));
  connect(add.y, sou1.p_in) annotation (Line(points={{-97,76},{-88,76},{-88,56},
          {-98,56},{-98,44},{-88,44}}, color={0,0,127}));
  connect(const3.y, A60PipeHeatLossMod2.T_amb) annotation (Line(
      points={{21,70},{21,-2},{24,-2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(A60PipeHeatLossMod2.port_a, senTemA60In1.port_b) annotation (Line(
      points={{14,-12},{-36,-12}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sou1.ports[1], senTemA60In1.port_a) annotation (Line(
      points={{-66,36},{-66,-12},{-56,-12}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(A60PipeHeatLossMod2.port_b, senTemA60Out1.port_a) annotation (Line(
      points={{34,-12},{50,-12}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senTemA60Out1.port_b, masFloA1.port_a) annotation (Line(
      points={{70,-12},{74,-12},{74,-16},{78,-16}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(masFloA1.port_b, sin1.ports[1]) annotation (Line(
      points={{98,-16},{110,-16},{110,-18},{120,-18},{120,38}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(v_reverse.y, spatialDist_test_Reverse.v) annotation (Line(
      points={{-116,-50},{-80,-50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(v.y, spatialDist_test.v) annotation (Line(
      points={{-116,-70},{-80,-70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(v.y, spatialDist_testBothDirections.v) annotation (Line(
      points={{-116,-70},{-118,-70},{-118,-100},{-82,-100}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(v.y, spatialDist_testBothDirections_andTrack.v) annotation (Line(
      points={{-116,-70},{-116,-130},{-80,-130}},
      color={0,0,127},
      smooth=Smooth.None));
    annotation (experiment(StopTime=200000, __Dymola_NumberOfIntervals=5000),Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-200,-180},{160,
            140}}),     graphics),
    Documentation(info="<html>
<p>The model includes a pipe model which is mainly used to obtain the velocity</p>
<p>
The main purpose of the model is to test different variation of the <code>spatialDistribution</code> operator. 
</p>
</html>", revisions="<html>
<ul>
<li>
October 1, 2015 by Marcus Fuchs:<br/>
First implementation.
</li>
</ul>
</html>"),
    __Dymola_experimentSetupOutput);
end SpatialDistributionOperator;

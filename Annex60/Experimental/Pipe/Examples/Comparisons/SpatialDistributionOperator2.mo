within Annex60.Experimental.Pipe.Examples.Comparisons;
model SpatialDistributionOperator2
  "Comparison of KUL A60 pipes with heat loss without reverse flow"
  import Annex60;
  extends Modelica.Icons.Example;

  package Medium = Annex60.Media.Water;

  parameter Modelica.SIunits.Diameter diameter=0.1 "Pipe diameter";
  parameter Modelica.SIunits.Length length=100 "Pipe length";
  parameter Modelica.SIunits.Pressure dp_test = 200
    "Differential pressure for the test used in ramps";

  Modelica.Blocks.Sources.Constant PAtm(k=101325) "Atmospheric pressure"
      annotation (Placement(transformation(extent={{122,-34},{142,-14}})));


  Modelica.Blocks.Sources.Step stepT(
    height=10,
    offset=273.15 + 20,
    startTime=10000)
    "Step temperature increase to test propagation of temperature wave"
    annotation (Placement(transformation(extent={{-138,-104},{-118,-84}})));
  Modelica.Blocks.Sources.CombiTimeTable combiTimeTable(smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments, table=[0,
        1; 3000,1; 5000,0; 10000,0; 12000,-1; 17000,1; 19000,0; 30000,0; 32000,1;
        50000,1; 52000,0; 80000,0; 82000,-1; 100000,-1; 102000,0; 150000,0; 152000,
        1; 160000,1; 162000,0; 163500,0; 165500,1; 200000,1])
    annotation (Placement(transformation(extent={{-194,-50},{-174,-30}})));
  Modelica.Blocks.Math.Gain gain(k=dp_test)
    annotation (Placement(transformation(extent={{-154,-50},{-134,-30}})));
  Modelica.Blocks.Math.Add add
    annotation (Placement(transformation(extent={{-122,-44},{-102,-24}})));
  Modelica.Blocks.Sources.Constant PAtm1(
                                        k=101325) "Atmospheric pressure"
      annotation (Placement(transformation(extent={{-162,-22},{-142,-2}})));
  Annex60.Fluid.Sources.Boundary_pT sou2(          redeclare package Medium =
        Medium,
    use_p_in=true,
    use_T_in=true,
    nPorts=1,
    T=293.15)
    "Source with high pressure at beginning and lower pressure at end of experiment"
                          annotation (Placement(transformation(extent={{-102,34},
            {-82,54}})));
  Annex60.Fluid.Sources.Boundary_pT sin2(          redeclare package Medium =
        Medium,
    nPorts=1,
    use_p_in=true,
    T=283.15)
    "Sink at with constant pressure, turns into source at the end of experiment"
                          annotation (Placement(transformation(extent={{124,36},
            {104,56}})));
  Modelica.Blocks.Sources.Constant const1(k=5)
    annotation (Placement(transformation(extent={{-20,60},{0,80}})));
  Annex60.Experimental.Pipe.PipeHeatLoss_PipeDelay
                                                A60PipeHeatLossMod1(
    redeclare package Medium = Medium,
    m_flow_small=1e-4*0.5,
    diameter=diameter,
    length=length,
    m_flow_nominal=0.5,
    thicknessIns=0.02,
    lambdaI=0.01) "Annex 60 modified pipe with heat losses"
    annotation (Placement(transformation(extent={{-2,-14},{18,6}})));
  Annex60.Fluid.Sensors.TemperatureTwoPort senTemA60In2(
                                                       redeclare package Medium
      = Medium, m_flow_nominal=0.5)
    "Temperature of the inflow to the A60 temperature delay"
    annotation (Placement(transformation(extent={{-72,-14},{-52,6}})));
  Annex60.Fluid.Sensors.TemperatureTwoPort senTemA60Out2(
                                                        redeclare package
      Medium = Medium, m_flow_nominal=0.5)
    "Temperature sensor for the outflow of the A60 temperature delay"
    annotation (Placement(transformation(extent={{34,-14},{54,6}})));
  Annex60.Fluid.Sensors.MassFlowRate masFloA2( redeclare package Medium =
        Medium) "Mass flow rate sensor for the A60 temperature delay"
    annotation (Placement(transformation(extent={{62,-18},{82,2}})));
equation
  connect(combiTimeTable.y[1], gain.u)
    annotation (Line(points={{-173,-40},{-156,-40}},
                                                   color={0,0,127}));
  connect(gain.y, add.u2)
    annotation (Line(points={{-133,-40},{-124,-40}},      color={0,0,127}));
  connect(PAtm1.y, add.u1) annotation (Line(points={{-141,-12},{-128,-12},{-128,
          -28},{-124,-28}},
                     color={0,0,127}));
  connect(const1.y,A60PipeHeatLossMod1. T_amb) annotation (Line(
      points={{1,70},{8,70},{8,6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(A60PipeHeatLossMod1.port_a,senTemA60In2. port_b) annotation (Line(
      points={{-2,-4},{-52,-4}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sou2.ports[1],senTemA60In2. port_a) annotation (Line(
      points={{-82,44},{-82,-4},{-72,-4}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(A60PipeHeatLossMod1.port_b,senTemA60Out2. port_a) annotation (Line(
      points={{18,-4},{34,-4}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senTemA60Out2.port_b,masFloA2. port_a) annotation (Line(
      points={{54,-4},{58,-4},{58,-8},{62,-8}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(masFloA2.port_b,sin2. ports[1]) annotation (Line(
      points={{82,-8},{94,-8},{94,-10},{104,-10},{104,46}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(stepT.y, sou2.T_in) annotation (Line(
      points={{-117,-94},{-96,-94},{-96,44},{-104,44},{-104,48}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(add.y, sou2.p_in) annotation (Line(
      points={{-101,-34},{-101,32},{-122,32},{-122,56},{-104,56},{-104,52}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(PAtm.y, sin2.p_in) annotation (Line(
      points={{143,-24},{146,-24},{146,-20},{148,-20},{148,54},{126,54}},
      color={0,0,127},
      smooth=Smooth.None));
    annotation (experiment(StopTime=200000, __Dymola_NumberOfIntervals=5000),Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-200,
            -180},{160,140}}),
                        graphics),
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
end SpatialDistributionOperator2;

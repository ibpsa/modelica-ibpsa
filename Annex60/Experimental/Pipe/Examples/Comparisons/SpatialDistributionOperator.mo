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
    annotation (Placement(transformation(extent={{-134,6},{-114,26}})));
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
  Modelica.Blocks.Sources.Constant const3(k=273.15 + 5)
    annotation (Placement(transformation(extent={{0,60},{20,80}})));
  Annex60.Experimental.Pipe.PipeHeatLoss_PipeDelayMod PipeDelayMod(
    redeclare package Medium = Medium,
    m_flow_small=1e-4*0.5,
    diameter=diameter,
    length=length,
    m_flow_nominal=0.5,
    thicknessIns=0.02,
    lambdaI=0.01)
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
  Annex60.Experimental.Pipe.BaseClasses.SpatialDistributionOneDirection
    spatialDist_test_Reverse(length=length)
    annotation (Placement(transformation(extent={{-78,-60},{-38,-40}})));
  Modelica.Blocks.Sources.RealExpression v_reverse(y=-PipeDelayMod.tau_used.v)
    "Atmospheric pressure"
    annotation (Placement(transformation(extent={{-200,-60},{-120,-40}})));
  Annex60.Experimental.Pipe.BaseClasses.SpatialDistributionOneDirection
    spatialDist_test(length=length)
    annotation (Placement(transformation(extent={{-80,-80},{-40,-60}})));
  Modelica.Blocks.Sources.RealExpression v(y=PipeDelayMod.tau_used.v)
    "Atmospheric pressure"
    annotation (Placement(transformation(extent={{-200,-80},{-120,-60}})));
  Annex60.Experimental.Pipe.BaseClasses.SpatialDistributionTwoDirections
    spatialDist_testBothDirections(length=length)
    annotation (Placement(transformation(extent={{-82,-110},{-22,-90}})));
  Annex60.Experimental.Pipe.BaseClasses.SpatialDistributionTwoDirectionsAndTrack
    spatialDist_testBothDirections_andTrack(length=length)
    annotation (Placement(transformation(extent={{-80,-140},{-20,-120}})));
  Annex60.Fluid.Sources.Boundary_pT sou2(          redeclare package Medium =
        Medium,
    use_p_in=true,
    use_T_in=true,
    nPorts=1,
    T=293.15)
    "Source with high pressure at beginning and lower pressure at end of experiment"
                          annotation (Placement(transformation(extent={{-98,144},
            {-78,164}})));
  Annex60.Fluid.Sources.Boundary_pT sin2(          redeclare package Medium =
        Medium,
    nPorts=1,
    use_p_in=true,
    T=283.15)
    "Sink at with constant pressure, turns into source at the end of experiment"
                          annotation (Placement(transformation(extent={{128,146},
            {108,166}})));
  Modelica.Blocks.Sources.Constant const1(k=273.15 + 5)
    annotation (Placement(transformation(extent={{-12,178},{8,198}})));
  Annex60.Experimental.Pipe.PipeHeatLoss_PipeDelay PipeDelay(
    redeclare package Medium = Medium,
    m_flow_small=1e-4*0.5,
    diameter=diameter,
    length=length,
    m_flow_nominal=0.5,
    thicknessIns=0.02,
    lambdaI=0.01)
    annotation (Placement(transformation(extent={{2,96},{22,116}})));
  Annex60.Fluid.Sensors.TemperatureTwoPort senTemA60In2(
                                                       redeclare package Medium
      = Medium, m_flow_nominal=0.5)
    "Temperature of the inflow to the A60 temperature delay"
    annotation (Placement(transformation(extent={{-68,96},{-48,116}})));
  Annex60.Fluid.Sensors.TemperatureTwoPort senTemA60Out2(
                                                        redeclare package
      Medium = Medium, m_flow_nominal=0.5)
    "Temperature sensor for the outflow of the A60 temperature delay"
    annotation (Placement(transformation(extent={{38,96},{58,116}})));
  Annex60.Fluid.Sensors.MassFlowRate masFloA2( redeclare package Medium =
        Medium) "Mass flow rate sensor for the A60 temperature delay"
    annotation (Placement(transformation(extent={{66,92},{86,112}})));
equation
  connect(PAtm.y, sin1.p_in)
                            annotation (Line(points={{147,86},{154,86},{154,46},
          {142,46}},
                   color={0,0,127}));
  connect(stepT.y, sou1.T_in) annotation (Line(
      points={{-113,16},{-88,16},{-88,40}},
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
  connect(const3.y, PipeDelayMod.T_amb) annotation (Line(
      points={{21,70},{21,-2},{24,-2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(PipeDelayMod.port_a, senTemA60In1.port_b) annotation (Line(
      points={{14,-12},{-36,-12}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sou1.ports[1], senTemA60In1.port_a) annotation (Line(
      points={{-66,36},{-66,-12},{-56,-12}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(PipeDelayMod.port_b, senTemA60Out1.port_a) annotation (Line(
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
      points={{-116,-50},{-78,-50}},
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
  connect(const1.y, PipeDelay.T_amb) annotation (Line(
      points={{9,188},{9,116},{12,116}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(PipeDelay.port_a, senTemA60In2.port_b) annotation (Line(
      points={{2,106},{-48,106}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sou2.ports[1],senTemA60In2. port_a) annotation (Line(
      points={{-78,154},{-78,106},{-68,106}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(PipeDelay.port_b, senTemA60Out2.port_a) annotation (Line(
      points={{22,106},{38,106}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senTemA60Out2.port_b,masFloA2. port_a) annotation (Line(
      points={{58,106},{62,106},{62,102},{66,102}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(masFloA2.port_b,sin2. ports[1]) annotation (Line(
      points={{86,102},{98,102},{98,100},{108,100},{108,156}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(stepT.y, sou2.T_in) annotation (Line(
      points={{-113,16},{-92,16},{-92,154},{-100,154},{-100,158}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(add.y, sou2.p_in) annotation (Line(
      points={{-97,76},{-97,142},{-118,142},{-118,166},{-100,166},{-100,162}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(PAtm.y, sin2.p_in) annotation (Line(
      points={{147,86},{150,86},{150,90},{152,90},{152,164},{130,164}},
      color={0,0,127},
      smooth=Smooth.None));
    annotation (experiment(StopTime=180000, __Dymola_NumberOfIntervals=5000),Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-200,
            -180},{160,140}}),
                        graphics),
    Documentation(info="<html>
<p>The main purpose of this example is to show the behaviour of the <code>spatialDistribution</code> operator with different implementations and conditions, trying to understand it towards a correct and efficient implementation.</p>

<h4>Introducction to the main models</h4>
<ul>
<li> Four blocks with the prefix <code>spatialDist_</code> which three different implementations of the <code>spatialDistribution</code> operator</li>
</ul>
<p>
The first and simplest valid for one direction flows, <code> (,time_out_b) = spatialDistribution(time,time,x/length,v>=0,{0.0,1.0},{0.0,0.0})</code> where, <code>tau = max(0,time-time_out_b)</code>. </p>
<p>The second valid for bidirectional flow, <code> (time_out_a,time_out_b) = spatialDistribution(time,time,x/length,v>=0,{0.0,1.0},{0.0,0.0})</code> where, <code>tau = if v>= 0 then max(0,time-time_out_b) else max(0,time-time_out_a)</code>
</p>
<p>
And the third implementation valid for biderectional flows and that intends to avoid peaks on the time delay <code>tau</code> when flow direction is changing. Based on the second implementation, several variables were added: </p>
<p>booleans to define periods with zero mass flow rate</p>
<p> <code>if abs(v) >= epsilon then zeroPeriod = false; ... track = 0; else zeroPeriod = true; ... track = time_trackBegin</code>,
<p>
discrete variables to store the time at which a zero mass flow period starts and ends,</p>
<p>
<code>when edge(zeroPeriod) then trackBegin = pre(time)</code> and <code>when edge(NonZeroPeriod) then reinit(trackBegin,0); trackEnd = pre(track)</code>
</p>
<p>
and use the above obtained info to limit the values of <code>tau</code>.
</p>

</p>
<ul>
<li> Source blocks with time varying pressure and step in temperature at time = 10000 seconds</li>
</ul>
<ul>
<li>Two pipe models (<code>PipeDelay</code> and <code>PipeDelayMod</code>) differenced by the use of different blocks to calculate the fluid time delay</li>
</ul>
<p>
Each pipe has two block that calculate the delay <code>tau</code>. The blocks uses the same input and parameters, but one block (<code>tau_used</code>) connects its output to the heatLosses block and the other block (<code>tau_unused</code>) has its output unconnected.  
</p>
<p>
The model <code>PipeDelayMod</code> uses the third implementation (above explained) to calculate the delay. while the model <code>PipeDelay</code> uses a fourth implementation which also uses booleans to define periods with zero mass flow rate but uses this information to define different inputs for the <code>spatialDistribution</code> operator: 
</p>
<p><code>(timeOut_a,timeOut_b) = spatialDistribution(inp_a,inp_b,x,u >= 0, {0.0,1.0}, {0.0,0.0});</code>
</p>
<p>
If a period of zero mass flow rate is ocurring (<code>abs(velocity) < epsilon </code>), then <code> inp_a = track_a; inp_b = track_b; tau_a = time-track_a; tau_b = time-track_b; </code>. Otherwise, <code> inp_a = time; inp_b = time; tau_a = time-timeOut_a; tau_b = time-timeOut_b; </code> </p>


<h4>Results</h4>
<p>
The standard settings for the simulations are a number of intervals = 5000 and StopTime = 180000 s. The results shows:
</p>
<ul>
<li> Results depends on the choosen solver</li>
</ul>
<p>
Different solvers with default settings (Tolerance and/or FixedIntegrationStep) were used to solve the example.
</p>
<p><img src=\"modelica://Annex60/Resources/Images/Experimental/DifferentSolvers.png\" border=\"1\"/></p>

<ul>
<li> The values of the delay obtained by the two blocks inside the pipes models differ sometimes from each other besides the use of the same input and parameters</li>
</ul>
<p>
The standard settings and the Dassl solver are used. Notice that the delay times <code>tau</code> calculated by the blocks <code>tau_unused</code> seems to be correct.
</p>
<p><img src=\"modelica://Annex60/Resources/Images/Experimental/BlocksDif.png\" border=\"1\"/></p>

<p>However, having a closer look to the highlighted zone and testing different tolerances shows how the above results for <code>tau_unused</code> are not 100 % correct. high tolerances can yield wrong results as shown in the next plot where different tolerances using the solver Dassl were tested.</p>
<p><img src=\"modelica://Annex60/Resources/Images/Experimental/Tolerance.png\" border=\"1\"/></p>

<p>Furthermore, setting a tolerance = 1e-5 and using different solvers. We take a look to the values for <code>time_out_a/timeOut_a</code> calculated by the <code>spatialDistribution</code> operator. In this case, different values are obtained at the block <code>tau_unused</code> depending on the solver. However its values during negative mass flow rates, it means when <code>time_out_a/timeOut_a</code> is really used, are equal and aparently correct. On the other hand, the <code>time_out_a/timeOut_a</code> values obtained in the <code>tau_used</code> block shows in some cases wrong results and strange behaviours such as instant peaks</p>
<p><img src=\"modelica://Annex60/Resources/Images/Experimental/Timeout_a.png\" border=\"1\"/></p>

<h4>Final comments</h4>
<p>The different implementations used to calculate the delay time seems to work properly when its output is not used. Once the output is used wrong results and/or strange behaviour are observed. There might be some weak points, even wrong points in the implementation. On the other hand, the fact that even using a simple definition for the <code>spatialDistribution</code> operatior, peaks of <code>time_out_a</code> which values are higher than the <code>time</code> itself are obtained could point out that there is a problem in the operator itself.</p>
</html>", revisions="<html>
<ul>
<li>January 2016, by Carles Ribas Tugores:<br>Further testing with different <code><span style=\"font-family: Courier New,courier;\">spatialDistribution </span></code>operator implementations.</li>
<li>October 1, 2015 by Marcus Fuchs:<br>First implementation. </li>
</ul>
</html>"),
    __Dymola_experimentSetupOutput);
end SpatialDistributionOperator;

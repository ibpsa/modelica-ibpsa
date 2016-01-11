within Annex60.Experimental.Pipe.Examples;
package TimeDelay
  extends Modelica.Icons.ExamplesPackage;
  model FlowReversal
    extends Modelica.Icons.Example;

    BaseClasses.PDETime timeDelay
      annotation (Placement(transformation(extent={{0,0},{20,20}})));
    Modelica.Blocks.Sources.Step velocityStep(
      startTime=100,
      height=-2*offset,
      offset=offset)
      annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
    parameter Real offset=0.1 "Offset of output signal y";
  equation
    connect(timeDelay.u, velocityStep.y)
      annotation (Line(points={{-2,10},{-20,10},{-39,10}}, color={0,0,127}));
    annotation (experiment(StopTime=1000, Interval=1),
        __Dymola_experimentSetupOutput);
  end FlowReversal;

  model ContinuouslyVaryingFlow
    extends Modelica.Icons.Example;

    BaseClasses.PDETime timeDelay
      annotation (Placement(transformation(extent={{0,0},{20,20}})));
    parameter Real offset=0.1 "Offset of output signal y";
    Modelica.Blocks.Sources.Sine sine(amplitude=0.1, freqHz=0.001)
      annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  equation
    connect(timeDelay.u, sine.y)
      annotation (Line(points={{-2,10},{-20,10},{-39,10}}, color={0,0,127}));
    annotation (experiment(StopTime=1000, Interval=1),
        __Dymola_experimentSetupOutput);
  end ContinuouslyVaryingFlow;

  model ZeroFlow
    "Unit test for PDETime operator for the case where zero flow occurs for a longer time"
    extends Modelica.Icons.Example;

    BaseClasses.PDETime timeDelay
      annotation (Placement(transformation(extent={{0,0},{20,20}})));
    parameter Real offset=0.1 "Offset of output signal y";
    Modelica.Blocks.Math.Add add
      annotation (Placement(transformation(extent={{-28,0},{-8,20}})));
    Modelica.Blocks.Sources.Pulse pulse(
      amplitude=offset,
      period=500,
      nperiod=1,
      width=20) annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
    Modelica.Blocks.Sources.Pulse pulse1(
      amplitude=-offset,
      width=50,
      period=500,
      nperiod=1,
      startTime=500)
      annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  equation
    connect(timeDelay.u, add.y)
      annotation (Line(points={{-2,10},{-7,10}}, color={0,0,127}));
    connect(pulse.y, add.u1) annotation (Line(points={{-59,30},{-42,30},{-42,16},{
            -30,16}}, color={0,0,127}));
    connect(pulse1.y, add.u2) annotation (Line(points={{-59,-10},{-42,-10},{-42,4},
            {-30,4}}, color={0,0,127}));
    annotation (experiment(StopTime=1000, Interval=1),
        __Dymola_experimentSetupOutput,
      Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
              100}})));
  end ZeroFlow;

  model DiffTimeZeroFlow
    "Unit test for PDETime operator for the case where zero flow occurs for a longer time"
    extends Modelica.Icons.Example;

    parameter Real offset=0.1 "Offset of output signal y";
    Modelica.Blocks.Math.Add add
      annotation (Placement(transformation(extent={{-28,0},{-8,20}})));
    Modelica.Blocks.Sources.Pulse pulse(
      amplitude=offset,
      period=500,
      nperiod=1,
      width=20) annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
    Modelica.Blocks.Sources.Pulse pulse1(
      amplitude=-offset,
      width=50,
      period=500,
      nperiod=1,
      startTime=500)
      annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
    TimeDelays.DiffTime diffTime
      annotation (Placement(transformation(extent={{10,0},{30,20}})));
    BaseClasses.PDETime pDETime
      annotation (Placement(transformation(extent={{10,-62},{30,-42}})));
  equation
    connect(pulse.y, add.u1) annotation (Line(points={{-59,30},{-42,30},{-42,16},{
            -30,16}}, color={0,0,127}));
    connect(pulse1.y, add.u2) annotation (Line(points={{-59,-10},{-42,-10},{-42,4},
            {-30,4}}, color={0,0,127}));
    connect(add.y, diffTime.u)
      annotation (Line(points={{-7,10},{0,10},{8,10}}, color={0,0,127}));
    connect(add.y, pDETime.u) annotation (Line(points={{-7,10},{0,10},{0,-52},{
            8,-52}}, color={0,0,127}));
    annotation (experiment(StopTime=1000, Interval=1),
        __Dymola_experimentSetupOutput,
      Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
              100}})));
  end DiffTimeZeroFlow;

  model PipeLevelDelay "Comparison of different ways to calculate time delays"
    import Annex60;
    extends Modelica.Icons.Example;

    package Medium = Annex60.Media.Water;

    parameter Modelica.SIunits.Diameter diameter=0.1 "Pipe diameter";
    parameter Modelica.SIunits.Length length=100 "Pipe length";

    parameter Modelica.SIunits.Pressure dp_test = 200
      "Differential pressure for the test used in ramps";

    Modelica.Blocks.Sources.Constant PAtm(k=101325) "Atmospheric pressure"
        annotation (Placement(transformation(extent={{126,76},{146,96}})));

    Annex60.Fluid.Sources.Boundary_pT sou1(          redeclare package Medium
        = Medium,
      use_p_in=true,
      use_T_in=true,
      nPorts=2,
      T=293.15)
      "Source with high pressure at beginning and lower pressure at end of experiment"
                            annotation (Placement(transformation(extent={{-88,28},
              {-68,48}})));
    Annex60.Fluid.Sources.Boundary_pT sin1(          redeclare package Medium
        = Medium,
      nPorts=2,
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
    Annex60.Fluid.Sensors.TemperatureTwoPort senTemA60Out(redeclare package
        Medium = Medium, m_flow_nominal=0.5)
      "Temperature sensor for the outflow of the A60 temperature delay"
      annotation (Placement(transformation(extent={{56,30},{76,50}})));
    Annex60.Fluid.Sensors.TemperatureTwoPort senTemA60In(redeclare package
        Medium =
          Medium, m_flow_nominal=0.5)
      "Temperature of the inflow to the A60 temperature delay"
      annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
    Modelica.Blocks.Sources.CombiTimeTable combiTimeTable(smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments, table=[0,
          1; 3000,1; 5000,0; 10000,0; 12000,-1; 17000,-1; 19000,0; 30000,0;
          30010,-0.1; 50000,-0.1; 50010,0; 80000,0; 82000,-1; 100000,-1; 102000,
          0; 150000,0; 152000,1; 160000,1; 162000,0; 163500,0; 165500,1; 200000,
          1])
      annotation (Placement(transformation(extent={{-190,60},{-170,80}})));
    Modelica.Blocks.Math.Gain gain(k=dp_test)
      annotation (Placement(transformation(extent={{-150,60},{-130,80}})));
    Modelica.Blocks.Math.Add add
      annotation (Placement(transformation(extent={{-118,66},{-98,86}})));
    Modelica.Blocks.Sources.Constant PAtm1(
                                          k=101325) "Atmospheric pressure"
        annotation (Placement(transformation(extent={{-158,88},{-138,108}})));
    Modelica.Blocks.Sources.Constant const3(k=5)
      annotation (Placement(transformation(extent={{-28,96},{-8,116}})));
    Annex60.Experimental.Pipe.PipeHeatLossA60Mod_epsilon
      A60PipeHeatLossMod_noabs(
      redeclare package Medium = Medium,
      m_flow_small=1e-4*0.5,
      diameter=diameter,
      length=length,
      m_flow_nominal=0.5,
      thicknessIns=0.02,
      lambdaI=0.01) "Annex 60 modified pipe with heat losses"
      annotation (Placement(transformation(extent={{8,28},{28,48}})));
    Annex60.Experimental.Pipe.PipeHeatLossA60Mod_epsilon A60PipeHeatLossMod2(
      redeclare package Medium = Medium,
      m_flow_small=1e-4*0.5,
      diameter=diameter,
      length=length,
      m_flow_nominal=0.5,
      thicknessIns=0.02,
      lambdaI=0.01) "Annex 60 modified pipe with heat losses"
      annotation (Placement(transformation(extent={{14,-22},{34,-2}})));
    Annex60.Fluid.Sensors.TemperatureTwoPort senTemA60In1(
                                                         redeclare package
        Medium =
          Medium, m_flow_nominal=0.5)
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
    Annex60.Experimental.Pipe.BaseClasses.PDETime_massFlow pDETime_massFlow(len=
         length, diameter=diameter)
      annotation (Placement(transformation(extent={{114,-78},{134,-58}})));
  equation
    connect(PAtm.y, sin1.p_in)
                              annotation (Line(points={{147,86},{154,86},{154,46},
            {142,46}},
                     color={0,0,127}));
    connect(sin1.ports[1],masFloA60. port_b) annotation (Line(
        points={{120,40},{114,40},{114,40},{108,40}},
        color={0,127,255},
        smooth=Smooth.None));
    connect(stepT.y, sou1.T_in) annotation (Line(
        points={{-99,30},{-90,30},{-90,42}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(masFloA60.port_a,senTemA60Out. port_b) annotation (Line(
        points={{88,40},{76,40}},
        color={0,127,255},
        smooth=Smooth.None));
    connect(sou1.ports[1],senTemA60In. port_a) annotation (Line(
        points={{-68,40},{-64,40},{-64,40},{-60,40}},
        color={0,127,255},
        smooth=Smooth.None));
    connect(combiTimeTable.y[1], gain.u)
      annotation (Line(points={{-169,70},{-152,70}}, color={0,0,127}));
    connect(gain.y, add.u2)
      annotation (Line(points={{-129,70},{-120,70}},        color={0,0,127}));
    connect(PAtm1.y, add.u1) annotation (Line(points={{-137,98},{-124,98},{-124,
            82},{-120,82}},
                       color={0,0,127}));
    connect(add.y, sou1.p_in) annotation (Line(points={{-97,76},{-88,76},{-98,56},
            {-98,56},{-98,46},{-90,46}}, color={0,0,127}));
    connect(senTemA60In.port_b, A60PipeHeatLossMod_noabs.port_a) annotation (Line(
        points={{-40,40},{-16,40},{-16,38},{8,38}},
        color={0,127,255},
        smooth=Smooth.None));
    connect(A60PipeHeatLossMod_noabs.port_b, senTemA60Out.port_a) annotation (
        Line(
        points={{28,38},{44,38},{44,40},{56,40}},
        color={0,127,255},
        smooth=Smooth.None));
    connect(const3.y, A60PipeHeatLossMod_noabs.T_amb) annotation (Line(
        points={{-7,106},{2,106},{2,54},{18,54},{18,48}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(const3.y, A60PipeHeatLossMod2.T_amb) annotation (Line(
        points={{-7,106},{-7,-2},{24,-2}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(A60PipeHeatLossMod2.port_a, senTemA60In1.port_b) annotation (Line(
        points={{14,-12},{-36,-12}},
        color={0,127,255},
        smooth=Smooth.None));
    connect(sou1.ports[2], senTemA60In1.port_a) annotation (Line(
        points={{-68,36},{-66,36},{-66,-12},{-56,-12}},
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
    connect(masFloA1.port_b, sin1.ports[2]) annotation (Line(
        points={{98,-16},{110,-16},{110,-18},{120,-18},{120,36}},
        color={0,127,255},
        smooth=Smooth.None));
    connect(masFloA1.m_flow, pDETime_massFlow.m_flow) annotation (Line(points={
            {88,-5},{100,-5},{100,-68},{112,-68}}, color={0,0,127}));
      annotation (experiment(StopTime=200000, __Dymola_NumberOfIntervals=5000),
  __Dymola_Commands(file="modelica://Annex60/Resources/Scripts/Dymola/Experimental/PipeAdiabatic/PipeAdiabatic_TStep.mos"
          "Simulate and plot"),
      Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-200,-180},{
              160,140}})),
      Documentation(info="<html>
<p>This example compares the KUL and A60 pipe with heat loss implementations.</p>
<p>This is only a first glimpse at the general behavior. Next step is to parameterize 
both models with comparable heat insulation properties. In general, the KUL pipe seems 
to react better to changes in mass flow rate, but also does not show cooling effects at 
the period of zero-mass flow.</p>
</html>",   revisions="<html>
<ul>
<li>
October 1, 2015 by Marcus Fuchs:<br/>
First implementation.
</li>
</ul>
</html>"),
      __Dymola_experimentSetupOutput);
  end PipeLevelDelay;
end TimeDelay;

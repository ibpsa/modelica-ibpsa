within Annex60.Experimental.Pipe.Examples.Comparisons.Events;
model EventsKUL_Reverse
  "Check number of events in KUL-Reverse model for comparison with A60Mod"
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
    T=293.15,
    nPorts=1)
    "Source with high pressure at beginning and lower pressure at end of experiment"
                          annotation (Placement(transformation(extent={{-88,28},
            {-68,48}})));
  Annex60.Fluid.Sources.Boundary_pT sin1(          redeclare package Medium =
        Medium,
    use_p_in=true,
    T=283.15,
    nPorts=1)
    "Sink at with constant pressure, turns into source at the end of experiment"
                          annotation (Placement(transformation(extent={{140,28},
            {120,48}})));

  Modelica.Blocks.Sources.Step stepT(
    height=10,
    offset=273.15 + 20,
    startTime=10000)
    "Step temperature increase to test propagation of temperature wave"
    annotation (Placement(transformation(extent={{-118,10},{-98,30}})));
  Modelica.Blocks.Sources.Ramp decreaseP(
    duration=1800,
    height=-dp_test,
    offset=101325 + dp_test,
    startTime=50000) "Decreasing pressure difference to zero-mass-flow"
    annotation (Placement(transformation(extent={{-156,80},{-136,100}})));
  Modelica.Blocks.Sources.Ramp reverseDP(
    duration=1800,
    offset=0,
    height=-dp_test,
    startTime=140000) "Reverse the flow after a period of zero-mass-flow"
    annotation (Placement(transformation(extent={{-156,40},{-136,60}})));
  Modelica.Blocks.Math.Add add "Combine input signal of two ramps"
    annotation (Placement(transformation(extent={{-118,60},{-98,80}})));
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
        origin={28,16})));
  Annex60.Fluid.Sensors.MassFlowRate masFloKUL2(
                                              redeclare package Medium = Medium)
    "Mass flow rate sensor for the KUL lossless pipe"
    annotation (Placement(transformation(extent={{86,6},{106,26}})));
  Annex60.Fluid.Sensors.TemperatureTwoPort senTemKULOut2(
                                                        redeclare package
      Medium = Medium, m_flow_nominal=0.5)
    "Temperature sensor for the outflow from the KUL lossless pipe"
    annotation (Placement(transformation(extent={{54,6},{74,26}})));
  Annex60.Fluid.Sensors.TemperatureTwoPort senTemKULIn2(
                                                       redeclare package Medium
      = Medium, m_flow_nominal=0.5)
    "Temperature sensor of the inflow to the KUL lossless pipe"
    annotation (Placement(transformation(extent={{-62,6},{-42,26}})));
  Modelica.Blocks.Sources.Constant const2(
                                         k=273.15 + 5)
    annotation (Placement(transformation(extent={{-22,36},{-2,56}})));
equation
  connect(PAtm.y, sin1.p_in)
                            annotation (Line(points={{147,86},{154,86},{154,46},
          {142,46}},
                   color={0,0,127}));
  connect(stepT.y, sou1.T_in) annotation (Line(
      points={{-97,20},{-90,20},{-90,42}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(decreaseP.y, add.u1) annotation (Line(
      points={{-135,90},{-130,90},{-130,76},{-120,76}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(reverseDP.y, add.u2) annotation (Line(
      points={{-135,50},{-128,50},{-128,64},{-120,64}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(add.y, sou1.p_in) annotation (Line(
      points={{-97,70},{-94,70},{-94,46},{-90,46}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(masFloKUL2.port_a, senTemKULOut2.port_b) annotation (Line(
      points={{86,16},{74,16}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(KULHeatLoss_reverse.port_b, senTemKULOut2.port_a) annotation (Line(
      points={{38,16},{54,16}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senTemKULIn2.port_b, KULHeatLoss_reverse.port_a)
    annotation (Line(points={{-42,16},{18,16}},     color={0,127,255}));
  connect(const2.y, KULHeatLoss_reverse.TBoundary)
    annotation (Line(points={{-1,46},{28,46},{28.2,21}},     color={0,0,127}));
  connect(sou1.ports[1], senTemKULIn2.port_a)
    annotation (Line(points={{-68,38},{-62,16}}, color={0,127,255}));
  connect(masFloKUL2.port_b, sin1.ports[1])
    annotation (Line(points={{106,16},{120,38}}, color={0,127,255}));
    annotation (experiment(StopTime=200000, __Dymola_NumberOfIntervals=5000),
__Dymola_Commands(file="modelica://Annex60/Resources/Scripts/Dymola/Experimental/PipeAdiabatic/PipeAdiabatic_TStep.mos"
        "Simulate and plot"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-160,-180},{
            160,140}})),
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
end EventsKUL_Reverse;

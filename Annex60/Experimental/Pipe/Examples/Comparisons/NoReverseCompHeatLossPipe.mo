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
      annotation (Placement(transformation(extent={{128,-44},{148,-24}})));

  Annex60.Fluid.Sources.Boundary_pT sou1(          redeclare package Medium =
        Medium,
    use_p_in=true,
    use_T_in=true,
    nPorts=3,
    T=293.15)
    "Source with high pressure at beginning and lower pressure at end of experiment"
                          annotation (Placement(transformation(extent={{-86,-92},
            {-66,-72}})));
  Annex60.Fluid.Sources.Boundary_pT sin1(          redeclare package Medium =
        Medium,
    nPorts=3,
    use_p_in=true,
    T=283.15)
    "Sink at with constant pressure, turns into source at the end of experiment"
                          annotation (Placement(transformation(extent={{142,-92},
            {122,-72}})));
  Annex60.Fluid.Sensors.MassFlowRate masFloA60(redeclare package Medium =
        Medium) "Mass flow rate sensor for the A60 temperature delay"
    annotation (Placement(transformation(extent={{90,-90},{110,-70}})));

  Modelica.Blocks.Sources.Step stepT(
    height=10,
    offset=273.15 + 20,
    startTime=10000)
    "Step temperature increase to test propagation of temperature wave"
    annotation (Placement(transformation(extent={{-118,-100},{-98,-80}})));
  Annex60.Experimental.Pipe.Archive.PipeHeatLossA60Ref A60PipeHeatLoss(
    redeclare package Medium = Medium,
    m_flow_small=1e-4*0.5,
    diameter=diameter,
    length=length,
    m_flow_nominal=0.5,
    thicknessIns=0.02,
    thermTransmissionCoeff=0.03) "Annex 60 pipe with heat losses"
    annotation (Placement(transformation(extent={{22,-90},{42,-70}})));
  Annex60.Fluid.Sensors.TemperatureTwoPort senTemA60Out(redeclare package
      Medium = Medium, m_flow_nominal=0.5)
    "Temperature sensor for the outflow of the A60 temperature delay"
    annotation (Placement(transformation(extent={{58,-90},{78,-70}})));
  Annex60.Fluid.Sensors.TemperatureTwoPort senTemA60In(redeclare package Medium =
        Medium, m_flow_nominal=0.5)
    "Temperature of the inflow to the A60 temperature delay"
    annotation (Placement(transformation(extent={{-58,-90},{-38,-70}})));
  Annex60.Experimental.Pipe.Archive.PipeHeatLossKUL KULHeatLoss(
    redeclare package Medium = Medium,
    m_flow_nominal=0.5,
    diameter=diameter,
    length=length,
    thicknessIns=0.02,
    lambdaI=0.01) "KUL implementation of plug flow pipe with heat losses"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={32,-140})));
  Annex60.Fluid.Sensors.MassFlowRate masFloKUL(
                                              redeclare package Medium = Medium)
    "Mass flow rate sensor for the KUL lossless pipe"
    annotation (Placement(transformation(extent={{90,-150},{110,-130}})));
  Annex60.Fluid.Sensors.TemperatureTwoPort senTemKULOut(redeclare package
      Medium = Medium, m_flow_nominal=0.5)
    "Temperature sensor for the outflow from the KUL lossless pipe"
    annotation (Placement(transformation(extent={{58,-150},{78,-130}})));
  Annex60.Fluid.Sensors.TemperatureTwoPort senTemKULIn(redeclare package Medium =
        Medium, m_flow_nominal=0.5)
    "Temperature sensor of the inflow to the KUL lossless pipe"
    annotation (Placement(transformation(extent={{-58,-150},{-38,-130}})));
  Modelica.Blocks.Sources.Constant const(k=273.15 + 5)
    annotation (Placement(transformation(extent={{-18,-120},{2,-100}})));
  Modelica.Blocks.Sources.CombiTimeTable combiTimeTable(smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
      table=[0,1; 3000,1; 5000,0; 10000,0; 12000,1; 17000,1; 19000,0; 30000,0;
        32000,1; 50000,1; 52000,0; 80000,0; 82000,1; 100000,1; 102000,0; 150000,
        0; 152000,1; 160000,1; 162000,0; 163500,0; 165500,1; 200000,1])
    annotation (Placement(transformation(extent={{-188,-60},{-168,-40}})));
  Modelica.Blocks.Math.Gain gain(k=dp_test)
    annotation (Placement(transformation(extent={{-148,-60},{-128,-40}})));
  Modelica.Blocks.Math.Add add
    annotation (Placement(transformation(extent={{-116,-54},{-96,-34}})));
  Modelica.Blocks.Sources.Constant PAtm1(
                                        k=101325) "Atmospheric pressure"
      annotation (Placement(transformation(extent={{-156,-32},{-136,-12}})));
  Annex60.Experimental.Pipe.Archive.PipeHeatLoss A60PipeHeatLossMod2(
    redeclare package Medium = Medium,
    m_flow_small=1e-4*0.5,
    diameter=diameter,
    length=length,
    m_flow_nominal=0.5,
    thicknessIns=0.02,
    lambdaI=0.01) "Annex 60 modified pipe with heat losses"
    annotation (Placement(transformation(extent={{22,0},{42,20}})));
  Annex60.Fluid.Sensors.TemperatureTwoPort senTemA60ModIn1(
                                                          redeclare package
      Medium = Medium, m_flow_nominal=0.5)
    "Temperature of the inflow to the A60 modified temperature delay"
    annotation (Placement(transformation(extent={{-56,0},{-36,20}})));
  Annex60.Fluid.Sensors.TemperatureTwoPort senTemA60ModOut1(
                                                           redeclare package
      Medium = Medium, m_flow_nominal=0.5)
    "Temperature sensor for the outflow of the A60 modified temperature delay"
    annotation (Placement(transformation(extent={{52,0},{72,20}})));
  Annex60.Fluid.Sensors.MassFlowRate masFloA60Mod1(
                                                  redeclare package Medium =
        Medium) "Mass flow rate sensor for the A60 modified temperature delay"
    annotation (Placement(transformation(extent={{86,0},{106,20}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=
        278.15)
    annotation (Placement(transformation(extent={{-36,94},{-16,114}})));
equation
  connect(PAtm.y, sin1.p_in)
                            annotation (Line(points={{149,-34},{154,-34},{154,
          -74},{144,-74}},
                   color={0,0,127}));
  connect(sin1.ports[1],masFloA60. port_b) annotation (Line(
      points={{122,-79.3333},{116,-79.3333},{116,-80},{110,-80}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(stepT.y, sou1.T_in) annotation (Line(
      points={{-97,-90},{-88,-90},{-88,-78}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(A60PipeHeatLoss.port_b, senTemA60Out.port_a) annotation (Line(
      points={{42,-80},{58,-80}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(masFloA60.port_a,senTemA60Out. port_b) annotation (Line(
      points={{90,-80},{78,-80}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sou1.ports[1],senTemA60In. port_a) annotation (Line(
      points={{-66,-79.3333},{-62,-79.3333},{-62,-80},{-58,-80}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(masFloKUL.port_a,senTemKULOut. port_b) annotation (Line(
      points={{90,-140},{78,-140}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sou1.ports[2],senTemKULIn. port_a) annotation (Line(
      points={{-66,-82},{-64,-82},{-64,-140},{-58,-140}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(masFloKUL.port_b, sin1.ports[2]) annotation (Line(
      points={{110,-140},{116,-140},{116,-82},{122,-82}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(KULHeatLoss.port_b, senTemKULOut.port_a) annotation (Line(
      points={{42,-140},{58,-140}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senTemA60In.port_b, A60PipeHeatLoss.port_a)
    annotation (Line(points={{-38,-80},{22,-80}},
                                                color={0,127,255}));
  connect(senTemKULIn.port_b,KULHeatLoss. port_a)
    annotation (Line(points={{-38,-140},{22,-140}},
                                                  color={0,127,255}));
  connect(const.y,KULHeatLoss. TBoundary)
    annotation (Line(points={{3,-110},{32,-110},{32.2,-135}},
                                                         color={0,0,127}));
  connect(combiTimeTable.y[1], gain.u)
    annotation (Line(points={{-167,-50},{-150,-50}},
                                                   color={0,0,127}));
  connect(gain.y, add.u2)
    annotation (Line(points={{-127,-50},{-118,-50}},      color={0,0,127}));
  connect(PAtm1.y, add.u1) annotation (Line(points={{-135,-22},{-122,-22},{-122,
          -38},{-118,-38}},
                     color={0,0,127}));
  connect(add.y, sou1.p_in) annotation (Line(points={{-95,-44},{-86,-44},{-96,
          -64},{-96,-74},{-88,-74}},   color={0,0,127}));
  connect(A60PipeHeatLossMod2.port_a, senTemA60ModIn1.port_b) annotation (Line(
      points={{22,10},{-36,10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(A60PipeHeatLossMod2.port_b, senTemA60ModOut1.port_a) annotation (Line(
      points={{42,10},{52,10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senTemA60ModOut1.port_b, masFloA60Mod1.port_a) annotation (Line(
      points={{72,10},{86,10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(masFloA60Mod1.port_b, sin1.ports[3]) annotation (Line(
      points={{106,10},{126,10},{126,-84.6667},{122,-84.6667}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senTemA60ModIn1.port_a, sou1.ports[3]) annotation (Line(
      points={{-56,10},{-66,10},{-66,-84.6667}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(fixedTemperature.port, A60PipeHeatLossMod2.heatPort) annotation (Line(
        points={{-16,104},{4,104},{32,104},{32,20}}, color={191,0,0}));
    annotation (experiment(StopTime=200000, __Dymola_NumberOfIntervals=5000),
__Dymola_Commands(file="modelica://Annex60/Resources/Scripts/Dymola/Experimental/PipeAdiabatic/PipeAdiabatic_TStep.mos"
        "Simulate and plot"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-200,-180},{
            160,140}})),
    Documentation(info="<html>
<p>This example compares different implementations of the pipe heat loss model for varying periods of zero flow. A longer period of no flow should result in a higher heat loss to the surroundings. No reverse flow is considered in this example.</p>
</html>", revisions="<html>
<ul>
<li>February 16, 2016 by Bram van der Heijde:<br>Updated docstrings.</li>
<li>November 2015, by Bram van der Heijde:<br>First implementation.</li>
</ul>
</html>"),
    __Dymola_experimentSetupOutput);
end NoReverseCompHeatLossPipe;

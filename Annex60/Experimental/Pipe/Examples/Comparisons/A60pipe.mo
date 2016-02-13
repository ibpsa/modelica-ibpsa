within Annex60.Experimental.Pipe.Examples.Comparisons;
model A60pipe "Comparison of KUL A60 pipes with heat loss without reverse flow"
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
    nPorts=2,
    T=293.15)
    "Source with high pressure at beginning and lower pressure at end of experiment"
                          annotation (Placement(transformation(extent={{-88,28},
            {-68,48}})));
  Annex60.Fluid.Sources.Boundary_pT sin1(          redeclare package Medium =
        Medium,
    nPorts=2,
    use_p_in=true,
    T=283.15)
    "Sink at with constant pressure, turns into source at the end of experiment"
                          annotation (Placement(transformation(extent={{140,28},
            {120,48}})));
  Annex60.Fluid.Sensors.MassFlowRate masFloPipeDelayMod(redeclare package
      Medium = Medium) "Mass flow rate sensor for the A60 temperature delay"
    annotation (Placement(transformation(extent={{88,30},{108,50}})));

  Modelica.Blocks.Sources.Step stepT(
    height=10,
    offset=273.15 + 20,
    startTime=10000)
    "Step temperature increase to test propagation of temperature wave"
    annotation (Placement(transformation(extent={{-120,20},{-100,40}})));
  Annex60.Fluid.Sensors.TemperatureTwoPort senTemPipeDelayModOut(redeclare
      package Medium = Medium, m_flow_nominal=0.5)
    "Temperature sensor for the outflow of the A60 temperature delay modified"
    annotation (Placement(transformation(extent={{56,30},{76,50}})));
  Annex60.Fluid.Sensors.TemperatureTwoPort senTempPipeDelayModIn(redeclare
      package Medium = Medium, m_flow_nominal=0.5)
    "Temperature of the inflow to the A60 temperature delay modified"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
  Modelica.Blocks.Sources.CombiTimeTable combiTimeTable(smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments, table=[0,
        1; 3000,1; 5000,0; 10000,0; 12000,-1; 17000,-1; 19000,0; 30000,0; 32000,
        1; 50000,1; 52000,0; 80000,0; 82000,-1; 100000,-1; 102000,0; 150000,0;
        152000,1; 160000,1; 162000,0; 163500,0; 165500,1; 200000,1])
    annotation (Placement(transformation(extent={{-200,60},{-180,80}})));
  Modelica.Blocks.Math.Gain gain(k=dp_test)
    annotation (Placement(transformation(extent={{-160,60},{-140,80}})));
  Modelica.Blocks.Math.Add add
    annotation (Placement(transformation(extent={{-128,66},{-108,86}})));
  Modelica.Blocks.Sources.Constant PAtm1(
                                        k=101325) "Atmospheric pressure"
      annotation (Placement(transformation(extent={{-168,88},{-148,108}})));
  Annex60.Fluid.Sensors.MassFlowRate masFloPipeDelay(redeclare package Medium
      = Medium) "Mass flow rate sensor for the A60 temperature delay"
    annotation (Placement(transformation(extent={{88,70},{108,90}})));
  Annex60.Experimental.Pipe.PipeHeatLoss_PipeDelay PipeDelay(
    redeclare package Medium = Medium,
    m_flow_small=1e-4*0.5,
    diameter=diameter,
    length=length,
    m_flow_nominal=0.5,
    thicknessIns=0.02,
    lambdaI=0.01) "Annex 60 Pipe with heat loss"
    annotation (Placement(transformation(extent={{20,70},{40,90}})));
  Annex60.Fluid.Sensors.TemperatureTwoPort senTemPipeDelayOut(redeclare package
      Medium = Medium, m_flow_nominal=0.5)
    "Temperature sensor for the outflow of the A60 temperature delay"
    annotation (Placement(transformation(extent={{56,70},{76,90}})));
  Annex60.Fluid.Sensors.TemperatureTwoPort senTemPipeDelayIn(redeclare package
      Medium = Medium, m_flow_nominal=0.5)
    "Temperature of the inflow to the A60 temperature delay"
    annotation (Placement(transformation(extent={{-60,70},{-40,90}})));
  Modelica.Blocks.Sources.Constant const3(k=5)
    annotation (Placement(transformation(extent={{-28,96},{-8,116}})));
  Annex60.Experimental.Pipe.PipeHeatLoss_PipeDelayMod PipeDelayMod(
    redeclare package Medium = Medium,
    m_flow_small=1e-4*0.5,
    diameter=diameter,
    length=length,
    m_flow_nominal=0.5,
    thicknessIns=0.02,
    lambdaI=0.01) "Annex 60 modified pipe with heat losses"
    annotation (Placement(transformation(extent={{6,30},{26,50}})));
equation
  connect(PAtm.y, sin1.p_in)
                            annotation (Line(points={{147,86},{154,86},{154,46},
          {142,46}},
                   color={0,0,127}));
  connect(sin1.ports[1], masFloPipeDelayMod.port_b) annotation (Line(
      points={{120,40},{108,40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(stepT.y, sou1.T_in) annotation (Line(
      points={{-99,30},{-90,30},{-90,42}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(masFloPipeDelayMod.port_a, senTemPipeDelayModOut.port_b) annotation (
      Line(
      points={{88,40},{76,40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sou1.ports[1], senTempPipeDelayModIn.port_a) annotation (Line(
      points={{-68,40},{-60,40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(combiTimeTable.y[1], gain.u)
    annotation (Line(points={{-179,70},{-162,70}}, color={0,0,127}));
  connect(gain.y, add.u2)
    annotation (Line(points={{-139,70},{-130,70}},        color={0,0,127}));
  connect(PAtm1.y, add.u1) annotation (Line(points={{-147,98},{-134,98},{-134,
          82},{-130,82}},
                     color={0,0,127}));
  connect(add.y, sou1.p_in) annotation (Line(points={{-107,76},{-98,76},{-98,56},
          {-98,46},{-90,46}},          color={0,0,127}));
  connect(PipeDelay.port_b, senTemPipeDelayOut.port_a) annotation (Line(
      points={{40,80},{56,80}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(masFloPipeDelay.port_a, senTemPipeDelayOut.port_b) annotation (Line(
      points={{88,80},{76,80}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senTemPipeDelayIn.port_b, PipeDelay.port_a)
    annotation (Line(points={{-40,80},{20,80}}, color={0,127,255}));
  connect(const3.y, PipeDelay.T_amb)
    annotation (Line(points={{-7,106},{30,106},{30,90}}, color={0,0,127}));
  connect(sou1.ports[2], senTemPipeDelayIn.port_a)
    annotation (Line(points={{-68,36},{-60,80}}, color={0,127,255}));
  connect(sin1.ports[2], masFloPipeDelay.port_b)
    annotation (Line(points={{120,36},{120,80},{108,80}}, color={0,127,255}));
  connect(senTempPipeDelayModIn.port_b, PipeDelayMod.port_a) annotation (Line(
      points={{-40,40},{-16,40},{-16,40},{6,40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(PipeDelayMod.port_b, senTemPipeDelayModOut.port_a) annotation (Line(
      points={{26,40},{44,40},{44,40},{56,40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(const3.y, PipeDelayMod.T_amb) annotation (Line(
      points={{-7,106},{2,106},{2,54},{18,54},{16,50}},
      color={0,0,127},
      smooth=Smooth.None));
    annotation (experiment(StopTime=200000, __Dymola_NumberOfIntervals=5000),
__Dymola_Commands(file="modelica://Annex60/Resources/Scripts/Dymola/Experimental/PipeAdiabatic/PipeAdiabatic_TStep.mos"
        "Simulate and plot"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-200,-180},{
            160,140}}), graphics),
    Documentation(info="<html>
<p>This example compares the current implementations of PipeHeatLoss_PipeDelay and PipeHeatLoss_PipeDelayMod.</p>
</html>", revisions="<html>
<ul>
<li>
February 11, 2016 by Marcus Fuchs:<br/>
Update doc-strings and documentation
</li>
<li>
October 1, 2015 by Marcus Fuchs:<br/>
First implementation.
</li>
</ul>
</html>"),
    __Dymola_experimentSetupOutput);
end A60pipe;

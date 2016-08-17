within Annex60.Experimental.Pipe.Examples;
package Vector

  model Vector_test_1
    "First test of a comparison between pipe models and experimental data from ULg"
    import Annex60;
    extends Modelica.Icons.Example;

    package Medium = Annex60.Media.Water;

    output Modelica.SIunits.Temperature TOutExperimental
      "Outlet water temperature from experimental data";

    parameter Modelica.SIunits.Diameter diameter=0.05248 "Pipe diameter";
    parameter Modelica.SIunits.Length length=39 "Pipe length";

    parameter Modelica.SIunits.Pressure dp_test = 200
      "Differential pressure for the test used in ramps";

    Modelica.Blocks.Sources.Constant PAtm(k=101325) "Atmospheric pressure"
        annotation (Placement(transformation(extent={{126,76},{146,96}})));

    Annex60.Fluid.Sources.Boundary_pT sin1(          redeclare package Medium
        = Medium,
      nPorts=1,
      use_p_in=true,
      T=283.15)
      "Sink at with constant pressure, turns into source at the end of experiment"
                            annotation (Placement(transformation(extent={{140,28},
              {120,48}})));
    Annex60.Fluid.Sensors.MassFlowRate masFloA60(redeclare package Medium =
          Medium) "Mass flow rate sensor for the A60 temperature delay"
      annotation (Placement(transformation(extent={{88,30},{108,50}})));

    Annex60.Experimental.Pipe.Archive.PipeHeatLossA60Ref A60PipeHeatLoss(
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
    Annex60.Fluid.Sensors.TemperatureTwoPort senTemA60In(redeclare package
        Medium =
          Medium, m_flow_nominal=0.5)
      "Temperature of the inflow to the A60 temperature delay"
      annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
    Annex60.Fluid.Sources.MassFlowSource_T boundary(
      redeclare package Medium = Medium,
      nPorts=1,
      use_m_flow_in=true,
      use_T_in=true)
      annotation (Placement(transformation(extent={{-100,0},{-80,20}})));
    Modelica.Blocks.Sources.CombiTimeTable combiTimeTable(table=
          pipeDataULg150801_1.data)
      annotation (Placement(transformation(extent={{-200,40},{-180,60}})));
    Annex60.Experimental.Pipe.Data.PipeDataULg150801 pipeDataULg150801_1
      annotation (Placement(transformation(extent={{-160,80},{-140,100}})));
    Modelica.Blocks.Math.Gain gain(k=2)
      annotation (Placement(transformation(extent={{-120,12},{-108,24}})));
    Modelica.Blocks.Math.Add add
      annotation (Placement(transformation(extent={{-166,4},{-146,24}})));
    Modelica.Blocks.Sources.Constant const1(k=273.15)
      annotation (Placement(transformation(extent={{-200,-2},{-180,18}})));
  equation
      TOutExperimental = combiTimeTable.y[3] + 273.15;
    connect(PAtm.y, sin1.p_in)
                              annotation (Line(points={{147,86},{154,86},{154,46},
            {142,46}},
                     color={0,0,127}));
    connect(sin1.ports[1],masFloA60. port_b) annotation (Line(
        points={{120,38},{114,38},{114,40},{108,40}},
        color={0,127,255},
        smooth=Smooth.None));
    connect(A60PipeHeatLoss.port_b, senTemA60Out.port_a) annotation (Line(
        points={{40,40},{56,40}},
        color={0,127,255},
        smooth=Smooth.None));
    connect(masFloA60.port_a,senTemA60Out. port_b) annotation (Line(
        points={{88,40},{76,40}},
        color={0,127,255},
        smooth=Smooth.None));
    connect(senTemA60In.port_b, A60PipeHeatLoss.port_a)
      annotation (Line(points={{-40,40},{20,40}}, color={0,127,255}));
    connect(boundary.ports[1], senTemA60In.port_a)
      annotation (Line(points={{-80,10},{-60,40}}, color={0,127,255}));
    connect(boundary.m_flow_in, gain.y)
      annotation (Line(points={{-100,18},{-107.4,18}}, color={0,0,127}));
    connect(combiTimeTable.y[1], gain.u) annotation (Line(points={{-179,50},{-132,
            50},{-132,18},{-121.2,18}}, color={0,0,127}));
    connect(const1.y, add.u2)
      annotation (Line(points={{-179,8},{-168,8}}, color={0,0,127}));
    connect(combiTimeTable.y[5], add.u1) annotation (Line(points={{-179,50},{-174,
            50},{-174,20},{-168,20}}, color={0,0,127}));
    connect(add.y, boundary.T_in)
      annotation (Line(points={{-145,14},{-102,14}}, color={0,0,127}));
      annotation (experiment(StopTime=875, __Dymola_NumberOfIntervals=5000),
  __Dymola_Commands(file="modelica://Annex60/Resources/Scripts/Dymola/Experimental/PipeAdiabatic/PipeAdiabatic_TStep.mos"
          "Simulate and plot"),
      Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-200,-100},{160,
              100}})),
      Documentation(info="<html>
<p>This example compares the KUL and A60 pipe heat loss implementations with experimental data from the ULg test bench.</p>
<p>This is only a first glimpse at the general behavior. Next step is to parameterize both models with comparable heat insulation properties. </p>
</html>",   revisions="<html>
<ul>
<li>
October 1, 2015 by Marcus Fuchs:<br/>
First implementation.
</li>
</ul>
</html>"),
      __Dymola_experimentSetupOutput);
  end Vector_test_1;

  model Vector_test_2
    extends Modelica.Icons.Example;
    parameter Modelica.SIunits.Pressure dp_test=200
      "Differential pressure for the test used in ramps";

    package Medium = Annex60.Media.Water;

    Fluid.Sources.Boundary_pT sin1(
      redeclare package Medium = Medium,
      use_p_in=true,
      use_T_in=true,
      T=283.15,
      nPorts=1)
      "Sink at with constant pressure, turns into source at the end of experiment"
      annotation (Placement(transformation(extent={{80,-10},{60,10}})));
    Fluid.Sources.Boundary_pT sou1(
      redeclare package Medium = Medium,
      use_p_in=true,
      T=283.15,
      nPorts=1)
      "Sink at with constant pressure, turns into source at the end of experiment"
      annotation (Placement(transformation(
          extent={{10,10},{-10,-10}},
          rotation=180,
          origin={-70,0})));
    Modelica.Blocks.Sources.Step stepT(
      height=10,
      offset=273.15 + 20,
      startTime=200)
      "Step temperature increase to test propagation of temperature wave"
      annotation (Placement(transformation(extent={{60,72},{80,92}})));
    Modelica.Blocks.Sources.Constant PAtm(k=101325) "Atmospheric pressure"
      annotation (Placement(transformation(extent={{60,40},{80,60}})));
    parameter Modelica.SIunits.MassFlowRate m_flow_nominal=0.5
      "Nominal mass flow rate, used for regularization near zero flow";
    Modelica.Blocks.Sources.Constant reverseP(k=-dp_test)
      "Atmospheric pressure"
      annotation (Placement(transformation(extent={{-100,40},{-80,60}})));
    Modelica.Blocks.Sources.Constant const3(k=273.15 + 5)
      annotation (Placement(transformation(extent={{-52,56},{-32,76}})));
    PipeHeatLoss_PipeDelayMod_voctorized pipeHeatLoss_PipeDelayMod_voctorized(
      redeclare package Medium = Medium,
      diameter=0.1,
      length=100,
      m_flow_nominal=2,
      thicknessIns=0.1,
      nPorts=1) annotation (Placement(transformation(extent={{-4,-12},{16,8}})));
  equation
    connect(stepT.y, sin1.T_in)
      annotation (Line(points={{81,82},{96,82},{96,4},{82,4}}, color={0,0,127}));
    connect(PAtm.y, sin1.p_in) annotation (Line(points={{81,50},{86,50},{90,50},{90,
            8},{82,8}}, color={0,0,127}));
    connect(reverseP.y, sou1.p_in) annotation (Line(points={{-79,50},{-56,50},{
            -56,26},{-82,26},{-82,8}}, color={0,0,127}));
    connect(const3.y, pipeHeatLoss_PipeDelayMod_voctorized.T_amb) annotation (
        Line(points={{-31,66},{-18,66},{-18,68},{-2,68},{-2,64},{-2,8},{6,8}},
          color={0,0,127}));
    connect(sou1.ports[1], pipeHeatLoss_PipeDelayMod_voctorized.port_a)
      annotation (Line(points={{-60,0},{-28,0},{-28,-2},{-4.6,-2}}, color={0,
            127,255}));
    connect(pipeHeatLoss_PipeDelayMod_voctorized.ports_b[1], sin1.ports[1])
      annotation (Line(points={{16,-2.1},{38,-2.1},{38,0},{60,0}}, color={0,127,
            255}));
    annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
              -100},{100,100}})),
      experiment(StopTime=20000, __Dymola_NumberOfIntervals=5000),
      __Dymola_experimentSetupOutput,
      Documentation(info="<html>
<p>Test to check behaviour of the <code><span style=\"font-family: Courier New,courier;\">PipeAdiabaticPlugFlow</span></code> in reverse flow. The flow propagates from the outlet to the inlet and a temperature step is applied. </p>
</html>",   revisions="<html>
<ul>
<li>February 16, 2016 by Bram van der Heijde:<br>Update description and revision history.</li>
<li><span style=\"font-family: MS Shell Dlg 2;\">June 23, 2015 by Marcus Fuchs:<br>First implementation. </span></li>
</ul>
</html>"));
  end Vector_test_2;

  model Vector_test_21
    extends Modelica.Icons.Example;
    parameter Modelica.SIunits.Pressure dp_test=200
      "Differential pressure for the test used in ramps";

    package Medium = Annex60.Media.Water;

    Fluid.Sources.Boundary_pT sin1(
      redeclare package Medium = Medium,
      use_p_in=true,
      use_T_in=true,
      T=283.15,
      nPorts=1)
      "Sink at with constant pressure, turns into source at the end of experiment"
      annotation (Placement(transformation(extent={{80,-10},{60,10}})));
    Fluid.Sources.Boundary_pT sou1(
      redeclare package Medium = Medium,
      use_p_in=true,
      T=283.15,
      nPorts=1)
      "Sink at with constant pressure, turns into source at the end of experiment"
      annotation (Placement(transformation(
          extent={{10,10},{-10,-10}},
          rotation=180,
          origin={-70,0})));
    Modelica.Blocks.Sources.Step stepT(
      height=10,
      offset=273.15 + 20,
      startTime=200)
      "Step temperature increase to test propagation of temperature wave"
      annotation (Placement(transformation(extent={{60,72},{80,92}})));
    Modelica.Blocks.Sources.Constant PAtm(k=101325) "Atmospheric pressure"
      annotation (Placement(transformation(extent={{60,40},{80,60}})));
    parameter Modelica.SIunits.MassFlowRate m_flow_nominal=0.5
      "Nominal mass flow rate, used for regularization near zero flow";
    Modelica.Blocks.Sources.Constant reverseP(k=-dp_test)
      "Atmospheric pressure"
      annotation (Placement(transformation(extent={{-100,40},{-80,60}})));
    Modelica.Blocks.Sources.Constant const3(k=273.15 + 5)
      annotation (Placement(transformation(extent={{-52,56},{-32,76}})));
    PipeHeatLoss_PipeDelayMod pipeHeatLoss_PipeDelayMod_voctorized(
      redeclare package Medium = Medium,
      diameter=0.1,
      length=100,
      m_flow_nominal=2,
      thicknessIns=0.1)
      annotation (Placement(transformation(extent={{-22,-10},{-2,10}})));
  equation
    connect(stepT.y, sin1.T_in)
      annotation (Line(points={{81,82},{96,82},{96,4},{82,4}}, color={0,0,127}));
    connect(PAtm.y, sin1.p_in) annotation (Line(points={{81,50},{86,50},{90,50},{90,
            8},{82,8}}, color={0,0,127}));
    connect(reverseP.y, sou1.p_in) annotation (Line(points={{-79,50},{-56,50},{
            -56,26},{-82,26},{-82,8}}, color={0,0,127}));
    connect(const3.y, pipeHeatLoss_PipeDelayMod_voctorized.T_amb) annotation (
        Line(points={{-31,66},{-18,66},{-18,68},{-2,68},{-2,64},{-2,10},{-12,10}},
          color={0,0,127}));
    connect(sou1.ports[1], pipeHeatLoss_PipeDelayMod_voctorized.port_a)
      annotation (Line(points={{-60,0},{-28,0},{-22,0}}, color={0,127,255}));
    connect(pipeHeatLoss_PipeDelayMod_voctorized.port_b, sin1.ports[1])
      annotation (Line(points={{-2,0},{30,0},{30,0},{60,0}}, color={0,127,255}));
    annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
              -100},{100,100}})),
      experiment(StopTime=20000, __Dymola_NumberOfIntervals=5000),
      __Dymola_experimentSetupOutput,
      Documentation(info="<html>
<p>Test to check behaviour of the <code><span style=\"font-family: Courier New,courier;\">PipeAdiabaticPlugFlow</span></code> in reverse flow. The flow propagates from the outlet to the inlet and a temperature step is applied. </p>
</html>",   revisions="<html>
<ul>
<li>February 16, 2016 by Bram van der Heijde:<br>Update description and revision history.</li>
<li><span style=\"font-family: MS Shell Dlg 2;\">June 23, 2015 by Marcus Fuchs:<br>First implementation. </span></li>
</ul>
</html>"));
  end Vector_test_21;

  model Vector_test_2a
    extends Modelica.Icons.Example;
    parameter Modelica.SIunits.Pressure dp_test=200
      "Differential pressure for the test used in ramps";

    package Medium = Annex60.Media.Water;

    Fluid.Sources.Boundary_pT sin1(
      redeclare package Medium = Medium,
      use_p_in=true,
      use_T_in=true,
      T=283.15,
      nPorts=2)
      "Sink at with constant pressure, turns into source at the end of experiment"
      annotation (Placement(transformation(extent={{270,-20},{250,0}})));
    Fluid.Sources.Boundary_pT sou1(
      redeclare package Medium = Medium,
      use_p_in=true,
      T=283.15,
      nPorts=1)
      "Sink at with constant pressure, turns into source at the end of experiment"
      annotation (Placement(transformation(
          extent={{10,10},{-10,-10}},
          rotation=180,
          origin={-84,0})));
    Modelica.Blocks.Sources.Step stepT(
      height=10,
      offset=273.15 + 20,
      startTime=200)
      "Step temperature increase to test propagation of temperature wave"
      annotation (Placement(transformation(extent={{284,74},{304,94}})));
    Modelica.Blocks.Sources.Constant PAtm(k=101325) "Atmospheric pressure"
      annotation (Placement(transformation(extent={{284,42},{304,62}})));
    parameter Modelica.SIunits.MassFlowRate m_flow_nominal=0.5
      "Nominal mass flow rate, used for regularization near zero flow";
    Modelica.Blocks.Sources.Constant reverseP(k=-dp_test)
      "Atmospheric pressure"
      annotation (Placement(transformation(extent={{-100,40},{-80,60}})));
    Modelica.Blocks.Sources.Constant const3(k=273.15 + 5)
      annotation (Placement(transformation(extent={{-52,56},{-32,76}})));
    PipeHeatLoss_PipeDelayMod_voctorized pipeHeatLoss_PipeDelayMod_voctorized(
      redeclare package Medium = Medium,
      diameter=0.1,
      length=100,
      m_flow_nominal=2,
      thicknessIns=0.1,
      nPorts=2)
      annotation (Placement(transformation(extent={{-62,-10},{-42,10}})));
    PipeHeatLoss_PipeDelayMod_voctorized pipeHeatLoss_PipeDelayMod_voctorized1(
      redeclare package Medium = Medium,
      diameter=0.1,
      length=100,
      m_flow_nominal=2,
      thicknessIns=0.1,
      nPorts=1) annotation (Placement(transformation(extent={{-24,-6},{-8,8}})));
    PipeHeatLoss_PipeDelayMod_voctorized pipeHeatLoss_PipeDelayMod_voctorized2(
      redeclare package Medium = Medium,
      diameter=0.1,
      length=100,
      m_flow_nominal=2,
      thicknessIns=0.1,
      nPorts=1)
      annotation (Placement(transformation(extent={{28,-40},{48,-20}})));
    PipeHeatLoss_PipeDelayMod_voctorized pipeHeatLoss_PipeDelayMod_voctorized3(
      redeclare package Medium = Medium,
      diameter=0.1,
      length=100,
      m_flow_nominal=2,
      thicknessIns=0.1,
      nPorts=2) annotation (Placement(transformation(extent={{20,-4},{36,10}})));
    PipeHeatLoss_PipeDelayMod_voctorized pipeHeatLoss_PipeDelayMod_voctorized4(
      redeclare package Medium = Medium,
      diameter=0.1,
      length=100,
      m_flow_nominal=2,
      thicknessIns=0.1,
      nPorts=1) annotation (Placement(transformation(extent={{62,-4},{78,10}})));
    PipeHeatLoss_PipeDelayMod_voctorized pipeHeatLoss_PipeDelayMod_voctorized5(
      redeclare package Medium = Medium,
      diameter=0.1,
      length=100,
      m_flow_nominal=2,
      thicknessIns=0.1,
      nPorts=1)
      annotation (Placement(transformation(extent={{178,-2},{194,12}})));
    PipeHeatLoss_PipeDelayMod_voctorized pipeHeatLoss_PipeDelayMod_voctorized6(
      redeclare package Medium = Medium,
      diameter=0.1,
      length=100,
      m_flow_nominal=2,
      thicknessIns=0.1,
      nPorts=1)
      annotation (Placement(transformation(extent={{136,-2},{152,12}})));
    PipeHeatLoss_PipeDelayMod_voctorized pipeHeatLoss_PipeDelayMod_voctorized7(
      redeclare package Medium = Medium,
      diameter=0.1,
      length=100,
      m_flow_nominal=2,
      thicknessIns=0.1,
      nPorts=1)
      annotation (Placement(transformation(extent={{92,-4},{108,10}})));
  equation
    connect(stepT.y, sin1.T_in)
      annotation (Line(points={{305,84},{320,84},{320,-6},{272,-6}},
                                                               color={0,0,127}));
    connect(PAtm.y, sin1.p_in) annotation (Line(points={{305,52},{310,52},{314,
            52},{314,-2},{272,-2}},
                        color={0,0,127}));
    connect(reverseP.y, sou1.p_in) annotation (Line(points={{-79,50},{-56,50},{
            -56,26},{-96,26},{-96,8}}, color={0,0,127}));
    connect(const3.y, pipeHeatLoss_PipeDelayMod_voctorized.T_amb) annotation (
        Line(points={{-31,66},{-18,66},{-18,68},{-2,68},{-2,10},{-52,10}},
          color={0,0,127}));
    connect(sou1.ports[1], pipeHeatLoss_PipeDelayMod_voctorized.port_a)
      annotation (Line(points={{-74,0},{-62.6,0}}, color={0,127,255}));
    connect(pipeHeatLoss_PipeDelayMod_voctorized2.port_a,
      pipeHeatLoss_PipeDelayMod_voctorized.ports_b[1]) annotation (Line(points=
            {{27.4,-30},{18,-30},{18,-2.15},{-42,-2.15}}, color={0,127,255}));
    connect(pipeHeatLoss_PipeDelayMod_voctorized2.ports_b[1], sin1.ports[1])
      annotation (Line(points={{48,-30.1},{54,-30.1},{54,-8},{250,-8}}, color={
            0,127,255}));
    connect(pipeHeatLoss_PipeDelayMod_voctorized1.T_amb,
      pipeHeatLoss_PipeDelayMod_voctorized.T_amb) annotation (Line(points={{-16,
            8},{14,8},{14,66},{-2,66},{-2,10},{-52,10}}, color={0,0,127}));
    connect(pipeHeatLoss_PipeDelayMod_voctorized2.T_amb,
      pipeHeatLoss_PipeDelayMod_voctorized.T_amb) annotation (Line(points={{38,
            -20},{18,-20},{18,66},{-2,66},{-2,10},{-52,10}}, color={0,0,127}));
    connect(pipeHeatLoss_PipeDelayMod_voctorized1.ports_b[1],
      pipeHeatLoss_PipeDelayMod_voctorized3.port_a) annotation (Line(points={{
            -8,0.93},{18,0.93},{18,3},{19.52,3}}, color={0,127,255}));
    connect(pipeHeatLoss_PipeDelayMod_voctorized3.ports_b[1],
      pipeHeatLoss_PipeDelayMod_voctorized4.port_a) annotation (Line(points={{
            36,1.495},{58,1.495},{58,3},{61.52,3}}, color={0,127,255}));
    connect(pipeHeatLoss_PipeDelayMod_voctorized3.T_amb,
      pipeHeatLoss_PipeDelayMod_voctorized.T_amb) annotation (Line(points={{28,
            10},{32,10},{32,66},{-2,66},{-2,10},{-52,10}}, color={0,0,127}));
    connect(pipeHeatLoss_PipeDelayMod_voctorized4.T_amb,
      pipeHeatLoss_PipeDelayMod_voctorized.T_amb) annotation (Line(points={{70,
            10},{44,10},{44,66},{-2,66},{-2,10},{-52,10}}, color={0,0,127}));
    connect(pipeHeatLoss_PipeDelayMod_voctorized1.port_a,
      pipeHeatLoss_PipeDelayMod_voctorized.ports_b[2]) annotation (Line(points=
            {{-24.48,1},{-33.24,1},{-33.24,1.95},{-42,1.95}}, color={0,127,255}));
    connect(pipeHeatLoss_PipeDelayMod_voctorized4.ports_b[1],
      pipeHeatLoss_PipeDelayMod_voctorized7.port_a) annotation (Line(points={{
            78,2.93},{86,2.93},{86,3},{91.52,3}}, color={0,127,255}));
    connect(pipeHeatLoss_PipeDelayMod_voctorized7.ports_b[1],
      pipeHeatLoss_PipeDelayMod_voctorized6.port_a) annotation (Line(points={{
            108,2.93},{122,2.93},{122,5},{135.52,5}}, color={0,127,255}));
    connect(pipeHeatLoss_PipeDelayMod_voctorized6.ports_b[1],
      pipeHeatLoss_PipeDelayMod_voctorized5.port_a) annotation (Line(points={{
            152,4.93},{165,4.93},{165,5},{177.52,5}}, color={0,127,255}));
    connect(pipeHeatLoss_PipeDelayMod_voctorized5.ports_b[1], sin1.ports[2])
      annotation (Line(points={{194,4.93},{221,4.93},{221,-12},{250,-12}},
          color={0,127,255}));
    connect(pipeHeatLoss_PipeDelayMod_voctorized7.T_amb,
      pipeHeatLoss_PipeDelayMod_voctorized.T_amb) annotation (Line(points={{100,
            10},{70,10},{70,66},{-2,66},{-2,10},{-52,10}}, color={0,0,127}));
    connect(pipeHeatLoss_PipeDelayMod_voctorized6.T_amb,
      pipeHeatLoss_PipeDelayMod_voctorized.T_amb) annotation (Line(points={{144,
            12},{104,12},{104,70},{64,70},{64,66},{-2,66},{-2,10},{-52,10}},
          color={0,0,127}));
    connect(pipeHeatLoss_PipeDelayMod_voctorized5.T_amb,
      pipeHeatLoss_PipeDelayMod_voctorized.T_amb) annotation (Line(points={{186,
            12},{128,12},{128,70},{64,70},{64,66},{-2,66},{-2,10},{-52,10}},
          color={0,0,127}));
    annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
              -100},{280,100}})),
      experiment(StopTime=20000, __Dymola_NumberOfIntervals=5000),
      __Dymola_experimentSetupOutput,
      Documentation(info="<html>
<p>Test to check behaviour of the <code><span style=\"font-family: Courier New,courier;\">PipeAdiabaticPlugFlow</span></code> in reverse flow. The flow propagates from the outlet to the inlet and a temperature step is applied. </p>
</html>",   revisions="<html>
<ul>
<li>February 16, 2016 by Bram van der Heijde:<br>Update description and revision history.</li>
<li><span style=\"font-family: MS Shell Dlg 2;\">June 23, 2015 by Marcus Fuchs:<br>First implementation. </span></li>
</ul>
</html>"),
      Icon(coordinateSystem(extent={{-100,-100},{280,100}})));
  end Vector_test_2a;

  model Vector_test_21a
    extends Modelica.Icons.Example;
    parameter Modelica.SIunits.Pressure dp_test=200
      "Differential pressure for the test used in ramps";

    package Medium = Annex60.Media.Water;

    Fluid.Sources.Boundary_pT sin1(
      redeclare package Medium = Medium,
      use_p_in=true,
      use_T_in=true,
      T=283.15,
      nPorts=2)
      "Sink at with constant pressure, turns into source at the end of experiment"
      annotation (Placement(transformation(extent={{352,-20},{332,0}})));
    Fluid.Sources.Boundary_pT sou1(
      redeclare package Medium = Medium,
      use_p_in=true,
      T=283.15,
      nPorts=1)
      "Sink at with constant pressure, turns into source at the end of experiment"
      annotation (Placement(transformation(
          extent={{10,10},{-10,-10}},
          rotation=180,
          origin={-70,0})));
    Modelica.Blocks.Sources.Step stepT(
      height=10,
      offset=273.15 + 20,
      startTime=200)
      "Step temperature increase to test propagation of temperature wave"
      annotation (Placement(transformation(extent={{332,62},{352,82}})));
    Modelica.Blocks.Sources.Constant PAtm(k=101325) "Atmospheric pressure"
      annotation (Placement(transformation(extent={{332,30},{352,50}})));
    parameter Modelica.SIunits.MassFlowRate m_flow_nominal=0.5
      "Nominal mass flow rate, used for regularization near zero flow";
    Modelica.Blocks.Sources.Constant reverseP(k=-dp_test)
      "Atmospheric pressure"
      annotation (Placement(transformation(extent={{-100,40},{-80,60}})));
    Modelica.Blocks.Sources.Constant const3(k=273.15 + 5)
      annotation (Placement(transformation(extent={{-52,56},{-32,76}})));
    PipeHeatLoss_PipeDelayMod pipeHeatLoss_PipeDelayMod_voctorized(
      redeclare package Medium = Medium,
      diameter=0.1,
      length=100,
      m_flow_nominal=2,
      thicknessIns=0.1)
      annotation (Placement(transformation(extent={{-28,-10},{-8,10}})));
    PipeHeatLoss_PipeDelayMod pipeHeatLoss_PipeDelayMod_voctorized1(
      redeclare package Medium = Medium,
      diameter=0.1,
      length=100,
      m_flow_nominal=2,
      thicknessIns=0.1)
      annotation (Placement(transformation(extent={{6,-28},{26,-8}})));
    PipeHeatLoss_PipeDelayMod pipeHeatLoss_PipeDelayMod_voctorized2(
      redeclare package Medium = Medium,
      diameter=0.1,
      length=100,
      m_flow_nominal=2,
      thicknessIns=0.1)
      annotation (Placement(transformation(extent={{10,12},{22,24}})));
    PipeHeatLoss_PipeDelayMod pipeHeatLoss_PipeDelayMod_voctorized3(
      redeclare package Medium = Medium,
      diameter=0.1,
      length=100,
      m_flow_nominal=2,
      thicknessIns=0.1)
      annotation (Placement(transformation(extent={{28,12},{40,24}})));
    PipeHeatLoss_PipeDelayMod pipeHeatLoss_PipeDelayMod_voctorized4(
      redeclare package Medium = Medium,
      diameter=0.1,
      length=100,
      m_flow_nominal=2,
      thicknessIns=0.1)
      annotation (Placement(transformation(extent={{44,12},{56,24}})));
    PipeHeatLoss_PipeDelayMod pipeHeatLoss_PipeDelayMod_voctorized5(
      redeclare package Medium = Medium,
      diameter=0.1,
      length=100,
      m_flow_nominal=2,
      thicknessIns=0.1)
      annotation (Placement(transformation(extent={{64,8},{76,20}})));
    PipeHeatLoss_PipeDelayMod pipeHeatLoss_PipeDelayMod_voctorized6(
      redeclare package Medium = Medium,
      diameter=0.1,
      length=100,
      m_flow_nominal=2,
      thicknessIns=0.1)
      annotation (Placement(transformation(extent={{82,8},{94,20}})));
    PipeHeatLoss_PipeDelayMod pipeHeatLoss_PipeDelayMod_voctorized7(
      redeclare package Medium = Medium,
      diameter=0.1,
      length=100,
      m_flow_nominal=2,
      thicknessIns=0.1)
      annotation (Placement(transformation(extent={{98,8},{110,20}})));
  equation
    connect(stepT.y, sin1.T_in)
      annotation (Line(points={{353,72},{400,72},{400,-6},{354,-6}},
                                                               color={0,0,127}));
    connect(PAtm.y, sin1.p_in) annotation (Line(points={{353,40},{353,36},{394,
            36},{394,-2},{354,-2}},
                        color={0,0,127}));
    connect(reverseP.y, sou1.p_in) annotation (Line(points={{-79,50},{-56,50},{
            -56,26},{-82,26},{-82,8}}, color={0,0,127}));
    connect(const3.y, pipeHeatLoss_PipeDelayMod_voctorized.T_amb) annotation (
        Line(points={{-31,66},{-18,66},{-18,68},{-2,68},{-2,64},{-2,10},{-18,10}},
          color={0,0,127}));
    connect(sou1.ports[1], pipeHeatLoss_PipeDelayMod_voctorized.port_a)
      annotation (Line(points={{-60,0},{-28,0}}, color={0,127,255}));
    connect(pipeHeatLoss_PipeDelayMod_voctorized1.port_a,
      pipeHeatLoss_PipeDelayMod_voctorized.port_b) annotation (Line(points={{6,
            -18},{-2,-18},{-2,0},{-8,0}}, color={0,127,255}));
    connect(pipeHeatLoss_PipeDelayMod_voctorized.port_b,
      pipeHeatLoss_PipeDelayMod_voctorized2.port_a) annotation (Line(points={{
            -8,0},{2,0},{2,18},{10,18}}, color={0,127,255}));
    connect(pipeHeatLoss_PipeDelayMod_voctorized1.port_b, sin1.ports[1])
      annotation (Line(points={{26,-18},{44,-18},{44,-8},{332,-8}}, color={0,
            127,255}));
    connect(pipeHeatLoss_PipeDelayMod_voctorized2.T_amb,
      pipeHeatLoss_PipeDelayMod_voctorized.T_amb) annotation (Line(points={{16,
            24},{10,24},{10,60},{-2,60},{-2,10},{-18,10}}, color={0,0,127}));
    connect(pipeHeatLoss_PipeDelayMod_voctorized1.T_amb,
      pipeHeatLoss_PipeDelayMod_voctorized.T_amb) annotation (Line(points={{16,
            -8},{8,-8},{8,60},{-2,60},{-2,10},{-18,10}}, color={0,0,127}));
    connect(pipeHeatLoss_PipeDelayMod_voctorized2.port_b,
      pipeHeatLoss_PipeDelayMod_voctorized3.port_a)
      annotation (Line(points={{22,18},{28,18}}, color={0,127,255}));
    connect(pipeHeatLoss_PipeDelayMod_voctorized3.port_b,
      pipeHeatLoss_PipeDelayMod_voctorized4.port_a)
      annotation (Line(points={{40,18},{42,18},{44,18}}, color={0,127,255}));
    connect(pipeHeatLoss_PipeDelayMod_voctorized3.T_amb,
      pipeHeatLoss_PipeDelayMod_voctorized.T_amb) annotation (Line(points={{34,
            24},{22,24},{22,60},{-2,60},{-2,10},{-18,10}}, color={0,0,127}));
    connect(pipeHeatLoss_PipeDelayMod_voctorized4.T_amb,
      pipeHeatLoss_PipeDelayMod_voctorized.T_amb) annotation (Line(points={{50,
            24},{30,24},{30,60},{-2,60},{-2,10},{-18,10}}, color={0,0,127}));
    connect(pipeHeatLoss_PipeDelayMod_voctorized5.port_b,
      pipeHeatLoss_PipeDelayMod_voctorized6.port_a)
      annotation (Line(points={{76,14},{82,14}}, color={0,127,255}));
    connect(pipeHeatLoss_PipeDelayMod_voctorized6.port_b,
      pipeHeatLoss_PipeDelayMod_voctorized7.port_a)
      annotation (Line(points={{94,14},{96,14},{98,14}}, color={0,127,255}));
    connect(pipeHeatLoss_PipeDelayMod_voctorized4.port_b,
      pipeHeatLoss_PipeDelayMod_voctorized5.port_a) annotation (Line(points={{
            56,18},{60,18},{60,14},{64,14}}, color={0,127,255}));
    connect(pipeHeatLoss_PipeDelayMod_voctorized7.port_b, sin1.ports[2])
      annotation (Line(points={{110,14},{222,14},{222,-12},{332,-12}}, color={0,
            127,255}));
    connect(pipeHeatLoss_PipeDelayMod_voctorized5.T_amb,
      pipeHeatLoss_PipeDelayMod_voctorized.T_amb) annotation (Line(points={{70,
            20},{50,20},{50,60},{-2,60},{-2,10},{-18,10}}, color={0,0,127}));
    connect(pipeHeatLoss_PipeDelayMod_voctorized6.T_amb,
      pipeHeatLoss_PipeDelayMod_voctorized.T_amb) annotation (Line(points={{88,
            20},{68,20},{68,60},{-2,60},{-2,10},{-18,10}}, color={0,0,127}));
    connect(pipeHeatLoss_PipeDelayMod_voctorized7.T_amb,
      pipeHeatLoss_PipeDelayMod_voctorized.T_amb) annotation (Line(points={{104,
            20},{86,20},{86,58},{68,58},{68,60},{-2,60},{-2,10},{-18,10}},
          color={0,0,127}));
    annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
              -100},{300,100}})),
      experiment(StopTime=20000, __Dymola_NumberOfIntervals=5000),
      __Dymola_experimentSetupOutput,
      Documentation(info="<html>
<p>Test to check behaviour of the <code><span style=\"font-family: Courier New,courier;\">PipeAdiabaticPlugFlow</span></code> in reverse flow. The flow propagates from the outlet to the inlet and a temperature step is applied. </p>
</html>",   revisions="<html>
<ul>
<li>February 16, 2016 by Bram van der Heijde:<br>Update description and revision history.</li>
<li><span style=\"font-family: MS Shell Dlg 2;\">June 23, 2015 by Marcus Fuchs:<br>First implementation. </span></li>
</ul>
</html>"),
      Icon(coordinateSystem(extent={{-100,-100},{300,100}})));
  end Vector_test_21a;
end Vector;

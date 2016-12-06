within Annex60.Experimental.Pipe.Examples.DoublePipe;
model ParallelPipesTempStep
  "In order to test a parallel flow double pipe for a temperature step (no mass flow change)"
  import Annex60;
  extends Modelica.Icons.Example;

  package Medium = Annex60.Media.Water;

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal=0.5
    "Nominal mass flow rate";
  parameter Modelica.SIunits.Pressure dp_test=200;

  Fluid.Sources.Boundary_pT supplySource(redeclare package Medium = Medium,
      use_p_in=true,
    use_T_in=true,
    nPorts=1)
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));

  Fluid.Sources.Boundary_pT supplySink(
    redeclare package Medium = Medium,
    use_p_in=true,
    use_T_in=true,
    nPorts=1) annotation (Placement(transformation(extent={{80,20},{60,40}})));
  Fluid.Sources.Boundary_pT returnSink(
    redeclare package Medium = Medium,
    use_p_in=true,
    use_T_in=true,
    nPorts=1)
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Fluid.Sources.Boundary_pT returnSource(
    redeclare package Medium = Medium,
    use_p_in=true,
    use_T_in=true,
    nPorts=1) annotation (Placement(transformation(extent={{80,-40},{60,-20}})));
  Modelica.Blocks.Sources.Constant PAtm(k=101325) "Atmospheric pressure"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={110,10})));
  Modelica.Blocks.Sources.Constant TReturn(k=273.15 + 40)
    "Atmospheric pressure" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-160,-50})));
  Modelica.Blocks.Math.Gain gain(k=dp_test)
    annotation (Placement(transformation(extent={{-156,16},{-136,36}})));
  Modelica.Blocks.Math.Add add
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,38})));
  Modelica.Blocks.Math.Add add1(k1=+1)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,-22})));

  Annex60.Fluid.Sensors.TemperatureTwoPort senTemSupplyIn(redeclare package
      Medium = Medium, m_flow_nominal=m_flow_nominal)
    annotation (Placement(transformation(extent={{-50,20},{-30,40}})));
  Annex60.Fluid.Sensors.TemperatureTwoPort senTemReturnIn(redeclare package
      Medium = Medium, m_flow_nominal=m_flow_nominal) annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-38,-30})));
  Annex60.Fluid.Sensors.TemperatureTwoPort senTemSupplyOut(redeclare package
      Medium = Medium, m_flow_nominal=m_flow_nominal)
    annotation (Placement(transformation(extent={{30,20},{50,40}})));
  Annex60.Fluid.Sensors.TemperatureTwoPort senTemReturnOut(redeclare package
      Medium = Medium, m_flow_nominal=m_flow_nominal) annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={40,-30})));
  Modelica.Blocks.Sources.CombiTimeTable combiTimeTable(smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments, table=[0,
        1; 200000,1])
    annotation (Placement(transformation(extent={{-188,16},{-168,36}})));
  Annex60.Experimental.Pipe.DoublePipeParallel doublePipeParallel(
    length=length,
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    redeclare
      Annex60.Experimental.Pipe.BaseClasses.DoublePipeConfig.IsoPlusDoubleReinforced.IsoPlusDR200R
      pipeData)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  parameter Modelica.SIunits.Length length=100 "Pipe length";
  Modelica.Blocks.Math.Add add2(k1=+1)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,-90})));
  Modelica.Blocks.Sources.Step step(startTime=80000, height=25)
    annotation (Placement(transformation(extent={{-178,-90},{-158,-70}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=
        278.15) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,90})));
  Modelica.Blocks.Sources.Constant TReturn1(k=273.15 + 90)
    "Atmospheric pressure" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={60,122})));
  Modelica.Blocks.Math.Add add3(k1=+1)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={110,82})));
  Modelica.Blocks.Sources.Step step1(startTime=80000, height=-25)
    annotation (Placement(transformation(extent={{42,82},{62,102}})));
equation
  connect(PAtm.y, supplySink.p_in) annotation (Line(points={{99,10},{92,10},{92,
          38},{82,38}}, color={0,0,127}));
  connect(PAtm.y, returnSource.p_in) annotation (Line(points={{99,10},{92,10},{
          92,-22},{82,-22}},
                          color={0,0,127}));
  connect(gain.y,add. u2)
    annotation (Line(points={{-135,26},{-126,26},{-126,32},{-122,32}},
                                                          color={0,0,127}));
  connect(add.y, supplySource.p_in)
    annotation (Line(points={{-99,38},{-99,38},{-82,38}}, color={0,0,127}));
  connect(gain.y, add1.u1) annotation (Line(points={{-135,26},{-126,26},{-126,
          -16},{-122,-16}},
                      color={0,0,127}));
  connect(PAtm.y, add.u1) annotation (Line(points={{99,10},{92,10},{92,68},{
          -130,68},{-130,44},{-122,44}},
                                    color={0,0,127}));
  connect(add1.u2, add.u1) annotation (Line(points={{-122,-28},{-130,-28},{-130,
          44},{-122,44}},
                      color={0,0,127}));
  connect(supplySource.ports[1], senTemSupplyIn.port_a)
    annotation (Line(points={{-60,30},{-50,30},{-50,30}}, color={0,127,255}));
  connect(senTemSupplyOut.port_b, supplySink.ports[1])
    annotation (Line(points={{50,30},{55,30},{60,30}}, color={0,127,255}));
  connect(add1.y, returnSink.p_in)
    annotation (Line(points={{-99,-22},{-82,-22}},           color={0,0,127}));
  connect(gain.u, combiTimeTable.y[1])
    annotation (Line(points={{-158,26},{-167,26}}, color={0,0,127}));
  connect(senTemSupplyIn.port_b, doublePipeParallel.port_a1) annotation (Line(
        points={{-30,30},{-20,30},{-20,6},{-10,6}}, color={0,127,255}));
  connect(senTemSupplyOut.port_a, doublePipeParallel.port_b1) annotation (Line(
        points={{30,30},{20,30},{20,6},{10,6}}, color={0,127,255}));
  connect(TReturn.y, add2.u1) annotation (Line(points={{-149,-50},{-138,-50},{
          -138,-84},{-122,-84}}, color={0,0,127}));
  connect(step.y, add2.u2) annotation (Line(points={{-157,-80},{-150,-80},{-150,
          -94},{-122,-94},{-122,-96}}, color={0,0,127}));
  connect(add2.y, returnSource.T_in) annotation (Line(points={{-99,-90},{-99,
          -90},{104,-90},{104,-26},{82,-26}},
                                       color={0,0,127}));
  connect(fixedTemperature.port, doublePipeParallel.heatPort)
    annotation (Line(points={{0,80},{0,45},{0,10}}, color={191,0,0}));
  connect(returnSink.ports[1], senTemReturnIn.port_a)
    annotation (Line(points={{-60,-30},{-48,-30}}, color={0,127,255}));
  connect(senTemReturnIn.port_b, doublePipeParallel.port_a2) annotation (Line(
        points={{-28,-30},{-20,-30},{-20,-6},{-10,-6}}, color={0,127,255}));
  connect(doublePipeParallel.port_b2, senTemReturnOut.port_a) annotation (Line(
        points={{10,-6},{20,-6},{20,-30},{30,-30}}, color={0,127,255}));
  connect(senTemReturnOut.port_b, returnSource.ports[1])
    annotation (Line(points={{50,-30},{60,-30}}, color={0,127,255}));
  connect(TReturn1.y, add3.u1) annotation (Line(points={{71,122},{82,122},{82,
          88},{98,88}}, color={0,0,127}));
  connect(step1.y, add3.u2) annotation (Line(points={{63,92},{70,92},{70,78},{
          98,78},{98,76}}, color={0,0,127}));
  connect(add3.y, supplySource.T_in) annotation (Line(points={{121,82},{130,82},
          {130,50},{-94,50},{-94,34},{-82,34}}, color={0,0,127}));
  connect(supplySink.T_in, supplySource.T_in) annotation (Line(points={{82,34},
          {130,34},{130,50},{-94,50},{-94,34},{-82,34}}, color={0,0,127}));
  connect(returnSink.T_in, returnSource.T_in) annotation (Line(points={{-82,-26},
          {-94,-26},{-94,-90},{104,-90},{104,-26},{82,-26}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-200,
            -100},{140,100}})),
    Icon(coordinateSystem(extent={{-200,-100},{140,100}})),
    experiment(StopTime=200000),
    __Dymola_experimentSetupOutput,
    __Dymola_Commands,
    Documentation(info="<html>
<p>Example to test the parallel flow implementation of a double pipe. Simple mass flow in one direction, temperature step in supply and return to investigate mutual influence of pipes</p>
</html>", revisions="<html>
<ul>
<li>March 18, 2016 by Bram van der Heijde:<br>First implementation</li>
</ul>
</html>"));
end ParallelPipesTempStep;

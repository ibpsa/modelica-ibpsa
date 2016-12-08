within Annex60.Experimental.Pipe.Examples.DoublePipe;
model ParallelPipesHeatExchangers
  extends Modelica.Icons.Example;

  Annex60.Experimental.Pipe.DoublePipeParallel doublePipeParallel(
    length=100,
    H=2,
    redeclare
      Annex60.Experimental.Pipe.BaseClasses.DoublePipeConfig.IsoPlusDoubleStandard.IsoPlusDR100S
      pipeData,
    redeclare package Medium = Medium,
    m_flow_nominal=0.5,
    T_start=363.15)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Annex60.Fluid.Sensors.TemperatureTwoPort supIn(
    m_flow_nominal=0.5,
    tau=tau,
    redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));
  parameter Modelica.SIunits.Time tau=1 "Time constant at nominal flow rate";
  package Medium = Annex60.Media.Water;
  Annex60.Fluid.Sensors.TemperatureTwoPort retIn(
    m_flow_nominal=0.5,
    tau=tau,
    redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));
  Annex60.Fluid.Sensors.TemperatureTwoPort supOut(
    m_flow_nominal=0.5,
    tau=tau,
    redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{20,10},{40,30}})));
  Annex60.Fluid.Sensors.TemperatureTwoPort retOut(
    m_flow_nominal=0.5,
    tau=tau,
    redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{20,-30},{40,-10}})));
  Annex60.Fluid.Movers.FlowControlled_m_flow fan(
    redeclare package Medium = Medium,
    m_flow_nominal=0.5,
    inputType=Annex60.Fluid.Types.InputType.Constant,
    constantMassFlowRate=0.5)
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  Annex60.Fluid.HeatExchangers.HeaterCooler_T hea(
    redeclare package Medium = Medium,
    m_flow_nominal=0.5,
    dp_nominal=10)
    annotation (Placement(transformation(extent={{-20,60},{0,80}})));
  Annex60.Fluid.HeatExchangers.HeaterCooler_T hea1(
    redeclare package Medium = Medium,
    m_flow_nominal=0.5,
    dp_nominal=10) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={10,-80})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=273.15 + 70)
    annotation (Placement(transformation(extent={{42,-104},{62,-84}})));
  Modelica.Blocks.Sources.RealExpression realExpression1(y=273.15 + 90)
    annotation (Placement(transformation(extent={{-52,80},{-32,100}})));
  Annex60.Fluid.Sources.Boundary_pT bou(
    nPorts=1,
    redeclare package Medium = Medium,
    p=100000,
    T=343.15)
    annotation (Placement(transformation(extent={{-100,28},{-80,48}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=
        278.15)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={46,70})));
equation
  connect(supIn.port_b, doublePipeParallel.port_a1) annotation (Line(points={{-20,
          20},{-16,20},{-16,6},{-10,6}}, color={0,127,255}));
  connect(retIn.port_b, doublePipeParallel.port_a2) annotation (Line(points={{-20,
          -20},{-16,-20},{-16,-6},{-10,-6}}, color={0,127,255}));
  connect(doublePipeParallel.port_b1, supOut.port_a) annotation (Line(points={{10,
          6},{16,6},{16,20},{20,20}}, color={0,127,255}));
  connect(doublePipeParallel.port_b2, retOut.port_a) annotation (Line(points={{10,
          -6},{16,-6},{16,-20},{20,-20}}, color={0,127,255}));
  connect(fan.port_b, hea.port_a)
    annotation (Line(points={{-40,70},{-30,70},{-20,70}}, color={0,127,255}));
  connect(hea.port_b, supIn.port_a) annotation (Line(points={{0,70},{10,70},{20,
          70},{20,40},{-40,40},{-40,20}}, color={0,127,255}));
  connect(supOut.port_b, hea1.port_a) annotation (Line(points={{40,20},{80,20},{
          80,-80},{20,-80}}, color={0,127,255}));
  connect(hea1.port_b, retIn.port_a) annotation (Line(points={{0,-80},{-80,-80},
          {-80,-20},{-40,-20}}, color={0,127,255}));
  connect(realExpression.y, hea1.TSet) annotation (Line(points={{63,-94},{68,-94},
          {68,-86},{22,-86}}, color={0,0,127}));
  connect(hea.TSet, realExpression1.y) annotation (Line(points={{-22,76},{-26,76},
          {-26,90},{-31,90}}, color={0,0,127}));
  connect(retOut.port_b, fan.port_a) annotation (Line(points={{40,-20},{56,-20},
          {56,-50},{-72,-50},{-72,70},{-60,70}}, color={0,127,255}));
  connect(bou.ports[1], fan.port_a) annotation (Line(points={{-80,38},{-80,38},{
          -78,38},{-72,38},{-72,70},{-60,70}}, color={0,127,255}));
  connect(fixedTemperature.port, doublePipeParallel.heatPort) annotation (Line(
        points={{46,60},{46,60},{46,32},{46,34},{0,34},{0,10}}, color={191,0,0}));
  annotation (                                                         Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})),
      Documentation(revisions="<html>
<ul>
<li>March 2, 2016 by Bram van der Heijde:<br>First implementation</li>
</ul>
</html>", info="<html>
<p>Test of a parallel flow double pipe installed in a closed circuit. Heat is added and removed by ideal heat exchangers in order to represent different supply and return temperature.</p>
</html>"),
    experiment(StopTime=20000),
    __Dymola_experimentSetupOutput);
end ParallelPipesHeatExchangers;

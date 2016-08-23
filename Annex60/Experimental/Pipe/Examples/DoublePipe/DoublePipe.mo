within Annex60.Experimental.Pipe.Examples.DoublePipe;
model DoublePipe "Simple test of double pipe component"
  import Annex60;
  extends Modelica.Icons.Example;

  package Medium = Annex60.Media.Water;
  parameter Modelica.SIunits.Pressure dp_test=200
    "Differential pressure for the test used in ramps";
  Fluid.Sources.Boundary_pT sou1(
    redeclare package Medium = Medium,
    use_p_in=true,
    use_T_in=true,
    nPorts=1,
    T=293.15)
    "Source with high pressure at beginning and lower pressure at end of experiment"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Modelica.Blocks.Sources.Step stepT(
    height=20,
    startTime=10000,
    offset=273.15 + 50)
    "Step temperature increase to test propagation of temperature wave"
    annotation (Placement(transformation(extent={{-100,0},{-80,20}})));
  Modelica.Blocks.Sources.Constant PAtm(k=101325) "Atmospheric pressure"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-90,-50})));
  Fluid.Sources.Boundary_pT sin1(
    redeclare package Medium = Medium,
    use_p_in=true,
    nPorts=1,
    use_T_in=true,
    T=283.15)
    "Sink at with constant pressure, turns into source at the end of experiment"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-50,-10})));
  Annex60.Experimental.Pipe.DoublePipe_PipeDelay
                                       doublePipe(
    diameter=diameter,
    length=length,
    m_flow_nominal=m_flow_nominal,
    H=2,
    redeclare
      Annex60.Experimental.Pipe.BaseClasses.DoublePipeConfig.IsoPlusDoubleStandard.IsoPlusDR150S
      pipeData,
    redeclare package Medium = Annex60.Media.Water)
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
  Annex60.Fluid.Sensors.TemperatureTwoPort senTemSupplyIn(redeclare package
      Medium = Medium, m_flow_nominal=m_flow_nominal)
    annotation (Placement(transformation(extent={{-32,20},{-12,40}})));
  Annex60.Fluid.Sensors.TemperatureTwoPort senTemReturnOut(redeclare package
      Medium = Medium, m_flow_nominal=m_flow_nominal) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-22,-10})));

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal=0.5
    "Nominal mass flow rate, used for regularization near zero flow";
  Annex60.Fluid.Sensors.TemperatureTwoPort senTemSupplyOut(redeclare package
      Medium = Medium, m_flow_nominal=m_flow_nominal)
    annotation (Placement(transformation(extent={{30,20},{50,40}})));
  Annex60.Fluid.Sensors.TemperatureTwoPort senTemReturnIn(redeclare package
      Medium = Medium, m_flow_nominal=m_flow_nominal) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={40,-18})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=293.15)
    annotation (Placement(transformation(extent={{28,60},{48,80}})));
  Annex60.Fluid.Sensors.MassFlowRate senMasFlo(redeclare package Medium =
        Medium) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={70,-18})));
  parameter Modelica.SIunits.Diameter diameter=0.1 "Pipe diameter";
  parameter Modelica.SIunits.Length length=100 "Pipe length";
  parameter Modelica.SIunits.Length thicknessIns=0.01
    "Thickness of pipe insulation";
  // Real lossRatio = -doublePipe.heatPort.Q_flow/(hea.Q_flow-doublePipe.heatPort.Q_flow) "Ratio of the transport heat losses and the delivered energy from the supply side";
  Annex60.Fluid.HeatExchangers.HeaterCooler_T hea(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=10)
    annotation (Placement(transformation(extent={{60,20},{80,40}})));
  Modelica.Blocks.Sources.Constant TSink(k=273.15 + 25) "Atmospheric pressure"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-90,-18})));
  Modelica.Blocks.Sources.Ramp decreaseP(
    duration=1800,
    height=-dp_test,
    startTime=50000,
    offset=101325 + dp_test) "Decreasing pressure difference to zero-mass-flow"
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  Modelica.Blocks.Sources.Ramp reverseDP(
    duration=1800,
    offset=0,
    height=-dp_test,
    startTime=140000) "Reverse the flow after a period of zero-mass-flow"
    annotation (Placement(transformation(extent={{-100,40},{-80,60}})));
  Modelica.Blocks.Math.Add add "Combine input signal of two ramps"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-52,70})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=278.15)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,90})));
equation
  connect(stepT.y, sou1.T_in) annotation (Line(
      points={{-79,10},{-62,10},{-62,34}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(PAtm.y, sin1.p_in) annotation (Line(points={{-79,-50},{-70,-50},{-70,-18},
          {-62,-18}}, color={0,0,127}));
  connect(sou1.ports[1], senTemSupplyIn.port_a)
    annotation (Line(points={{-40,30},{-36,30},{-32,30}}, color={0,127,255}));
  connect(senTemSupplyIn.port_b, doublePipe.port_a1) annotation (Line(points={{-12,
          30},{-6,30},{-6,16},{0,16}}, color={0,127,255}));
  connect(sin1.ports[1], senTemReturnOut.port_b)
    annotation (Line(points={{-40,-10},{-32,-10}}, color={0,127,255}));
  connect(senTemReturnOut.port_a, doublePipe.port_b2) annotation (Line(points={{
          -12,-10},{-6,-10},{-6,4},{0,4}}, color={0,127,255}));
  connect(doublePipe.port_b1, senTemSupplyOut.port_a) annotation (Line(points={{
          20,16},{26,16},{26,30},{30,30}}, color={0,127,255}));
  connect(senTemReturnIn.port_b, doublePipe.port_a2) annotation (Line(points={{30,
          -18},{26,-18},{26,4},{20,4}}, color={0,127,255}));
  connect(senMasFlo.port_b, senTemReturnIn.port_a)
    annotation (Line(points={{60,-18},{50,-18}}, color={0,127,255}));
  connect(senTemSupplyOut.port_b, hea.port_a)
    annotation (Line(points={{50,30},{60,30}}, color={0,127,255}));
  connect(hea.port_b, senMasFlo.port_a) annotation (Line(points={{80,30},{86,30},
          {96,30},{96,-18},{80,-18}}, color={0,127,255}));
  connect(realExpression.y, hea.TSet) annotation (Line(points={{49,70},{52,70},
          {52,68},{58,68},{58,36}}, color={0,0,127}));
  connect(TSink.y, sin1.T_in) annotation (Line(points={{-79,-18},{-74,-18},{-74,
          -14},{-62,-14}}, color={0,0,127}));
  connect(decreaseP.y,add. u1) annotation (Line(
      points={{-79,90},{-46,90},{-46,82}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(reverseDP.y,add. u2) annotation (Line(
      points={{-79,50},{-72,50},{-72,82},{-58,82}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(add.y, sou1.p_in) annotation (Line(points={{-52,59},{-52,59},{-52,52},
          {-52,42},{-62,42},{-62,38}}, color={0,0,127}));
  connect(fixedTemperature.port, doublePipe.heatPort)
    annotation (Line(points={{0,80},{0,50},{10,50},{10,20}}, color={191,0,0}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})), experiment(StopTime=200000),
__Dymola_Commands(file=
          "Resources/Scripts/Dymola/Experimental/Pipe/Examples/DoublePipe/DoublePipe.mos"
        "Simulate and plot"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-160,-180},{
            160,140}})),
    __Dymola_experimentSetupOutput,
    Documentation(info="<html>
<p>This example is intended to test the behaviour of a double pipe. </p>
<p>Water of a certain temperature is let into the system at the supply inlet. At the end of the supply pipe, an ideal heat exchanger cools the water down to a fixed temperature, after which the fluid is returned to the opposite direction via the return pipe. </p>
</html>", revisions="<html>
<ul>
<li>February 15, 2016 by Bram van der Heijde:<br>Updated docstring and description, simulate and plot commit added, added revision history. </li>
<li>November 2015, by Bram van der Heijde:<br>First implementation.</li>
</ul>
</html>"));
end DoublePipe;

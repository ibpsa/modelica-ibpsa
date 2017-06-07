within IBPSA.Experimental.Pipe.Examples.DoublePipe;
model DoublePipeNetwork
  "Simple test of double pipe component in network setting"
  import IBPSA;
  extends Modelica.Icons.Example;

  package Medium = IBPSA.Media.Water;
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
  IBPSA.Experimental.Pipe.DoublePipe_PipeDelay
                                       doublePipe(
    diameter=diameter,
    length=length,
    m_flow_nominal=m_flow_nominal,
    H=2,
    redeclare
      IBPSA.Experimental.Pipe.BaseClasses.DoublePipeConfig.IsoPlusDoubleStandard.IsoPlusDR150S
      pipeData,
    redeclare package Medium = IBPSA.Media.Water)
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
  IBPSA.Fluid.Sensors.TemperatureTwoPort senTemSupplyIn(redeclare package
      Medium = Medium, m_flow_nominal=m_flow_nominal)
    annotation (Placement(transformation(extent={{-32,20},{-12,40}})));
  IBPSA.Fluid.Sensors.TemperatureTwoPort senTemReturnOut(redeclare package
      Medium = Medium, m_flow_nominal=m_flow_nominal) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-22,-10})));

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal=0.5
    "Nominal mass flow rate, used for regularization near zero flow";
  IBPSA.Fluid.Sensors.TemperatureTwoPort senTemSupplyOut(redeclare package
      Medium = Medium, m_flow_nominal=m_flow_nominal)
    annotation (Placement(transformation(extent={{138,22},{158,42}})));
  IBPSA.Fluid.Sensors.TemperatureTwoPort senTemReturnIn(redeclare package
      Medium = Medium, m_flow_nominal=m_flow_nominal) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={148,-16})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=293.15)
    annotation (Placement(transformation(extent={{136,62},{156,82}})));
  IBPSA.Fluid.Sensors.MassFlowRate senMasFlo(redeclare package Medium =
        Medium) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={178,-16})));
  parameter Modelica.SIunits.Diameter diameter=0.1 "Pipe diameter";
  parameter Modelica.SIunits.Length length=100 "Pipe length";
  parameter Modelica.SIunits.Length thicknessIns=0.01
    "Thickness of pipe insulation";
  // Real lossRatio = -doublePipe.heatPort.Q_flow/(hea.Q_flow-doublePipe.heatPort.Q_flow) "Ratio of the transport heat losses and the delivered energy from the supply side";
  IBPSA.Fluid.HeatExchangers.HeaterCooler_T hea(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=10)
    annotation (Placement(transformation(extent={{168,22},{188,42}})));
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
  IBPSA.Experimental.Pipe.DoublePipe_PipeDelay
                                       doublePipe1(
    diameter=diameter,
    length=length,
    m_flow_nominal=m_flow_nominal,
    H=2,
    redeclare
      IBPSA.Experimental.Pipe.BaseClasses.DoublePipeConfig.IsoPlusDoubleStandard.IsoPlusDR150S
      pipeData,
    redeclare package Medium = IBPSA.Media.Water)
    annotation (Placement(transformation(extent={{32,0},{52,20}})));
  IBPSA.Experimental.Pipe.DoublePipe_PipeDelay
                                       doublePipe2(
    diameter=diameter,
    length=length,
    m_flow_nominal=m_flow_nominal,
    H=2,
    redeclare
      IBPSA.Experimental.Pipe.BaseClasses.DoublePipeConfig.IsoPlusDoubleStandard.IsoPlusDR150S
      pipeData,
    redeclare package Medium = IBPSA.Media.Water)
    annotation (Placement(transformation(extent={{58,0},{78,20}})));
  IBPSA.Experimental.Pipe.DoublePipe_PipeDelay
                                       doublePipe3(
    diameter=diameter,
    length=length,
    m_flow_nominal=m_flow_nominal,
    H=2,
    redeclare
      IBPSA.Experimental.Pipe.BaseClasses.DoublePipeConfig.IsoPlusDoubleStandard.IsoPlusDR150S
      pipeData,
    redeclare package Medium = IBPSA.Media.Water)
    annotation (Placement(transformation(extent={{88,0},{108,20}})));
  IBPSA.Fluid.Sensors.TemperatureTwoPort senTemSupplyOut1(
                                                         redeclare package
      Medium = Medium, m_flow_nominal=m_flow_nominal)
    annotation (Placement(transformation(extent={{138,134},{158,154}})));
  IBPSA.Fluid.Sensors.TemperatureTwoPort senTemReturnIn1(
                                                        redeclare package
      Medium = Medium, m_flow_nominal=m_flow_nominal) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={148,96})));
  Modelica.Blocks.Sources.RealExpression realExpression1(
                                                        y=293.15)
    annotation (Placement(transformation(extent={{136,174},{156,194}})));
  IBPSA.Fluid.Sensors.MassFlowRate senMasFlo1(
                                             redeclare package Medium =
        Medium) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={178,96})));
  IBPSA.Fluid.HeatExchangers.HeaterCooler_T hea1(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=10)
    annotation (Placement(transformation(extent={{168,134},{188,154}})));
  IBPSA.Experimental.Pipe.DoublePipe_PipeDelay
                                       doublePipe4(
    diameter=diameter,
    length=length,
    m_flow_nominal=m_flow_nominal,
    H=2,
    redeclare
      IBPSA.Experimental.Pipe.BaseClasses.DoublePipeConfig.IsoPlusDoubleStandard.IsoPlusDR150S
      pipeData,
    redeclare package Medium = IBPSA.Media.Water)
    annotation (Placement(transformation(extent={{72,98},{92,118}})));
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
  connect(senMasFlo.port_b, senTemReturnIn.port_a)
    annotation (Line(points={{168,-16},{158,-16}},
                                                 color={0,127,255}));
  connect(senTemSupplyOut.port_b, hea.port_a)
    annotation (Line(points={{158,32},{168,32}},
                                               color={0,127,255}));
  connect(hea.port_b, senMasFlo.port_a) annotation (Line(points={{188,32},{194,
          32},{204,32},{204,-16},{188,-16}},
                                      color={0,127,255}));
  connect(realExpression.y, hea.TSet) annotation (Line(points={{157,72},{160,72},
          {160,70},{166,70},{166,38}},
                                    color={0,0,127}));
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
  connect(doublePipe.port_b1, doublePipe1.port_a1)
    annotation (Line(points={{20,16},{32,16}}, color={0,127,255}));
  connect(doublePipe.port_a2, doublePipe1.port_b2)
    annotation (Line(points={{20,4},{32,4}}, color={0,127,255}));
  connect(doublePipe1.port_b1, doublePipe2.port_a1)
    annotation (Line(points={{52,16},{55,16},{58,16}}, color={0,127,255}));
  connect(doublePipe1.port_a2, doublePipe2.port_b2)
    annotation (Line(points={{52,4},{55,4},{58,4}}, color={0,127,255}));
  connect(doublePipe2.port_b1, doublePipe3.port_a1)
    annotation (Line(points={{78,16},{84,16},{88,16}}, color={0,127,255}));
  connect(doublePipe2.port_a2, doublePipe3.port_b2)
    annotation (Line(points={{78,4},{84,4},{88,4}}, color={0,127,255}));
  connect(doublePipe3.port_b1, senTemSupplyOut.port_a) annotation (Line(points=
          {{108,16},{122,16},{122,32},{138,32}}, color={0,127,255}));
  connect(doublePipe3.port_a2, senTemReturnIn.port_b) annotation (Line(points={
          {108,4},{122,4},{122,-16},{138,-16}}, color={0,127,255}));
  connect(senMasFlo1.port_b, senTemReturnIn1.port_a)
    annotation (Line(points={{168,96},{158,96}}, color={0,127,255}));
  connect(senTemSupplyOut1.port_b, hea1.port_a)
    annotation (Line(points={{158,144},{168,144}}, color={0,127,255}));
  connect(hea1.port_b, senMasFlo1.port_a) annotation (Line(points={{188,144},{
          194,144},{204,144},{204,96},{188,96}}, color={0,127,255}));
  connect(realExpression1.y, hea1.TSet) annotation (Line(points={{157,184},{160,
          184},{160,182},{166,182},{166,150}}, color={0,0,127}));
  connect(doublePipe4.port_b2, doublePipe2.port_b2) annotation (Line(points={{
          72,102},{54,102},{54,4},{58,4}}, color={0,127,255}));
  connect(doublePipe4.port_a1, doublePipe2.port_a1) annotation (Line(points={{
          72,114},{56,114},{56,16},{58,16}}, color={0,127,255}));
  connect(doublePipe4.port_b1, senTemSupplyOut1.port_a) annotation (Line(points
        ={{92,114},{116,114},{116,144},{138,144}}, color={0,127,255}));
  connect(doublePipe4.port_a2, senTemReturnIn1.port_b) annotation (Line(points=
          {{92,102},{116,102},{116,96},{138,96}}, color={0,127,255}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})), experiment(StopTime=200000),
__Dymola_Commands(file=
          "Resources/Scripts/Dymola/Experimental/Pipe/Examples/DoublePipe/DoublePipe.mos"
        "Simulate and plot"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-160,-180},{
            160,140}})),
    __Dymola_experimentSetupOutput,
    Documentation(info="<html>
<p>This example is intended to test the behaviour of a double pipe in case multiple models are sequenced and branches occur. </p>
<p>Water of a certain temperature is let into the system at the supply inlet. At the end of the supply pipe, an ideal heat exchanger cools the water down to a fixed temperature, after which the fluid is returned to the opposite direction via the return pipe. </p>
</html>", revisions="<html>
<ul>
<li>February 15, 2016 by Bram van der Heijde:<br>Updated docstring and description, simulate and plot commit added, added revision history. </li>
<li>November 2015, by Bram van der Heijde:<br>First implementation.</li>
</ul>
</html>"));
end DoublePipeNetwork;

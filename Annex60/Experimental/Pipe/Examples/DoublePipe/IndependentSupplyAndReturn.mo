within Annex60.Experimental.Pipe.Examples.DoublePipe;
model IndependentSupplyAndReturn
  "Example in which supply and return circuit are hydraulically separated"
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
  Annex60.Experimental.Pipe.DoublePipe doublePipe(
    redeclare package Medium = Medium,
    length=100,
    H=2,
    redeclare
      Annex60.Experimental.Pipe.BaseClasses.DoublePipeConfig.IsoPlusDoubleStandard.IsoPlusDR150S
      pipeData,
    m_flow_nominal=m_flow_nominal)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.Constant const3(k=5) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,90})));
  Modelica.Blocks.Sources.Constant PAtm(k=101325) "Atmospheric pressure"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={110,10})));
  Modelica.Blocks.Sources.Constant TSupply(k=273.15 + 45)
    "Atmospheric pressure" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={110,50})));
  Modelica.Blocks.Sources.Constant TReturn(k=273.15 + 25)
    "Atmospheric pressure" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,-50})));
  Modelica.Blocks.Math.Gain gain(k=dp_test)
    annotation (Placement(transformation(extent={{-156,16},{-136,36}})));
  Modelica.Blocks.Math.Add add
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,38})));
  Modelica.Blocks.Math.Add add1(k1=-1)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,-22})));

  Annex60.Fluid.Sensors.TemperatureTwoPort senTemSupplyIn(redeclare package
      Medium = Medium, m_flow_nominal=m_flow_nominal)
    annotation (Placement(transformation(extent={{-50,20},{-30,40}})));
  Annex60.Fluid.Sensors.TemperatureTwoPort senTemReturnOut(redeclare package
      Medium = Medium, m_flow_nominal=m_flow_nominal) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-40,-30})));
  Annex60.Fluid.Sensors.TemperatureTwoPort senTemSupplyOut(redeclare package
      Medium = Medium, m_flow_nominal=m_flow_nominal)
    annotation (Placement(transformation(extent={{30,20},{50,40}})));
  Annex60.Fluid.Sensors.TemperatureTwoPort senTemReturnIn(redeclare package
      Medium = Medium, m_flow_nominal=m_flow_nominal) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={40,-30})));
  Modelica.Blocks.Sources.CombiTimeTable combiTimeTable(smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments, table=[0,
        1; 3000,1; 5000,0; 10000,0; 12000,-1; 17000,-1; 19000,0; 30000,0;
        30010,-0.1; 50000,-0.1; 50010,0; 80000,0; 82000,-1; 100000,-1; 102000,
        0; 150000,0; 152000,1; 160000,1; 162000,0; 163500,0; 165500,1; 200000,
        1])
    annotation (Placement(transformation(extent={{-188,16},{-168,36}})));
equation
  connect(doublePipe.T_amb, const3.y)
    annotation (Line(points={{0,10},{0,10},{0,79}}, color={0,0,127}));
  connect(PAtm.y, supplySink.p_in) annotation (Line(points={{99,10},{92,10},{92,
          38},{82,38}}, color={0,0,127}));
  connect(PAtm.y, returnSource.p_in) annotation (Line(points={{99,10},{92,10},{
          92,-22},{82,-22}},
                          color={0,0,127}));
  connect(TSupply.y, supplySink.T_in) annotation (Line(points={{99,50},{96,50},
          {96,34},{82,34}}, color={0,0,127}));
  connect(TReturn.y, returnSink.T_in) annotation (Line(points={{-99,-50},{-100,
          -50},{-90,-50},{-90,-26},{-82,-26}},
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
  connect(returnSink.ports[1], senTemReturnOut.port_b) annotation (Line(points=
          {{-60,-30},{-55,-30},{-50,-30}}, color={0,127,255}));
  connect(senTemReturnOut.port_a, doublePipe.port_b2) annotation (Line(points={
          {-30,-30},{-20,-30},{-20,-6},{-10,-6}}, color={0,127,255}));
  connect(supplySource.ports[1], senTemSupplyIn.port_a)
    annotation (Line(points={{-60,30},{-50,30},{-50,30}}, color={0,127,255}));
  connect(senTemSupplyIn.port_b, doublePipe.port_a1) annotation (Line(points={{
          -30,30},{-20,30},{-20,6},{-10,6}}, color={0,127,255}));
  connect(doublePipe.port_b1, senTemSupplyOut.port_a) annotation (Line(points={
          {10,6},{20,6},{20,30},{30,30}}, color={0,127,255}));
  connect(senTemSupplyOut.port_b, supplySink.ports[1])
    annotation (Line(points={{50,30},{55,30},{60,30}}, color={0,127,255}));
  connect(doublePipe.port_a2, senTemReturnIn.port_b) annotation (Line(points={{
          10,-6},{20,-6},{20,-30},{30,-30}}, color={0,127,255}));
  connect(senTemReturnIn.port_a, returnSource.ports[1])
    annotation (Line(points={{50,-30},{55,-30},{60,-30}}, color={0,127,255}));
  connect(add1.y, returnSink.p_in)
    annotation (Line(points={{-99,-22},{-82,-22},{-82,-22}}, color={0,0,127}));
  connect(TReturn.y, returnSource.T_in) annotation (Line(points={{-99,-50},{-4,
          -50},{92,-50},{92,-26},{82,-26}}, color={0,0,127}));
  connect(TSupply.y, supplySource.T_in) annotation (Line(points={{99,50},{2,50},
          {-94,50},{-94,34},{-82,34}}, color={0,0,127}));
  connect(gain.u, combiTimeTable.y[1])
    annotation (Line(points={{-158,26},{-167,26}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-200,
            -100},{140,100}})),
    Icon(coordinateSystem(extent={{-200,-100},{140,100}})),
    experiment(StopTime=200000),
    __Dymola_experimentSetupOutput,
    __Dymola_Commands(file="Experimental/Pipe/Simulate and plot.mos"
        "Simulate and plot"));
end IndependentSupplyAndReturn;

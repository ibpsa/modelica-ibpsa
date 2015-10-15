within Annex60.Experimental.Pipe.Examples.PipeAdiabatic;
model ReverseFlow
  extends Modelica.Icons.Example;
  parameter Modelica.SIunits.Pressure dp_test=200
    "Differential pressure for the test used in ramps";

  package Medium = Annex60.Media.Water;

  PipeAdiabaticPlugFlow pipeAdiabaticPlugFlow(
    m_flow_nominal=m_flow_nominal,
    redeclare package Medium = Medium,
    diameter=0.1,
    length=100)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Fluid.Sources.Boundary_pT sin1(
    redeclare package Medium = Medium,
    nPorts=1,
    use_p_in=true,
    use_T_in=true,
    T=283.15)
    "Sink at with constant pressure, turns into source at the end of experiment"
    annotation (Placement(transformation(extent={{80,-10},{60,10}})));
  Fluid.Sources.Boundary_pT sou1(
    redeclare package Medium = Medium,
    nPorts=1,
    use_p_in=true,
    T=283.15)
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
  Fluid.Sensors.TemperatureTwoPort senTemIn(m_flow_nominal=m_flow_nominal,
      redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Fluid.Sensors.TemperatureTwoPort senTemOut(m_flow_nominal=m_flow_nominal,
      redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal=0.5
    "Nominal mass flow rate, used for regularization near zero flow";
  Modelica.Blocks.Sources.Constant reverseP(k=-dp_test) "Atmospheric pressure"
    annotation (Placement(transformation(extent={{-100,40},{-80,60}})));
equation
  connect(stepT.y, sin1.T_in)
    annotation (Line(points={{81,82},{96,82},{96,4},{82,4}}, color={0,0,127}));
  connect(PAtm.y, sin1.p_in) annotation (Line(points={{81,50},{86,50},{90,50},{90,
          8},{82,8}}, color={0,0,127}));
  connect(pipeAdiabaticPlugFlow.port_b, senTemOut.port_a)
    annotation (Line(points={{10,0},{20,0}}, color={0,127,255}));
  connect(reverseP.y, sou1.p_in) annotation (Line(points={{-79,50},{-56,50},{
          -56,26},{-82,26},{-82,8}}, color={0,0,127}));
  connect(sou1.ports[1], senTemIn.port_a)
    annotation (Line(points={{-60,0},{-50,0},{-40,0}}, color={0,127,255}));
  connect(senTemIn.port_b, pipeAdiabaticPlugFlow.port_a)
    annotation (Line(points={{-20,0},{-15,0},{-10,0}}, color={0,127,255}));
  connect(senTemOut.port_b, sin1.ports[1])
    annotation (Line(points={{40,0},{60,0}}, color={0,127,255}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),
    experiment(StopTime=20000, __Dymola_NumberOfIntervals=5000),
    __Dymola_experimentSetupOutput);
end ReverseFlow;

within Annex60.Experimental.Pipe.Examples.Vector;
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
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature
                                   const3(T=293.15)
    annotation (Placement(transformation(extent={{-52,56},{-32,76}})));
  PipeHeatLossMod           pipeHeatLoss_PipeDelayMod_voctorized(
    redeclare package Medium = Medium,
    diameter=0.1,
    length=100,
    m_flow_nominal=2,
    thicknessIns=0.1,
    nPorts=1)
    annotation (Placement(transformation(extent={{-22,-10},{-2,10}})));
equation
  connect(stepT.y, sin1.T_in)
    annotation (Line(points={{81,82},{96,82},{96,4},{82,4}}, color={0,0,127}));
  connect(PAtm.y, sin1.p_in) annotation (Line(points={{81,50},{86,50},{90,50},{90,
          8},{82,8}}, color={0,0,127}));
  connect(reverseP.y, sou1.p_in) annotation (Line(points={{-79,50},{-56,50},{
          -56,26},{-82,26},{-82,8}}, color={0,0,127}));
  connect(sou1.ports[1], pipeHeatLoss_PipeDelayMod_voctorized.port_a)
    annotation (Line(points={{-60,0},{-28,0},{-22,0}}, color={0,127,255}));
  connect(const3.port, pipeHeatLoss_PipeDelayMod_voctorized.heatPort)
    annotation (Line(points={{-32,66},{-12,66},{-12,10}}, color={191,0,0}));
  connect(pipeHeatLoss_PipeDelayMod_voctorized.ports_b[1], sin1.ports[1])
    annotation (Line(points={{-2,0},{30,0},{60,0}}, color={0,127,255}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),
    experiment(StopTime=20000, __Dymola_NumberOfIntervals=5000),
    __Dymola_experimentSetupOutput,
    Documentation(info="<html>
<p>Test to check behaviour of the <code><span style=\"font-family: Courier New,courier;\">PipeAdiabaticPlugFlow</span></code> in reverse flow. The flow propagates from the outlet to the inlet and a temperature step is applied. </p>
</html>", revisions="<html>
<ul>
<li>February 16, 2016 by Bram van der Heijde:<br>Update description and revision history.</li>
<li><span style=\"font-family: MS Shell Dlg 2;\">June 23, 2015 by Marcus Fuchs:<br>First implementation. </span></li>
</ul>
</html>"));
end Vector_test_21;

within Annex60.Experimental.Pipe.Examples.Comparisons;
model MSLNumEquations
  "Checking number of equations with MSL implementation"

  extends Modelica.Icons.Example;

  package Medium = Annex60.Media.Water;
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal=0.9
    "Nominal mass flow rate";
  parameter Types.ThermalResistanceLength R=1/(lambdaIns*2*Modelica.Constants.pi
      /Modelica.Math.log((diameter/2 + thicknessIns)/(diameter/2)));
  parameter Modelica.SIunits.Length thicknessIns=0.05;
  parameter Modelica.SIunits.ThermalConductivity lambdaIns=0.03;

  parameter Modelica.SIunits.Pressure dp_test=200
    "Differential pressure for the test used in ramps";

  Modelica.Blocks.Sources.Constant PAtm(k=101325) "Atmospheric pressure"
    annotation (Placement(transformation(extent={{126,66},{146,86}})));
  Fluid.Sources.Boundary_pT source(
    redeclare package Medium = Medium,
    use_p_in=true,
    use_T_in=true,
    T=293.15,
    nPorts=1) "Source with high pressure during experiment"
    annotation (Placement(transformation(extent={{-88,18},{-68,38}})));
  Fluid.Sources.Boundary_pT sink(
    redeclare package Medium = Medium,
    use_p_in=true,
    T=283.15,
    nPorts=1) "Sink at with constant pressure"
    annotation (Placement(transformation(extent={{140,18},{120,38}})));
  Modelica.Blocks.Sources.Constant constTemp(k=273.15 + 60)
    "Constant supply temperature signal"
    annotation (Placement(transformation(extent={{-118,0},{-98,20}})));
  Modelica.Blocks.Sources.Constant constDP(k=dp_test)
    "Add pressure difference between source and sink"
    annotation (Placement(transformation(extent={{-156,30},{-136,50}})));
  Modelica.Blocks.Math.Add add "Combine input signal of two ramps"
    annotation (Placement(transformation(extent={{-118,50},{-98,70}})));
  inner Modelica.Fluid.System system "System for MSL pipe model"
    annotation (Placement(transformation(extent={{-44,74},{-24,94}})));
  parameter Integer nNodes=4 "Number of discrete flow volumes";
  Modelica.Fluid.Pipes.DynamicPipe pip(
    nParallel=1,
    redeclare package Medium = Medium,
    use_HeatTransfer=true,
    redeclare model HeatTransfer =
        Modelica.Fluid.Pipes.BaseClasses.HeatTransfer.IdealFlowHeatTransfer,
    nNodes=nNodes,
    redeclare model FlowModel =
        Modelica.Fluid.Pipes.BaseClasses.FlowModels.NominalTurbulentPipeFlow (
          dp_nominal=10*pip.length, m_flow_nominal=0.3),
    length=length,
    diameter=diameter) annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={30,10})));
  Modelica.Thermal.HeatTransfer.Components.ThermalCollector col(m=nNodes)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={30,30})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor res(R=R/length)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={30,70})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=283.15)
    annotation (Placement(transformation(extent={{-20,80},{0,100}})));
  parameter Modelica.SIunits.Length length=100 "Length";
  parameter Modelica.SIunits.Diameter diameter=0.05 "Diameter of circular pipe";
equation
  connect(PAtm.y, sink.p_in) annotation (Line(points={{147,76},{154,76},{154,36},
          {142,36}}, color={0,0,127}));
  connect(constTemp.y, source.T_in) annotation (Line(
      points={{-97,10},{-90,10},{-90,32}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(constDP.y, add.u2) annotation (Line(
      points={{-135,40},{-128,40},{-128,54},{-120,54}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(add.y, source.p_in) annotation (Line(
      points={{-97,60},{-94,60},{-94,36},{-90,36}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(PAtm.y, add.u1) annotation (Line(points={{147,76},{154,76},{154,100},{
          -128,100},{-128,66},{-120,66}}, color={0,0,127}));
  connect(col.port_a, pip.heatPorts)
    annotation (Line(points={{30,20},{30,14.4},{30.1,14.4}}, color={191,0,0}));
  connect(res.port_a, col.port_b)
    annotation (Line(points={{30,60},{30,40}}, color={191,0,0}));
  connect(fixedTemperature.port, res.port_b)
    annotation (Line(points={{0,90},{30,90},{30,80}}, color={191,0,0}));
  connect(source.ports[1], pip.port_a) annotation (Line(points={{-68,28},{-24,28},
          {-24,10},{20,10}}, color={0,127,255}));
  connect(pip.port_b, sink.ports[1]) annotation (Line(points={{40,10},{80,10},{80,
          28},{120,28}}, color={0,127,255}));
  annotation (
    Documentation(info="<html>
<p>This use case aims at demonstrating most basic functionalities of the pipe
model. The pressure difference between <code>source</code> and <code>sink</code> is kept constant, as
is the supply temperature at <code>source</code>.</p>
<p>The main focus of this use case is that the model checks <code>True</code> in pedantic mode
and simulates without warnings or errors.</p>
<h4 id=\"typical-use-and-important-parameters\">Typical use and important parameters</h4>
<p>The pressure difference between <code>source</code> and <code>sink</code> can be adjusted via the
<code>dp_test</code> variable.</p>
<h4 id=\"implementation\">Implementation</h4>
<p>In order for the MSL pipe model to check <code>True</code> in pedantic mode and simulate
without warnings, the following modifications have been added:</p>
<ul>
<li><code>energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial</code> to fix the initial
temperature values</li>
<li><code>flowModel(m_flow_small = 1e-4)</code> and <code>T_start=293.15</code> to avoid Dymola errors
regarding circular references for the start temperature and <code>m_flow_small</code> via
the <code>system</code> component</li>
</ul>
</html>", revisions="<html>
<ul>
<li>May 18, 2016 by Marcus Fuchs: <br>
First implementation</li>
</ul>
</html>"),
    Diagram(coordinateSystem(extent={{-180,-120},{180,120}},
          preserveAspectRatio=false)),
    Icon(coordinateSystem(extent={{-180,-120},{180,120}})),
    experiment(StopTime=2000, Interval=1),
    __Dymola_experimentSetupOutput);
end MSLNumEquations;

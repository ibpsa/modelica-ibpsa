within IBPSA.Experimental.Pipe.Examples.UseCases;
model AachenGeneric_small_vec
  "Model automatically generated with uesmodels at 2016-12-12 12:20:05.947837"

  parameter Modelica.SIunits.Temperature T_amb = 283.15
    "Ambient temperature around pipes";

  package Medium = IBPSA.Media.Water(T_default=273.15+70);

  Components.SupplySource supplysupply(
    redeclare package Medium = Medium,
    p_supply=1000000)
         annotation(Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={493.7179687603422,553.1762970021425})));

   Components.DemandSink stationA1465(
    redeclare package Medium = Medium,
    m_flow_nominal=0.11950286806883365)
      annotation(Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=0,
      origin={611.1243642944979,403.76432359947466})));

   Components.DemandSink stationA3609(
    redeclare package Medium = Medium,
    m_flow_nominal=0.11950286806883365)
      annotation(Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=0,
      origin={633.6055705813698,272.3579181095751})));

  IBPSA.Fluid.PlugFlowPipes.PlugFlowPipe pipe65136519(
    redeclare package Medium = Medium,
    length=6.808999925417844,
    diameter=0.125,
    m_flow_nominal=1,
    thicknessIns=0.05,
    nPorts=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=352.1363874766592,
        origin={522.1920924580121,549.2436157829097})));

  IBPSA.Fluid.PlugFlowPipes.PlugFlowPipe pipe65136541(
    redeclare package Medium = Medium,
    length=12.049656021478087,
    diameter=0.1,
    m_flow_nominal=1,
    thicknessIns=0.05,
    nPorts=1) annotation (Placement(transformation(
        extent={{9.19107,-9.93318},{-9.19107,9.93318}},
        rotation=82.13826471784333,
        origin={523.097,367.746})));

  IBPSA.Fluid.PlugFlowPipes.PlugFlowPipe pipe65136520(
    redeclare package Medium = Medium,
    length=9.387039205049568,
    diameter=0.04,
    m_flow_nominal=1,
    thicknessIns=0.05,
    nPorts=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=172.13638747665874,
        origin={571.8693021110371,409.1860056658961})));

  IBPSA.Fluid.PlugFlowPipes.PlugFlowPipe pipe64146415(
    redeclare package Medium = Medium,
    length=15.627494060500709,
    diameter=0.1,
    m_flow_nominal=1,
    thicknessIns=0.05,
    nPorts=2) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=262.1363874766586,
        origin={541.64,477.959})));

  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=283.15)
    annotation (Placement(transformation(extent={{356,514},{376,534}})));
equation
  // Connections between supplies, pipes, and stations
  connect(supplysupply.port_b, pipe65136519.port_a)
    annotation(Line(points={{503.718,553.176},{512.286,550.612}},                                         color={0,127,255}));

  connect(pipe65136519.ports_b[1], pipe64146415.port_a) annotation (Line(points={{532.098,
          547.875},{543.008,547.875},{543.008,487.865}},          color={0,127,255}));
  connect(pipe64146415.ports_b[1], pipe65136520.port_a) annotation (Line(points={{538.291,
          468.327},{581.775,468.327},{581.775,407.818}},          color={0,127,255}));
  connect(pipe65136541.port_a, pipe64146415.ports_b[2]) annotation (Line(points={{524.354,
          376.851},{524.354,467.779},{542.253,467.779}},          color={0,127,255}));
  connect(pipe65136520.ports_b[1], stationA1465.port_a) annotation (Line(points={{561.963,
          410.554},{556,410.554},{556,372},{598,372},{598,403.764},{601.124,
          403.764}}, color={0,127,255}));
  connect(pipe65136541.ports_b[1], stationA3609.port_a) annotation (Line(points={{521.84,
          358.641},{572.985,358.641},{572.985,272.358},{623.606,272.358}},
        color={0,127,255}));
  connect(fixedTemperature.port, pipe65136519.heatPort) annotation (Line(points={{376,524},
          {426,524},{426,590},{523.56,590},{523.56,559.15}},           color={191,
          0,0}));
  connect(pipe64146415.heatPort, fixedTemperature.port) annotation (Line(points={{551.546,
          476.591},{551.546,524},{376,524}},          color={191,0,0}));
  connect(pipe65136520.heatPort, fixedTemperature.port) annotation (Line(points={{570.501,
          399.28},{474.25,399.28},{474.25,524},{376,524}},          color={191,0,
          0}));
  connect(pipe65136541.heatPort, fixedTemperature.port) annotation (Line(points={{513.257,
          369.105},{513.257,443.582},{376,443.582},{376,524}},          color={191,
          0,0}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{0,0},{
            1000,1245.37}})),
              experiment(
      StopTime=604800,
      Interval=3600,
      Tolerance=1e-006,
      __Dymola_Algorithm="Dassl"),
    Documentation(info="<html>
<p>This model represents a generic district heating network auto-generated with the Python packages <em>uesgraphs</em> and <em>uesmodels</em>. </p>
<p>The building positions are taken from OpenStreetMap data for a district in the city of Aachen (The data can be queried from <a href=\"http://www.openstreetmap.org/#map=17/50.78237/6.05746\">http://www.openstreetmap.org/#map=17/50.78237/6.05746</a>). The package <em>uesgraphs</em> imports this data into a Python graph representation including the street network. The heating network is added with a simple algorithm following the street layout to connect 25 buildings to a given supply node. The pipe diameters are designed so that they approach a specific pressure drop of 200 Pa/m for the given maximum heat load of each building for a dT of 20 K between a network supply temperature of 60 degC and a return temperature of 40 degC.</p>
<p>The heat demands of the buildings are taken from a building simulation based on an archetype building model of a residential building. The building model was created using TEASER (<a href=\"https://github.com/RWTH-EBC/TEASER\">https://github.com/RWTH-EBC/TEASER</a>) and AixLib (<a href=\"https://github.com/RWTH-EBC/AixLib\">https://github.com/RWTH-EBC/AixLib</a>). The buildings&#39; peak load is 48.379 kW. The same heat demand is used for each of the 25 buildings.</p>
<p>The Modelica model is auto-generated from the <em>uesgraphs</em> representation of the network using the Python package <em>uesmodels</em>.</p>
</html>", revisions="<html>
<ul>
<li>December 12, 2016 by Marcus Fuchs:<br>First implementation. </li>
</ul>
</html>"),
    __Dymola_experimentSetupOutput);
end AachenGeneric_small_vec;

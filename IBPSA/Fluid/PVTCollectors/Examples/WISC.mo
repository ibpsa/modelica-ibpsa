within IBPSA.Fluid.PVTCollectors.Examples;
model WISC "Test model for WISC (Wind and Infrared Sensitive Collector) - uncovered PVT collectors"
  extends .Modelica.Icons.Example;
  replaceable package Medium = .Modelica.Media.Incompressible.Examples.Glycol47
    "Medium in the system";

  .IBPSA.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
    .Modelica.Utilities.Files.loadResource("modelica://IBPSA/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos"))
    "Weather data input file"
    annotation (Placement(transformation(extent={{-28,60},{-8,80}})));
  .IBPSA.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    p(displayUnit="bar") = 100000,
    nPorts=1) "Outlet for water flow"
    annotation (Placement(transformation(extent={{82,-10},{62,10}})));
  .IBPSA.Fluid.Sensors.TemperatureTwoPort TOut(
    redeclare package Medium = Medium,
    T_start(displayUnit="K"),
    m_flow_nominal=pvtCol.m_flow_nominal) "Temperature sensor"
    annotation (Placement(transformation(extent={{32,-10},{52,10}})));
  .IBPSA.Fluid.Sensors.TemperatureTwoPort TIn(redeclare package Medium =
    Medium, m_flow_nominal=pvtCol.m_flow_nominal) "Temperature sensor"
    annotation (Placement(transformation(extent={{-28,-10},{-8,10}})));
  .IBPSA.Fluid.Sources.Boundary_pT sou(
    redeclare package Medium = Medium,
    T=273.15 + 10,
    nPorts=1,
    use_p_in=true) "Inlet for water flow"
    annotation (Placement(
      transformation(
      extent={{10,-10},{-10,10}},
      rotation=180,
      origin={-48,0})));
  .Modelica.Blocks.Sources.Sine sine(
    f=3/86400,
    amplitude=-pvtCol.dp_nominal,
    offset=1E5) "Pressure source"
    annotation (Placement(transformation(extent={{-88,-18},{-68,2}})));
  .IBPSA.Fluid.PVTCollectors.PVTCollector pvtCol(
    redeclare package Medium = Medium,
    energyDynamics=.Modelica.Fluid.Types.Dynamics.FixedInitial,
    show_T=true,
    azi=0,
    til=0.78539816339745,
    rho=0.2,
    nColType=.IBPSA.Fluid.SolarCollectors.Types.NumberSelection.Number,
    nPanels=5,
    nSeg=9,
    sysConfig=.IBPSA.Fluid.SolarCollectors.Types.SystemConfiguration.Series,
    per=datPVTCol)
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  parameter .IBPSA.Fluid.PVTCollectors.Data.Uncovered.UI_Validation datPVTCol
    annotation (Placement(transformation(extent={{64,64},{84,84}})));
equation
  connect(sou.ports[1], TIn.port_a) annotation (Line(
      points={{-38,0},{-28,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TOut.port_b, sin.ports[1])
    annotation (Line(points={{52,0},{62,0}},              color={0,127,255}));
  connect(sine.y, sou.p_in) annotation (Line(points={{-67,-8},{-60,-8}},
                           color={0,0,127}));
  connect(pvtCol.weaBus, weaDat.weaBus) annotation (Line(
      points={{0,8},{-4,8},{-4,70},{-8,70}},
      color={255,204,51},
      thickness=0.5));
  connect(TIn.port_b, pvtCol.port_a)
    annotation (Line(points={{-8,0},{0,0}}, color={0,127,255}));
  connect(pvtCol.port_b, TOut.port_a)
    annotation (Line(points={{20,0},{32,0}}, color={0,127,255}));
  annotation (
  Documentation(info="<html>
<p>
This example demonstrates the implementation of the 
<a href=\"modelica://IBPSA.Fluid.PVTCollectors.PVTCollector\">
IBPSA.Fluid.PVTCollectors.PVTQuasiDynamicCollector</a> 
for a variable fluid flow rate and weather data from San Francisco, CA, USA.
</p>
<p>
The collector modeled here is an <b>uncovered PVT collector</b>, also referred to as a 
<b>WISC</b> (Wind and Infrared Sensitive Collector). These collectors are sensitive to 
ambient wind and infrared radiation due to the absence of a glazing layer. 
They can be either <i>unglazed insulated (UI)</i> or <i>unglazed non-insulated (UN)</i>, 
depending on the thermal insulation applied to the back side of the collector.
</p>
<p>
This test model uses the <a href=\"modelica://IBPSA.Fluid.PVTCollectors.Data.Uncovered.UI_Validation\">
IBPSA.Fluid.PVTCollectors.Data.Uncovered.UI_Validation</a> record.
However, if you know the brand and model of the PVT collector you plan to simulate or install, 
it is recommended to use the actual datasheet parameters in a custom 
<a href=\"IBPSA.Fluid.PVTCollectors.Data.GenericQuasiDynamic\">
IBPSA.Fluid.PVTCollectors.Data.GenericQuasiDynamic</a> record.
</p>
</html>",
revisions="<html>
<ul>
<li>
July 7, 2025, by Lone Meertens:<br/>
First implementation PVT model.
This is for <a href=\"https://github.com/open-ideas/IDEAS/issues/1436\">1436</a>.
</li>
</ul>
</html>"),
__Dymola_Commands(file="modelica://IBPSA/Resources/Scripts/Dymola/Fluid/PVTCollectors/Examples/WISC.mos"
        "Simulate and plot"),
 experiment(
      StartTime=0,
      StopTime=86400,
      Interval=60,
      Tolerance=1e-06,
      __Dymola_Algorithm="dassl"));
end WISC;

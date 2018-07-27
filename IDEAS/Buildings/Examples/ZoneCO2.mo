within IDEAS.Buildings.Examples;
model ZoneCO2 "Zone with CO2 concentration model"
  extends Modelica.Icons.Example;
  replaceable package Medium = IDEAS.Media.Air(extraPropertiesNames={"CO2"});
  inner BoundaryConditions.SimInfoManager       sim
    "Simulation information manager for climate data"
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));

  IDEAS.Buildings.Components.Examples.BaseClasses.SimpleZone zone(
    redeclare Components.Occupants.Input occNum,
    redeclare package Medium = Medium)
    "Zone model"
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  Modelica.Blocks.Sources.Pulse pulse(
    offset=0,
    period=7200,
    amplitude=5)
              annotation (Placement(transformation(extent={{40,0},{20,20}})));

  IDEAS.Fluid.Sources.Boundary_pT bou(
    nPorts=1,
    redeclare package Medium = Medium)
    "Ideal pressure source"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  IDEAS.Fluid.Sources.MassFlowSource_T boundary(
    redeclare package Medium = Medium,
    use_T_in=true,
    use_Xi_in=true,
    use_C_in=true,
    nPorts=1,
    use_m_flow_in=true) "Ideal flow rate source" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-28,70})));
  Modelica.Blocks.Logical.Hysteresis hys(uLow=750, uHigh=850)
    "Hysteresis controller using CO2 concentration" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={10,40})));
  Modelica.Blocks.Math.BooleanToReal m_flow(              realFalse=0, realTrue=
       0.04)
    "Flow rate when ventilation is enabled" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={10,70})));
protected
  BoundaryConditions.WeatherData.Bus weaDatBus1
                            "Weather data bus connectable to weaBus connector from Buildings Library"
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
equation
  connect(pulse.y, zone.nOcc) annotation (Line(points={{19,10},{0,10},{0,14},{-18,
          14}}, color={0,0,127}));
  connect(bou.ports[1], zone.port_b)
    annotation (Line(points={{-60,50},{-32,50},{-32,20}}, color={0,127,255}));
  connect(sim.weaDatBus, weaDatBus1) annotation (Line(
      points={{-80.1,90},{-70,90}},
      color={255,204,51},
      thickness=0.5));
  connect(boundary.T_in, weaDatBus1.TDryBul)
    annotation (Line(points={{-24,82},{-24,90},{-70,90}}, color={0,0,127}));
  connect(boundary.Xi_in[1], weaDatBus1.X_wEnv)
    annotation (Line(points={{-32,82},{-32,90},{-70,90}}, color={0,0,127}));
  connect(boundary.C_in[1], weaDatBus1.CEnv)
    annotation (Line(points={{-36,82},{-36,90},{-70,90}}, color={0,0,127}));
  connect(boundary.ports[1], zone.port_a)
    annotation (Line(points={{-28,60},{-28,20}}, color={0,127,255}));
  connect(hys.u, zone.ppm)
    annotation (Line(points={{10,28},{10,12},{-19,12}}, color={0,0,127}));
  connect(m_flow.y, boundary.m_flow_in)
    annotation (Line(points={{10,81},{-20,81},{-20,82}}, color={0,0,127}));
  connect(m_flow.u, hys.y)
    annotation (Line(points={{10,58},{10,51}}, color={255,0,255}));
  annotation (experiment(
      StopTime=100000,
      Tolerance=1e-06,
      __Dymola_Algorithm="Lsodar"), Documentation(info="<html>
<p>
This model demonstrates how to use the zone model for
simulating the CO2 generation caused by occupants.
</p>
</html>", revisions="<html>
<ul>
<li>
July 27, 2018 by Filip Jorissen:<br/>
First implementation
See <a href=\"https://github.com/open-ideas/IDEAS/issues/868\">#868</a>.
</li>
</ul>
</html>"),
    __Dymola_Commands(file="Resources/Scripts/Dymola/Buildings/Examples/ZoneCO2.mos"
        "Simulate and plot"));
end ZoneCO2;

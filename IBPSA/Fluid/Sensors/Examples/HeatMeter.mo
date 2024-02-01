within IBPSA.Fluid.Sensors.Examples;
model HeatMeter
  extends Modelica.Icons.Example;
  Sources.MassFlowSource_T sou(
    redeclare package Medium = IBPSA.Media.Water,
    m_flow=10,
    nPorts=1) annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  Sources.Boundary_pT sin(redeclare package Medium = IBPSA.Media.Water, nPorts=
        1) annotation (Placement(transformation(extent={{60,0},{40,20}})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor heatCapacitor(C=15, T(
        start=353.15))
    annotation (Placement(transformation(extent={{-50,60},{-30,80}})));
  MixingVolumes.MixingVolume vol(
    redeclare package Medium = IBPSA.Media.Water,
    m_flow_nominal=10,
    V=0.1,
    nPorts=2) annotation (Placement(transformation(extent={{-20,40},{0,60}})));
  TemperatureTwoPort temp(redeclare package Medium = IBPSA.Media.Water,
      m_flow_nominal=10)
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  IBPSA.Fluid.Sensors.HeatMeter heatMeter(redeclare package Medium =
        IBPSA.Media.Water, m_flow_nominal=10)
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
equation
  connect(sou.ports[1], temp.port_a)
    annotation (Line(points={{-60,10},{-40,10}}, color={0,127,255}));
  connect(temp.port_b, vol.ports[1]) annotation (Line(points={{-20,10},{-12,10},
          {-12,40},{-11,40}}, color={0,127,255}));
  connect(vol.ports[2], heatMeter.port_a) annotation (Line(points={{-9,40},{-8,
          40},{-8,10},{0,10}}, color={0,127,255}));
  connect(heatMeter.port_b, sin.ports[1])
    annotation (Line(points={{20,10},{40,10}}, color={0,127,255}));
  connect(temp.T, heatMeter.T_other) annotation (Line(points={{-30,21},{-30,28},
          {-16,28},{-16,2},{-2,2}}, color={0,0,127}));
  connect(heatCapacitor.port, vol.heatPort)
    annotation (Line(points={{-40,60},{-40,50},{-20,50}}, color={191,0,0}));
  annotation (experiment(StopTime=60, __Dymola_Algorithm="Dassl"));
end HeatMeter;

within IBPSA.Fluid.MixingVolumes.Validation;
model MSLCombustionAir
  "Test of MSL mixture gas with Modelica IBPSA components"
   package Medium = Modelica.Media.IdealGases.MixtureGases.CombustionAir; // Doesn't work, substance 'water' is missing
//   package Medium = Modelica.Media.IdealGases.MixtureGases.FlueGasSixComponents; // Doesn't work
  //package Medium = Modelica.Media.IdealGases.SingleGases.N2; // Works fine

  parameter Modelica.Units.SI.PressureDifference dp_nominal=1e4;
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=10;

  IBPSA.Fluid.FixedResistances.PressureDrop res(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=dp_nominal)
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  IBPSA.Fluid.Sources.MassFlowSource_T boundary(
    redeclare package Medium = Medium,
    m_flow=m_flow_nominal,
    nPorts=1)
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  IBPSA.Fluid.Sources.Boundary_pT bou1(
    redeclare package Medium = Medium,
    nPorts=1)
    annotation (Placement(transformation(extent={{60,-10},{40,10}})));
  IBPSA.Fluid.MixingVolumes.BaseClasses.MixingVolumeHeatPort vol(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    V=1,
    nPorts=2)
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
equation
  connect(res.port_b, bou1.ports[1])
    annotation (Line(points={{20,0},{40,0}}, color={0,127,255}));
  connect(boundary.ports[1], vol.ports[1])
    annotation (Line(points={{-60,0},{-31,0},{-31,20}}, color={0,127,255}));
  connect(vol.ports[2], res.port_a)
    annotation (Line(points={{-29,20},{-29,0},{0,0}},  color={0,127,255}));
  annotation (
      experiment(StopTime=60));
end MSLCombustionAir;

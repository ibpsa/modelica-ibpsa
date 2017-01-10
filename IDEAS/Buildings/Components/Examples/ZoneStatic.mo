within IDEAS.Buildings.Components.Examples;
model ZoneStatic "Zone with constant boundary conditions"
  extends Modelica.Icons.Example;
  package Medium = IDEAS.Media.Air;
  inner BoundaryConditions.SimInfoManager sim(computeConservationOfEnergy=true)
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  IDEAS.Buildings.Components.Zone zone(
    redeclare package Medium = Medium,
    allowFlowReversal=true,
    V=20,
    nSurf=2,
    n50=0.01)
          "First zone"
    annotation (Placement(transformation(extent={{20,0},{40,20}})));
  IDEAS.Buildings.Components.Interfaces.DummyConnection dummyConnection(
    A=15, T=Medium.T_default)
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));
  IDEAS.Buildings.Components.Interfaces.DummyConnection dummyConnection1(
    A=10, T=Medium.T_default,
    inc(k=IDEAS.Types.Tilt.Ceiling))
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));

  IDEAS.Fluid.Sources.MassFlowSource_T sou(
    redeclare package Medium = Medium,
    nPorts=1,
    m_flow=0.1) "Mass flow source" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={30,70})));
  Fluid.Sources.Boundary_pT sin(nPorts=1, redeclare package Medium = Medium)
    "Mass flow sink"
    annotation (Placement(transformation(extent={{0,40},{20,60}})));

equation
  connect(zone.propsBus[1], dummyConnection.zoneBus) annotation (Line(
      points={{20,15},{12,15},{-20,15},{-20,-10.2}},
      color={255,204,51},
      thickness=0.5));
  connect(dummyConnection1.zoneBus, zone.propsBus[2]) annotation (Line(
      points={{-20,29.8},{-20,13},{20,13}},
      color={255,204,51},
      thickness=0.5));
  connect(sou.ports[1], zone.port_a)
    annotation (Line(points={{30,60},{32,60},{32,20}}, color={0,127,255}));
  connect(sin.ports[1], zone.port_b)
    annotation (Line(points={{20,50},{28,50},{28,20}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=10000),
    __Dymola_Commands(file="Resources/Scripts/Dymola/Buildings/Components/Examples/ZoneStatic.mos"
        "Simulate and plot"));
end ZoneStatic;

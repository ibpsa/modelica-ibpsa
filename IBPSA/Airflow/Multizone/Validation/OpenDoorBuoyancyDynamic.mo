within IBPSA.Airflow.Multizone.Validation;
model OpenDoorBuoyancyDynamic
  "Model with one open and buoyancy driven flow only"
  extends Modelica.Icons.Example;

  package Medium = IBPSA.Media.Air;

  IBPSA.Airflow.Multizone.DoorOpen doo(redeclare package Medium = Medium)
    "Door" annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  IBPSA.Fluid.Sources.Boundary_pT bou(redeclare package Medium = Medium, nPorts
      =1) "Pressure boundary"
    annotation (Placement(transformation(extent={{-50,-46},{-30,-26}})));

  IBPSA.Fluid.MixingVolumes.MixingVolume bouB(
    redeclare package Medium = Medium,
    T_start=294.15,
    V=2.5*5*5,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    massDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=0.01,
    nPorts=2) "Boundary condition at side b"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={40,0})));

  Fluid.MixingVolumes.MixingVolume bouA(
    redeclare package Medium = Medium,
    T_start=292.15,
    V=2.5*5*5,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    massDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=0.01,
    nPorts=3) "Boundary condition at side a" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-40,0})));
equation
  connect(doo.port_b1, bouB.ports[1])
    annotation (Line(points={{10,6},{20,6},{20,2},{30,2}}, color={0,127,255}));
  connect(doo.port_a2, bouB.ports[2]) annotation (Line(points={{10,-6},{20,-6},
          {20,-2},{30,-2}},color={0,127,255}));
  connect(doo.port_a1, bouA.ports[1]) annotation (Line(points={{-10,6},{-20,6},
          {-20,0},{-28,0}}, color={0,127,255}));
  connect(doo.port_b2, bouA.ports[2]) annotation (Line(points={{-10,-6},{-20,-6},
          {-20,-2},{-28,-2}}, color={0,127,255}));
  connect(bou.ports[1], bouA.ports[3])
    annotation (Line(points={{-30,-36},{-30,-4}}, color={0,127,255}));
  annotation (
    __Dymola_Commands(file="modelica://IBPSA/Resources/Scripts/Dymola/Airflow/Multizone/Validation/OpenDoorBuoyancyDynamic.mos"
        "Simulate and plot"),
    experiment(
      StopTime=14400,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
    Documentation(info="<html>
<p>
This model validates the door model for the situation where there is only buoyancy-driven air flow.
Initially the volume is at a different temperature than the pressure source, leading to an airflow that eventually decays to zero.
</p>
</html>", revisions="<html>
<ul>
<li>
October 9, 2020 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end OpenDoorBuoyancyDynamic;

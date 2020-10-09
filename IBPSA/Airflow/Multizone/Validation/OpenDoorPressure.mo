within IBPSA.Airflow.Multizone.Validation;
model OpenDoorPressure
  "Model with one open and pressure driven flow only"
  extends Modelica.Icons.Example;

  package Medium = IBPSA.Media.Air "Medium model";

  IBPSA.Airflow.Multizone.DoorOpen doo(redeclare package Medium = Medium)
    "Door" annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  Fluid.Sources.Boundary_pT bouA(
    redeclare package Medium = Medium,
    p(displayUnit="Pa") = 101330,
    nPorts=4) "Boundary condition at side a" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-40,0})));

  Fluid.Sources.Boundary_pT bouB(
    redeclare package Medium = Medium,
    p(displayUnit="Pa") = 101325,
    nPorts=4) "Boundary condition at side b"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=0,
        origin={40,0})));

  DoorDiscretizedOpen dooDis(redeclare package Medium = Medium) "Door"
    annotation (Placement(transformation(extent={{-10,-40},{10,-20}})));
equation
  connect(doo.port_b1, bouB.ports[1])
    annotation (Line(points={{10,6},{20,6},{20,3},{30,3}}, color={0,127,255}));
  connect(doo.port_a2, bouB.ports[2]) annotation (Line(points={{10,-6},{20,-6},
          {20,1},{30,1}},  color={0,127,255}));
  connect(doo.port_a1, bouA.ports[1]) annotation (Line(points={{-10,6},{-20,6},
          {-20,3},{-30,3}}, color={0,127,255}));
  connect(doo.port_b2, bouA.ports[2]) annotation (Line(points={{-10,-6},{-20,-6},
          {-20,1},{-30,1}},                       color={0,127,255}));
  connect(bouA.ports[3], dooDis.port_a1) annotation (Line(points={{-30,-1},{-22,
          -1},{-22,-24},{-10,-24}}, color={0,127,255}));
  connect(bouA.ports[4], dooDis.port_b2) annotation (Line(points={{-30,-3},{-24,
          -3},{-24,-36},{-10,-36}}, color={0,127,255}));
  connect(dooDis.port_b1, bouB.ports[3]) annotation (Line(points={{10,-24},{22,
          -24},{22,-1},{30,-1}}, color={0,127,255}));
  connect(dooDis.port_a2, bouB.ports[4]) annotation (Line(points={{10,-36},{24,
          -36},{24,-3},{30,-3}}, color={0,127,255}));
  annotation (
    __Dymola_Commands(file="modelica://IBPSA/Resources/Scripts/Dymola/Airflow/Multizone/Validation/OpenDoorPressure.mos"
        "Simulate and plot"),
    experiment(
      StopTime=7200,
      Tolerance=1e-06),
    Documentation(info="<html>
<p>
This model validates the door model for the situation where there is only pressure-driven air flow.
</p>
</html>", revisions="<html>
<ul>
<li>
October 9, 2020 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end OpenDoorPressure;

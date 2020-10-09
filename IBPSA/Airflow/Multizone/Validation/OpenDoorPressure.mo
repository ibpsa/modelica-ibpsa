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
    nPorts=2) "Boundary condition at side a" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-40,0})));

  Fluid.Sources.Boundary_pT bouB(
    redeclare package Medium = Medium,
    p(displayUnit="Pa") = 101325,
    nPorts=2) "Boundary condition at side b"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=0,
        origin={40,0})));

equation
  connect(doo.port_b1, bouB.ports[1])
    annotation (Line(points={{10,6},{20,6},{20,2},{30,2}}, color={0,127,255}));
  connect(doo.port_a2, bouB.ports[2]) annotation (Line(points={{10,-6},{20,-6},{
          20,-2},{30,-2}}, color={0,127,255}));
  connect(doo.port_a1, bouA.ports[1]) annotation (Line(points={{-10,6},{-20,6},{
          -20,2},{-30,2}},  color={0,127,255}));
  connect(doo.port_b2, bouA.ports[2]) annotation (Line(points={{-10,-6},{-20,-6},
          {-20,-2},{-30,-2}},                     color={0,127,255}));
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

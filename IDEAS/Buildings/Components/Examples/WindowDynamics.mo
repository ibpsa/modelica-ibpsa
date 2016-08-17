within IDEAS.Buildings.Components.Examples;
model WindowDynamics "Comparison of three window dynamics options"
  package Medium = IDEAS.Media.Air;
  extends Modelica.Icons.Example;
  Fluid.Sources.Boundary_pT bou(          redeclare package Medium = Medium,
      nPorts=1) "Absolute pressure bound"
    annotation (Placement(transformation(extent={{-60,80},{-40,100}})));

  inner BoundaryConditions.SimInfoManager sim
    annotation (Placement(transformation(extent={{-96,76},{-76,96}})));
  Window windowTwo(
    A=1,
    redeclare parameter IDEAS.Buildings.Data.Glazing.Ins2 glazing,
    redeclare IDEAS.Buildings.Data.Frames.Pvc fraType,
    windowDynamicsType=IDEAS.Buildings.Components.Interfaces.WindowDynamicsType.Two,
    inc=IDEAS.Types.Tilt.Wall,
    azi=IDEAS.Types.Azimuth.S)
    "Window model with one state for frame and one for glass"
    annotation (Placement(transformation(extent={{-54,-100},{-44,-80}})));

  OuterWall outerWall(
    azi=0,
    redeclare parameter IDEAS.Buildings.Validation.Data.Constructions.HeavyWall
      constructionType,
    redeclare parameter IDEAS.Buildings.Data.Insulation.Glasswool insulationType,
    AWall=10,
    insulationThickness=0,
    inc=IDEAS.Types.Tilt.Floor) "Outer wall model"
    annotation (Placement(transformation(extent={{-54,20},{-44,40}})));
  Zone zone1(
    redeclare package Medium = Medium,
    allowFlowReversal=true,
    nSurf=4,
    V=20)
         annotation (Placement(transformation(extent={{20,-70},{40,-50}})));
  Window windowNone(
    A=1,
    redeclare parameter IDEAS.Buildings.Data.Glazing.Ins2 glazing,
    redeclare IDEAS.Buildings.Data.Frames.Pvc fraType,
    windowDynamicsType=IDEAS.Buildings.Components.Interfaces.WindowDynamicsType.None,
    inc=IDEAS.Types.Tilt.Wall,
    azi=IDEAS.Types.Azimuth.S) "Window model with no dynamics"
    annotation (Placement(transformation(extent={{-54,-20},{-44,0}})));

  Window windowCombined(
    A=1,
    redeclare parameter IDEAS.Buildings.Data.Glazing.Ins2 glazing,
    redeclare IDEAS.Buildings.Data.Frames.Pvc fraType,
    windowDynamicsType=IDEAS.Buildings.Components.Interfaces.WindowDynamicsType.Combined,
    inc=IDEAS.Types.Tilt.Wall,
    azi=IDEAS.Types.Azimuth.S)
    "Window model with combined state for frame and for glass"
    annotation (Placement(transformation(extent={{-54,-60},{-44,-40}})));

equation
  connect(zone1.propsBus[1], outerWall.propsBus_a) annotation (Line(
      points={{20,-54.5},{20,-54.5},{20,-6},{20,32},{-44,32}},
      color={255,204,51},
      thickness=0.5));
  connect(windowNone.propsBus_a, zone1.propsBus[2]) annotation (Line(
      points={{-44,-8},{-28,-8},{20,-8},{20,-55.5}},
      color={255,204,51},
      thickness=0.5));
  connect(windowCombined.propsBus_a, zone1.propsBus[3]) annotation (Line(
      points={{-44,-48},{-32,-48},{20,-48},{20,-56.5}},
      color={255,204,51},
      thickness=0.5));
  connect(windowTwo.propsBus_a, zone1.propsBus[4]) annotation (Line(
      points={{-44,-88},{20,-88},{20,-57.5}},
      color={255,204,51},
      thickness=0.5));
  connect(zone1.flowPort_In, bou.ports[1])
    annotation (Line(points={{32,-50},{32,90},{-40,90}}, color={0,0,0}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),           __Dymola_Commands(file=
          "Resources/Scripts/Dymola/Buildings/Components/Examples/WindowDynamics.mos"
        "Simulate and plot"),
    Documentation(revisions="<html>
<ul>
<li>
July 18, 2016, by Filip Jorissen:<br/>
Cleaned up implementation.
</li>
<li>
February 10, 2016, by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
This model allows comparing the three options for the window dynamics.
Using two states is the most computationally intensive but
is the safest option to use.
</p>
</html>"));
end WindowDynamics;

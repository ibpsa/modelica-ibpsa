within IDEAS.Buildings.Components.Examples;
model ZoneExample
  "Example model demonstrating how zones may be connected to surfaces"
  package Medium = IDEAS.Media.Air;
  extends Modelica.Icons.Example;
  inner BoundaryConditions.SimInfoManager sim "Data reader"
    annotation (Placement(transformation(extent={{-96,76},{-76,96}})));
  IDEAS.Buildings.Components.Zone zone(
    nSurf=4,
    redeclare package Medium = Medium,
    allowFlowReversal=true,
    V=20) "First zone"
    annotation (Placement(transformation(extent={{20,-20},{40,0}})));
  IDEAS.Buildings.Components.BoundaryWall commonWall(
    redeclare parameter IDEAS.Buildings.Validation.Data.Constructions.HeavyWall
      constructionType,
    redeclare parameter IDEAS.Buildings.Data.Insulation.Rockwool insulationType,
    insulationThickness=0.1,
    AWall=10,
    azi=0,
    inc=1.5707963267949) "Common wall model"
    annotation (Placement(transformation(extent={{-54,-2},{-44,18}})));
  IDEAS.Fluid.Sources.Boundary_pT bou(nPorts=1, redeclare package Medium = Medium)
    "Boundary for setting absolute pressure in the model"
    annotation (Placement(transformation(extent={{-60,80},{-40,100}})));
  IDEAS.Buildings.Components.InternalWall internalWall(
    redeclare parameter IDEAS.Buildings.Validation.Data.Constructions.HeavyWall
      constructionType,
    redeclare parameter IDEAS.Buildings.Data.Insulation.Rockwool insulationType,
    insulationThickness=0.1,
    AWall=10,
    azi=0,
    inc=IDEAS.Types.Tilt.Wall) "Internal wall model" annotation (Placement(
        transformation(
        extent={{-5,-10},{5,10}},
        rotation=90,
        origin={11,-38})));

  IDEAS.Buildings.Components.Window window(
    A=1,
    redeclare parameter IDEAS.Buildings.Data.Glazing.Ins2 glazing,
    redeclare IDEAS.Buildings.Components.Shading.Screen shaType,
    redeclare IDEAS.Buildings.Data.Frames.Pvc fraType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=IDEAS.Types.Azimuth.S) "Window model"
    annotation (Placement(transformation(extent={{-54,-82},{-44,-62}})));
  IDEAS.Buildings.Components.SlabOnGround slabOnGround(
    redeclare parameter IDEAS.Buildings.Validation.Data.Constructions.LightWall
      constructionType,
    redeclare parameter IDEAS.Buildings.Data.Insulation.Pir insulationType,
    insulationThickness=0.1,
    AWall=20,
    PWall=3,
    inc=0,
    azi=0) "Floor model"
    annotation (Placement(transformation(extent={{-54,20},{-44,40}})));
  IDEAS.Buildings.Components.OuterWall outerWall(
    azi=0,
    redeclare parameter IDEAS.Buildings.Validation.Data.Constructions.HeavyWall
      constructionType,
    redeclare parameter IDEAS.Buildings.Data.Insulation.Glasswool insulationType,
    AWall=10,
    insulationThickness=0,
    inc=1.5707963267949) "Outer wall model"
    annotation (Placement(transformation(extent={{-54,-58},{-44,-38}})));
  IDEAS.Buildings.Components.Zone zone1(
    nSurf=2,
    redeclare package Medium = Medium,
    allowFlowReversal=true,
    V=20) "Second zone"
    annotation (Placement(transformation(extent={{20,-70},{40,-50}})));
  IDEAS.Buildings.Components.Shading.ShadingControl shadingControl
    "Shading control model"
    annotation (Placement(transformation(extent={{-80,-100},{-60,-80}})));
equation
  connect(commonWall.propsBus_a, zone.propsBus[1]) annotation (Line(
      points={{-44,10},{-12,10},{-12,-4.5},{20,-4.5}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(bou.ports[1], zone.flowPort_In) annotation (Line(
      points={{-40,90},{32,90},{32,4.44089e-16}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(internalWall.propsBus_a, zone.propsBus[2]) annotation (Line(
      points={{9,-33.8333},{6,-33.8333},{6,-5.5},{20,-5.5}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(window.propsBus_a, zone1.propsBus[2]) annotation (Line(
      points={{-44,-70},{6,-70},{6,-57},{20,-57}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(outerWall.propsBus_a, zone.propsBus[4]) annotation (Line(
      points={{-44,-46},{-12,-46},{-12,-7.5},{20,-7.5}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(slabOnGround.propsBus_a, zone.propsBus[3]) annotation (Line(
      points={{-44,32},{-12,32},{-12,-6.5},{20,-6.5}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(zone1.flowPort_In, zone.flowPort_In) annotation (Line(
      points={{32,-50},{32,0}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(internalWall.propsBus_b, zone1.propsBus[1]) annotation (Line(
      points={{9,-42.1667},{6.5,-42.1667},{6.5,-55},{20,-55}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(shadingControl.y, window.Ctrl) annotation (Line(
      points={{-60,-84},{-58,-84},{-58,-86},{-53,-86},{-53,-82}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),           __Dymola_Commands(file=
          "Resources/Scripts/Dymola/Buildings/Components/Examples/ZoneExample.mos"
        "Simulate and plot"),
    Documentation(revisions="<html>
<ul>
<li>
July 18, 2016 by Filip Jorissen:<br/>
Cleaned up code and implementation.
</li>
<li>
By Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>"));
end ZoneExample;

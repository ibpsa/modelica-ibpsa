within IDEAS.Buildings.Components.Examples;
model ZoneExample
  package Medium = IDEAS.Media.Air;
  extends Modelica.Icons.Example;
  Zone zone(
    nSurf=4,
    redeclare package Medium = Medium,
    V=2,
    allowFlowReversal=true)
         annotation (Placement(transformation(extent={{20,-20},{40,0}})));
  BoundaryWall
             commonWall(
    redeclare IDEAS.Buildings.Validation.Data.Constructions.HeavyWall
      constructionType,
    redeclare IDEAS.Buildings.Data.Insulation.Rockwool insulationType,
    insulationThickness=0.1,
    AWall=10,
    inc=0,
    azi=0)
    annotation (Placement(transformation(extent={{-54,-2},{-44,18}})));
  Fluid.Sources.Boundary_pT bou(nPorts=1, redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-60,80},{-40,100}})));

  inner SimInfoManager sim
    annotation (Placement(transformation(extent={{-96,76},{-76,96}})));
  InternalWall
             commonWall1(
    redeclare IDEAS.Buildings.Validation.Data.Constructions.HeavyWall
      constructionType,
    redeclare IDEAS.Buildings.Data.Insulation.Rockwool insulationType,
    insulationThickness=0.1,
    AWall=10,
    inc=0,
    azi=0)
    annotation (Placement(transformation(extent={{-5,-10},{5,10}},
        rotation=90,
        origin={11,-38})));
  Window window(
    A=1,
    inc=0,
    azi=0,
    redeclare IDEAS.Buildings.Data.Glazing.Ins2 glazing,
    redeclare IDEAS.Buildings.Data.Interfaces.Frame fraType,
    redeclare IDEAS.Buildings.Components.Shading.Screen shaType)
    annotation (Placement(transformation(extent={{-54,-82},{-44,-62}})));
  SlabOnGround slabOnGround(
    redeclare IDEAS.Buildings.Validation.Data.Constructions.LightWall
      constructionType,
    redeclare IDEAS.Buildings.Data.Insulation.Pir insulationType,
    insulationThickness=0.1,
    AWall=20,
    PWall=3,
    inc=0,
    azi=0) annotation (Placement(transformation(extent={{-54,20},{-44,40}})));
  OuterWall outerWall(
    inc=0,
    azi=0,
    redeclare IDEAS.Buildings.Validation.Data.Constructions.HeavyWall
      constructionType,
    redeclare IDEAS.Buildings.Data.Insulation.Glasswool insulationType,
    AWall=10,
    insulationThickness=0)
    annotation (Placement(transformation(extent={{-54,-58},{-44,-38}})));
  Zone zone1(
    nSurf=2,
    redeclare package Medium = Medium,
    V=2,
    allowFlowReversal=true)
         annotation (Placement(transformation(extent={{20,-70},{40,-50}})));
  Shading.ShadingControl shadingControl
    annotation (Placement(transformation(extent={{-80,-100},{-60,-80}})));
equation
  connect(commonWall.propsBus_a, zone.propsBus[1]) annotation (Line(
      points={{-44,12},{-12,12},{-12,-4.5},{20,-4.5}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(bou.ports[1], zone.flowPort_In) annotation (Line(
      points={{-40,90},{32,90},{32,4.44089e-16}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(commonWall1.propsBus_a, zone.propsBus[2]) annotation (Line(
      points={{7,-33},{6,-33},{6,-5.5},{20,-5.5}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(window.propsBus_a, zone1.propsBus[2]) annotation (Line(
      points={{-44,-68},{6,-68},{6,-57},{20,-57}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(outerWall.propsBus_a, zone.propsBus[4]) annotation (Line(
      points={{-44,-44},{-12,-44},{-12,-7.5},{20,-7.5}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(slabOnGround.propsBus_a, zone.propsBus[3]) annotation (Line(
      points={{-44,34},{-12,34},{-12,-6.5},{20,-6.5}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(zone1.flowPort_In, zone.flowPort_In) annotation (Line(
      points={{32,-50},{32,0}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(commonWall1.propsBus_b, zone1.propsBus[1]) annotation (Line(
      points={{7,-43},{6.5,-43},{6.5,-55},{20,-55}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(shadingControl.y, window.Ctrl) annotation (Line(
      points={{-60,-84},{-58,-84},{-58,-86},{-52,-86},{-52,-82}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics));
end ZoneExample;

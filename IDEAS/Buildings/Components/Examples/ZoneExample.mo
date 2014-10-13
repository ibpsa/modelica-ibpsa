within IDEAS.Buildings.Components.Examples;
model ZoneExample
  package Medium = IDEAS.Media.Air;
  extends Modelica.Icons.Example;
  Zone zone(
    nSurf=5,
    redeclare package Medium = Medium,
    V=2) annotation (Placement(transformation(extent={{20,-20},{40,0}})));
  CommonWall commonWall(
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
  Fluid.Sources.MassFlowSource_T boundary(nPorts=1, redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));

  inner SimInfoManager sim
    annotation (Placement(transformation(extent={{-96,76},{-76,96}})));
  CommonWall commonWall1(
    redeclare IDEAS.Buildings.Validation.Data.Constructions.HeavyWall
      constructionType,
    redeclare IDEAS.Buildings.Data.Insulation.Rockwool insulationType,
    insulationThickness=0.1,
    AWall=10,
    inc=0,
    azi=0)
    annotation (Placement(transformation(extent={{-54,-26},{-44,-6}})));
  Window window(
    A=1,
    inc=0,
    azi=0,
    redeclare IDEAS.Buildings.Data.Glazing.Ins2 glazing,
    redeclare IDEAS.Buildings.Data.Interfaces.Frame fraType,
    redeclare IDEAS.Buildings.Components.Shading.None shaType)
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
equation
  connect(commonWall.propsBus_a, zone.propsBus[1]) annotation (Line(
      points={{-44,12},{-42,12},{-42,-4.4},{20,-4.4}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(bou.ports[1], zone.flowPort_In) annotation (Line(
      points={{-40,90},{32,90},{32,4.44089e-16}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(boundary.ports[1], zone.flowPort_Out) annotation (Line(
      points={{-40,50},{28,50},{28,4.44089e-16}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(commonWall1.propsBus_a, zone.propsBus[2]) annotation (Line(
      points={{-44,-12},{-42,-12},{-42,-5.2},{20,-5.2}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(window.propsBus_a, zone.propsBus[3]) annotation (Line(
      points={{-44,-68},{-32,-68},{-32,-6},{20,-6}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(slabOnGround.propsBus_a, zone.propsBus[4]) annotation (Line(
      points={{-44,34},{-28,34},{-28,-6.8},{20,-6.8}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(outerWall.propsBus_a, zone.propsBus[5]) annotation (Line(
      points={{-44,-44},{20,-44},{20,-7.6}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics));
end ZoneExample;

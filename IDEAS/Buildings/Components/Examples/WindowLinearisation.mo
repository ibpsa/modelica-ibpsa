within IDEAS.Buildings.Components.Examples;
model WindowLinearisation
  "Comparison of linear / non-linear convection equations"
  package Medium = IDEAS.Media.Air;
  extends Modelica.Icons.Example;
  Fluid.Sources.Boundary_pT bou(          redeclare package Medium = Medium,
      nPorts=1)
    annotation (Placement(transformation(extent={{-60,80},{-40,100}})));

  inner SimInfoManager sim
    annotation (Placement(transformation(extent={{-96,76},{-76,96}})));
  OuterWall outerWall(
    azi=0,
    redeclare parameter IDEAS.Buildings.Validation.Data.Constructions.HeavyWall
      constructionType,
    redeclare parameter IDEAS.Buildings.Data.Insulation.Glasswool insulationType,
    AWall=10,
    insulationThickness=0,
    inc=IDEAS.Constants.Floor)
    annotation (Placement(transformation(extent={{-54,0},{-44,20}})));
  Zone zone1(
    redeclare package Medium = Medium,
    allowFlowReversal=true,
    V=20,
    nSurf=3)
         annotation (Placement(transformation(extent={{20,-70},{40,-50}})));
  Window winNonLin(
    A=1,
    redeclare parameter IDEAS.Buildings.Data.Glazing.Ins2 glazing,
    redeclare IDEAS.Buildings.Data.Frames.Pvc fraType,
    layMul(linIntCon=false),
    inc=IDEAS.Constants.Wall,
    azi=IDEAS.Constants.South)
    "Window with non-linear convection correlations inside the window"
    annotation (Placement(transformation(extent={{-54,-32},{-44,-12}})));
  Window winLin(
    A=1,
    redeclare parameter IDEAS.Buildings.Data.Glazing.Ins2 glazing,
    redeclare IDEAS.Buildings.Data.Frames.Pvc fraType,
    layMul(linIntCon=true),
    inc=IDEAS.Constants.Wall,
    azi=IDEAS.Constants.South)
    "Window with linear convection correlations inside the window"
    annotation (Placement(transformation(extent={{-54,-56},{-44,-36}})));
equation
  connect(zone1.propsBus[1], outerWall.propsBus_a) annotation (Line(
      points={{20,-54.6667},{20,-54.6667},{20,-6},{20,14},{-44,14}},
      color={255,204,51},
      thickness=0.5));
  connect(winNonLin.propsBus_a, zone1.propsBus[2]) annotation (Line(
      points={{-44,-18},{-28,-18},{-28,-16},{20,-16},{20,-56}},
      color={255,204,51},
      thickness=0.5));
  connect(winLin.propsBus_a, zone1.propsBus[3]) annotation (Line(
      points={{-44,-42},{-32,-42},{20,-42},{20,-57.3333}},
      color={255,204,51},
      thickness=0.5));
  connect(zone1.flowPort_In, bou.ports[1])
    annotation (Line(points={{32,-50},{32,90},{-40,90}}, color={0,0,0}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),           __Dymola_Commands(file=
          "Resources/Scripts/Dymola/Buildings/Components/Examples/WindowLinearisation.mos"
        "Simulate and plot"),
    Documentation(revisions="<html>
<ul>
<li>
February 10, 2016, by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>"),
    experiment(StopTime=1e+06, __Dymola_Algorithm="Lsodar"),
    __Dymola_experimentSetupOutput);
end WindowLinearisation;

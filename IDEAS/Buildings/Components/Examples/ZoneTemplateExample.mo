within IDEAS.Buildings.Components.Examples;
model ZoneTemplateExample
  "Example model demonstrating how zones may be connected to surfaces"
  package Medium = IDEAS.Media.Air;
  extends Modelica.Icons.Example;
  inner BoundaryConditions.SimInfoManager sim "Data reader"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));

  RectangularZoneTemplate rectangularZoneTemplate(
    l=4,
    w=4,
    h=3,
    A_winC=4,
    redeclare Validation.Data.Constructions.HeavyWall constructionTypeA,
    redeclare Validation.Data.Constructions.HeavyWall constructionTypeB,
    redeclare Validation.Data.Constructions.HeavyWall constructionTypeC,
    redeclare Validation.Data.Constructions.HeavyWall constructionTypeD,
    redeclare Validation.Data.Constructions.LightRoof constructionTypeCei,
    redeclare Validation.Data.Constructions.HeavyFloor constructionTypeFlo,
    redeclare Data.Glazing.GlaBesTest glazingC,
    redeclare Data.Glazing.Ins2Kr glazingD,
    redeclare package Medium = Medium,
    A_winD=3,
    aziA=IDEAS.Types.Azimuth.S,
    bouTypCei=IDEAS.Buildings.Components.Interfaces.BoundaryType.BoundaryWall,
    bouTypA=IDEAS.Buildings.Components.Interfaces.BoundaryType.OuterWall,
    bouTypB=IDEAS.Buildings.Components.Interfaces.BoundaryType.OuterWall,
    bouTypC=IDEAS.Buildings.Components.Interfaces.BoundaryType.OuterWallAndWindow,
    bouTypFlo=IDEAS.Buildings.Components.Interfaces.BoundaryType.SlabOnGround,
    bouTypD=IDEAS.Buildings.Components.Interfaces.BoundaryType.OuterWallAndWindow)
    "Rectangular zone template"
    annotation (Placement(transformation(extent={{-20,-20},{0,0}})));

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
</html>"),
    experiment(StopTime=1e+06));
end ZoneTemplateExample;

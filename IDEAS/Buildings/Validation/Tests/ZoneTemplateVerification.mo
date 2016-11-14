within IDEAS.Buildings.Validation.Tests;
model ZoneTemplateVerification
  import IDEAS;
  extends Modelica.Icons.Example;



  IDEAS.Buildings.Validation.BaseClasses.Structure.Bui900 bui900
    annotation (Placement(transformation(extent={{-24,40},{6,60}})));
  IDEAS.Buildings.Components.RectangularZoneTemplate rectangularZoneTemplate(
    h=2.7,
    redeclare package Medium = Media.Air,
    nSurfExt=0,
    aziA=IDEAS.Types.Azimuth.N,
    l=8,
    w=6,
    n50=0.822*0.5*20,
    redeclare Components.ZoneAirModels.WellMixedAir airModel,
    T_start=293.15,
    bouTypA=IDEAS.Buildings.Components.Interfaces.BoundaryType.OuterWall,
    bouTypB=IDEAS.Buildings.Components.Interfaces.BoundaryType.OuterWall,
    bouTypC=IDEAS.Buildings.Components.Interfaces.BoundaryType.OuterWall,
    bouTypD=IDEAS.Buildings.Components.Interfaces.BoundaryType.OuterWall,
    bouTypCei=IDEAS.Buildings.Components.Interfaces.BoundaryType.OuterWall,
    hasWinCei=false,
    redeclare IDEAS.Buildings.Validation.Data.Constructions.LightRoof constructionTypeCei,
    bouTypFlo=IDEAS.Buildings.Components.Interfaces.BoundaryType.BoundaryWall,
    redeclare Data.Constructions.HeavyFloor constructionTypeFlo,
    redeclare Data.Constructions.HeavyWall constructionTypeA,
    redeclare Data.Constructions.HeavyWall constructionTypeB,
    redeclare Data.Constructions.HeavyWall constructionTypeC,
    redeclare Data.Constructions.HeavyWall constructionTypeD,
    hasWinA=true,
    A_winA=12,
    fracA=0,
    redeclare IDEAS.Buildings.Data.Glazing.GlaBesTest glazingA,
    redeclare IDEAS.Buildings.Components.Shading.Interfaces.ShadingProperties
      shaTypA,
    hasWinB=false,
    hasWinC=false,
    hasWinD=false)
    annotation (Placement(transformation(extent={{-20,-20},{0,0}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=1e+06),
    Documentation(info="<html>
<p>
This model compares Bestest case 900 with an implementation of the same model using the ZoneTemplate model.
</p>
</html>", revisions="<html>
<ul>
<li>
November 14, 2016 by Filip Jorissen:<br/>
First implementation
</li>
</ul>
</html>"),
    __Dymola_Commands(file=
          "Resources/Scripts/Dymola/Buildings/Validation/Tests/ZoneTemplateVerification.mos"
        "Simulate and plot"));
end ZoneTemplateVerification;

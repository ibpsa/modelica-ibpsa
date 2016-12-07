within IDEAS.Buildings.Validation.Tests;
model ZoneTemplateVerification
  import IDEAS;
  extends Modelica.Icons.Example;
  IDEAS.Buildings.Components.Window win(
    final A=6,
    redeclare final parameter Data.Glazing.GlaBesTest glazing,
    final inc=IDEAS.Types.Tilt.Wall,
    azi=IDEAS.Types.Azimuth.S,
    redeclare replaceable IDEAS.Buildings.Components.Shading.None shaType,
    redeclare final parameter IDEAS.Buildings.Data.Frames.None fraType,
    frac=0) "Second window of bestest house"
    annotation (Placement(transformation(
        extent={{-5,-10},{5,10}},
        rotation=90,
        origin={27,-18})));


  IDEAS.Buildings.Validation.BaseClasses.Structure.Bui900 bui900
    annotation (Placement(transformation(extent={{-24,40},{6,60}})));
  IDEAS.Buildings.Components.RectangularZoneTemplate rectangularZoneTemplate(
    h=2.7,
    redeclare package Medium = IDEAS.Media.Air,
    n50=0.822*0.5*20,
    redeclare Components.ZoneAirModels.WellMixedAir airModel,
    T_start=293.15,
    bouTypA=IDEAS.Buildings.Components.Interfaces.BoundaryType.OuterWall,
    bouTypB=IDEAS.Buildings.Components.Interfaces.BoundaryType.OuterWall,
    bouTypC=IDEAS.Buildings.Components.Interfaces.BoundaryType.OuterWall,
    bouTypCei=IDEAS.Buildings.Components.Interfaces.BoundaryType.OuterWall,
    hasWinCei=false,
    redeclare IDEAS.Buildings.Validation.Data.Constructions.LightRoof conTypCei,
    bouTypFlo=IDEAS.Buildings.Components.Interfaces.BoundaryType.BoundaryWall,
    redeclare Data.Constructions.HeavyFloor conTypFlo,
    redeclare Data.Constructions.HeavyWall conTypA,
    redeclare Data.Constructions.HeavyWall conTypB,
    redeclare Data.Constructions.HeavyWall conTypC,
    redeclare Data.Constructions.HeavyWall conTypD,
    hasWinA=true,
    fracA=0,
    redeclare IDEAS.Buildings.Data.Glazing.GlaBesTest glazingA,
    redeclare IDEAS.Buildings.Components.Shading.Interfaces.ShadingProperties
      shaTypA,
    hasWinB=false,
    hasWinC=false,
    hasWinD=false,
    bouTypD=IDEAS.Buildings.Components.Interfaces.BoundaryType.OuterWall,
    aziA=IDEAS.Types.Azimuth.S,
    mSenFac=0.822,
    l=8,
    w=6,
    A_winA=6,
    outA(AWall=9.6),
    nSurfExt=1)
    annotation (Placement(transformation(extent={{0,-20},{-20,0}})));
  inner IDEAS.BoundaryConditions.SimInfoManager sim
    "Simulation information manager for climate data"
    annotation (Placement(transformation(extent={{-100,60},{-80,80}})));
equation
  connect(win.propsBus_a, rectangularZoneTemplate.proBusExt[1]) annotation (
      Line(
      points={{25,-13},{25,0},{2,0}},
      color={255,204,51},
      thickness=0.5));
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

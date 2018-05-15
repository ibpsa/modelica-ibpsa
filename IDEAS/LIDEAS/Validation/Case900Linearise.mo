within IDEAS.LIDEAS.Validation;
model Case900Linearise
  extends LIDEAS.Components.LinearisationInterface(sim(nWindow=1));
  extends Modelica.Icons.Example;
  Components.LinRectangularZoneTemplate linRecZon(
    h=2.7,
    redeclare package Medium = IDEAS.Media.Air,
    n50=0.822*0.5*20,
    bouTypA=IDEAS.Buildings.Components.Interfaces.BoundaryType.OuterWall,
    bouTypB=IDEAS.Buildings.Components.Interfaces.BoundaryType.OuterWall,
    bouTypC=IDEAS.Buildings.Components.Interfaces.BoundaryType.OuterWall,
    bouTypCei=IDEAS.Buildings.Components.Interfaces.BoundaryType.OuterWall,
    hasWinCei=false,
    redeclare IDEAS.Buildings.Validation.Data.Constructions.LightRoof conTypCei,
    bouTypFlo=IDEAS.Buildings.Components.Interfaces.BoundaryType.BoundaryWall,
    redeclare IDEAS.Buildings.Validation.Data.Constructions.HeavyFloor conTypFlo,
    redeclare IDEAS.Buildings.Validation.Data.Constructions.HeavyWall conTypA,
    redeclare IDEAS.Buildings.Validation.Data.Constructions.HeavyWall conTypB,
    redeclare IDEAS.Buildings.Validation.Data.Constructions.HeavyWall conTypC,
    redeclare IDEAS.Buildings.Validation.Data.Constructions.HeavyWall conTypD,
    hasWinA=true,
    fracA=0,
    redeclare IDEAS.Buildings.Validation.Data.Glazing.GlaBesTest glazingA,
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
    A_winA=12,
    indexWindowA=1,
    T_start=293.15)
    annotation (Placement(transformation(extent={{-10,60},{10,80}})));
  Modelica.Blocks.Interfaces.RealOutput TSenLinRecZon if sim.linearise
    "Sensor temperature of the zone, i.e. operative temeprature"
    annotation (Placement(transformation(extent={{96,80},{116,100}})));
equation
  connect(linRecZon.TSensor, TSenLinRecZon) annotation (Line(points={{10.6,70},{
          16,70},{20,70},{20,90},{106,90}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),           __Dymola_Commands(file=
          "Scripts/linearize_Case900Linearise.mos" "Linearise"),
    Documentation(revisions="<html>
<ul>
<li>May 15, 2018 by Damien Picard: <br>First implementation</li>
</ul>
</html>"));
end Case900Linearise;

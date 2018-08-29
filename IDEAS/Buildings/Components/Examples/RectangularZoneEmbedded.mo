within IDEAS.Buildings.Components.Examples;
model RectangularZoneEmbedded
  "This model test the implementation of embedded heat port"
  extends RectangularZone(zone(
      bouTypFlo=IDEAS.Buildings.Components.Interfaces.BoundaryType.BoundaryWall,
      redeclare IDEAS.Buildings.Data.Constructions.FloorOnGround conTypFlo,
      hasEmb=true,
      nGainEmb=1), zoneIntWal(
      bouTypFlo=IDEAS.Buildings.Components.Interfaces.BoundaryType.InternalWall,
      nSurfExt=1,
      redeclare IDEAS.Buildings.Data.Constructions.FloorOnGround conTypFlo,
      hasEmb=true,
      nGainEmb=1));

  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow(Q_flow=1000)
    annotation (Placement(transformation(extent={{80,12},{60,32}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow1(Q_flow=1000)
    annotation (Placement(transformation(extent={{80,-68},{60,-48}})));
equation
  connect(zoneIntWal.proBusFlo, zoneIntWal.proBusExt[1]) annotation (Line(
      points={{0,-52},{0,-76},{-42,-76},{-42,-20},{-24,-20}},
      color={255,204,51},
      thickness=0.5));
  connect(fixedHeatFlow.port, zone.gainEmb[1])
    annotation (Line(points={{60,22},{20,22}}, color={191,0,0}));
  connect(fixedHeatFlow1.port, zoneIntWal.gainEmb[1])
    annotation (Line(points={{60,-58},{20,-58}}, color={191,0,0}));


    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=604800,
      Tolerance=1e-006,
      __Dymola_Algorithm="Lsodar"),
    Documentation(info="<html>
<p>
This example illustrates how to implement floorheating or CCA in RectangularZoneTemplate.
</p>
</html>", revisions="<html>
<ul>
<li>
August 29, 2018 by Damien Picard:<br/>
First implementation
</li>
</ul>
</html>"),
    __Dymola_Commands(file(inherit=true) = "Resources/Scripts/Dymola/Buildings/Components/Examples/RectangularZoneEmbedded.mos"
        "Simulate and Plot"));
end RectangularZoneEmbedded;

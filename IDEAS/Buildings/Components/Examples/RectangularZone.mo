within IDEAS.Buildings.Components.Examples;
model RectangularZone
  "Example that compares a zone with internal wall and without internal wall"
  import IDEAS;
  extends Modelica.Icons.Example;
  Validation.Cases.Case900Template zoneIntWal(
    hasIntZone=true,
    lIntZone=zoneIntWal.lA*3,
    redeclare IDEAS.Examples.PPD12.Data.InteriorWall18 conTypIntZone)
                                              "Zone with internal wall"
    annotation (Placement(transformation(extent={{-24,-60},{20,-18}})));
  Validation.Cases.Case900Template zone "Unshaded zone"
    annotation (Placement(transformation(extent={{-22,18},{20,60}})));
  inner BoundaryConditions.SimInfoManager       sim
    "Simulation information manager for climate data"
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=604800,
      Tolerance=1e-006,
      __Dymola_Algorithm="Lsodar"),
    Documentation(info="<html>
<p>
This example illustrates the impact of external shading 
on the building facade for the Case 900 example model.
</p>
</html>", revisions="<html>
<ul>
<li>
June 13, 2018 by Filip Jorissen:<br/>
First implementation
See <a href=\"https://github.com/open-ideas/IDEAS/issues/576\">#576</a>.
</li>
</ul>
</html>"),
    __Dymola_Commands(file(inherit=true) = "Resources/Scripts/Dymola/Buildings/Components/Examples/RectangularZone.mos"
        "Simulate and Plot"));
end RectangularZone;

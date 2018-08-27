within IDEAS.Buildings.Components.Examples;
model RectangularZone2
  "Example that illustrates the redeclaration of windows using the RectangularZoneTemplate model"
  extends IDEAS.Buildings.Components.Examples.RectangularZone(
    zoneIntWal(hasInt=false,
    redeclare BaseClasses.Window winA));
  annotation (experiment(StopTime=1000000), Documentation(revisions="<html>
<ul>
<li>
August 10, 2018 by Damien Picard:<br/>
First implementation
</li>
</ul>
</html>", info="<html>
<p>
This example illustrates the redeclaration of windows using the rectangular zone template.
</p>
</html>"));
end RectangularZone2;

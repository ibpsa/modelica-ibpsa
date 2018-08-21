within IDEAS.Buildings.Components.Examples;
model RectangularZone2
  "Example which test the redeclaration of windows in rectangularZoneTemplate model"
  extends RectangularZone(zoneIntWal(hasInt=false, redeclare BaseClasses.window
        winA));
  annotation (experiment(StopTime=1000000));
end RectangularZone2;

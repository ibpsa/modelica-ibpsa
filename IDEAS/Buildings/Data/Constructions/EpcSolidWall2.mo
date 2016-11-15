within IDEAS.Buildings.Data.Constructions;
record EpcSolidWall2 "EPC: muurtype 2 / wall type 2"

  extends IDEAS.Buildings.Data.Interfaces.Construction(
    final mats={
      Materials.BrickMe(d=0.15),
      insulationType,
      Materials.BrickMi(d=0.15)});

  annotation (Documentation(info="<html>
<p>
Implementation of the Belgian EPC 'wall type 2'.
</p>
</html>"));
end EpcSolidWall2;

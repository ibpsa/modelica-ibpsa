within IDEAS.Buildings.Data.Constructions;
record EpcSolidWall2 "EPC: muurtype 2 / wall type 2"

  extends IDEAS.Buildings.Data.Interfaces.Construction(
    nLay=3,
    locGain=2,
    final mats={
      Materials.BrickMe(d=0.15),
      insulationType,
      Materials.BrickMi(d=0.15)});

end EpcSolidWall2;

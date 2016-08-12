within IDEAS.Buildings.Validation.Data.Constructions;
record LightWall "BESTEST Light wall"

  extends IDEAS.Buildings.Data.Interfaces.Construction(
    final nLay=3,
    final mats={
      IDEAS.Buildings.Validation.Data.Materials.WoodSiding(d=0.009),
      insulationType,
      IDEAS.Buildings.Validation.Data.Materials.PlasterBoard(d=0.012)});

end LightWall;

within IDEAS.Buildings.Validation.Data.Constructions;
record LightWall "BESTEST Light wall"

  extends IDEAS.Buildings.Data.Interfaces.Construction(
    final mats={Materials.WoodSiding(d=0.009),insulationType,
        Materials.PlasterBoard(d=0.012)});

end LightWall;
